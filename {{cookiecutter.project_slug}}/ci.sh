#!/bin/bash

set -ex -o pipefail

# Log some general info about the environment
env | sort

if [ "$JOB_NAME" = "" ]; then
    JOB_NAME="${TRAVIS_OS_NAME}-${TRAVIS_PYTHON_VERSION:-unknown}"
fi

# Curl's built-in retry system is not very robust; it gives up on lots of
# network errors that we want to retry on. Wget might work better, but it's
# not installed on azure pipelines's windows boxes. So... let's try some good
# old-fashioned brute force. (This is also a convenient place to put options
# we always want, like -f to tell curl to give an error if the server sends an
# error response, and -L to follow redirects.)
function curl-harder() {
    for BACKOFF in 0 1 2 4 8 15 15 15 15; do
        sleep $BACKOFF
        if curl -fL --connect-timeout 5 "$@"; then
            return 0
        fi
    done
    return 1
}

################################################################
# Bootstrap python environment, if necessary
################################################################

### Alpine ###

if [ -e /etc/alpine-release ]; then
    apk add --no-cache gcc musl-dev libffi-dev openssl-dev python3-dev curl
    python3 -m venv venv
    source venv/bin/activate
fi

### PyPy nightly (currently on Travis) ###

if [ "$PYPY_NIGHTLY_BRANCH" != "" ]; then
    JOB_NAME="pypy_nightly_${PYPY_NIGHTLY_BRANCH}"
    curl-harder -o pypy.tar.bz2 http://buildbot.pypy.org/nightly/${PYPY_NIGHTLY_BRANCH}/pypy-c-jit-latest-linux64.tar.bz2
    if [ ! -s pypy.tar.bz2 ]; then
        # We know:
        # - curl succeeded (200 response code)
        # - nonetheless, pypy.tar.bz2 does not exist, or contains no data
        # This isn't going to work, and the failure is not informative of
        # anything involving Trio.
        ls -l
        echo "PyPy3 nightly build failed to download – something is wrong on their end."
        echo "Skipping testing against the nightly build for right now."
        exit 0
    fi
    tar xaf pypy.tar.bz2
    # something like "pypy-c-jit-89963-748aa3022295-linux64"
    PYPY_DIR=$(echo pypy-c-jit-*)
    PYTHON_EXE=$PYPY_DIR/bin/pypy3

    if ! ($PYTHON_EXE -m ensurepip \
              && $PYTHON_EXE -m pip install virtualenv \
              && $PYTHON_EXE -m virtualenv testenv); then
        echo "pypy nightly is broken; skipping tests"
        exit 0
    fi
    source testenv/bin/activate
fi

################################################################
# We have a Python environment!
################################################################

python -c "import sys, struct, ssl; print('#' * 70); print('python:', sys.version); print('version_info:', sys.version_info); print('bits:', struct.calcsize('P') * 8); print('openssl:', ssl.OPENSSL_VERSION, ssl.OPENSSL_VERSION_INFO); print('#' * 70)"

python -m pip install -U pip setuptools wheel pep517
python -m pip --version

python -m pep517.build --source --out-dir dist/ .
python -m pip install dist/*.tar.gz

if [ "$CHECK_DOCS" = "1" ]; then
    python -m pip install -r docs-requirements.txt
    towncrier --yes  # catch errors in newsfragments
    cd docs
    # -n (nit-picky): warn on missing references
    # -W: turn warnings into errors
    sphinx-build -nW  -b html source build
elif [ "$CHECK_LINT" = "1" ]; then
    python -m pip install -r test-requirements.txt
    source check.sh
else
    # Actual tests
    python -m pip install -r test-requirements.txt

    mkdir empty
    cd empty

    INSTALLDIR=$(python -c "import os, {{cookiecutter.package_name}}; print(os.path.dirname({{cookiecutter.package_name}}.__file__))")
    cp ../setup.cfg $INSTALLDIR
    # We have to copy .coveragerc into this directory, rather than passing
    # --cov-config=../.coveragerc to pytest, because codecov.sh will run
    # 'coverage xml' to generate the report that it uses, and that will only
    # apply the ignore patterns in the current directory's .coveragerc.
    cp ../.coveragerc .
    if pytest -W error -ra --junitxml=../test-results.xml ${INSTALLDIR} --cov="$INSTALLDIR" --verbose; then
        PASSED=true
    else
        PASSED=false
    fi

    # Flag pypy and cpython coverage differently, until it settles down...
    FLAG="cpython"
    if [[ "$PYPY_NIGHTLY_BRANCH" == "py3.6" ]]; then
        FLAG="pypy36nightly"
    elif [[ "$(python -V)" == *PyPy* ]]; then
        FLAG="pypy36release"
    fi

    # The codecov docs recommend something like 'bash <(curl ...)' to pipe the
    # script directly into bash as its being downloaded. But, the codecov
    # server is flaky, so we instead save to a temp file with retries, and
    # wait until we've successfully fetched the whole script before trying to
    # run it.
    curl-harder -o codecov.sh https://codecov.io/bash
    bash codecov.sh -n "${JOB_NAME}" -F "$FLAG"

    $PASSED
fi
