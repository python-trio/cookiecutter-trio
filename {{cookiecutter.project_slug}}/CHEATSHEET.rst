Finishing setting up your project
=================================

Thanks for using cookiecutter-trio! This is your project now; you can
customize it however you like. Here's some reminders of things you
might want to do to get started:

* Check this into source control (``git init .; git add .; git
  commit -m "Initial commit"``)

* Fill in your README.rst

* Add a CODE_OF_CONDUCT.md

* Add a CONTRIBUTING.md

* Search for COOKIECUTTER-TRIO-TODO

{-% if cookiecutter._license_info[cookiecutter.license].slug == "other" %}
* Since you selected an "other" license: remove LICENSE-IS-MISSING and
  add a LICENSE file, and update ``setup.py`` and ``README.rst`` to
  tell people your license choice.

{% endif -%}
* Set up RTD

  - ci/rtd-requirements.txt

* Review Travis & Appveyor configuration, and then set them up

* Set up Codecov

* File bugs or pull requests on `cookiecutter-trio
  <https://github.com/python-trio/cookiecutter-trio>`__ reporting any
  problems or awkwardness you ran into (no matter how small!)

* Delete this checklist once it's no longer useful


Tips
====

To run tests:

* Install requirements: ``pip install -r test-requirements.txt``
  (possibly in a virtualenv)

* Actually run the tests: ``pytest {{cookiecutter.package_name}}``

To run yapf:

* Show what changes yapf wants to make: ``yapf -rpd setup.py
  {{cookiecutter.package_name}}``

* Apply all changes directly to the source tree: ``yapf -rpi setup.py
  {{cookiecutter.package_name}}``

To make a release:

* Update the version in ``{{cookiecutter.package_name}}/_version.py``

* Run towncrier (XX)

* ...

To upload to pypi:

* ...
