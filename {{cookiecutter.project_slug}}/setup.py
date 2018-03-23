from setuptools import setup, find_packages

exec(open("{{cookiecutter.package_name}}/_version.py", encoding="utf-8").read())

LONG_DESC = open("README.rst", encoding="utf-8").read()

setup(
    name="{{cookiecutter.project_slug}}",
    version=__version__,
    description="{{cookiecutter.project_short_description}}",
    url="{{cookiecutter.project_url}}",
    long_description=LONG_DESC,
    author="{{cookiecutter.full_name}}",
    author_email="{{cookiecutter.email}}",
    license="{{cookiecutter._license_info[cookiecutter.license].license_field}}",
    packages=find_packages(),
    install_requires=[
        "trio",
    ],
    keywords=[
        # COOKIECUTTER-TRIO-TODO: add some keywords
        # "async", "io", "networking", ...
    ],
    python_requires=">={{ cookiecutter.earliest_supported_python }}",
    classifiers=[
        {% for classifier in cookiecutter["_license_info"][cookiecutter.license]["trove"] -%}
        "{{classifier}}",
        {% endfor -%}
        "Framework :: Trio",
        # COOKIECUTTER-TRIO-TODO: Remove any of these classifiers that don't
        # apply:
        "Operating System :: POSIX :: Linux",
        "Operating System :: MacOS :: MacOS X",
        "Operating System :: Microsoft :: Windows",
        "Programming Language :: Python :: 3 :: Only",
        "Programming Language :: Python :: Implementation :: CPython",
        "Programming Language :: Python :: Implementation :: PyPy",
        # COOKIECUTTER-TRIO-TODO: Consider adding trove classifiers for:
        #
        # - Development Status
        # - Intended Audience
        # - Topic
        #
        # For the full list of options, see:
        #   https://pypi.python.org/pypi?%3Aaction=list_classifiers
    ],
)
