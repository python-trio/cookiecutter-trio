from setuptools import setup, find_packages

exec(open("{{cookiecutter.package_name}}/_version.py", encoding="utf-8").read())

LONG_DESC = open("README.rst").read()

setup(
    name="{{cookiecutter.project_slug}}",
    version=__version__,
    description="{{cookiecutter.project_short_description}}",
    url="{{cookiecutter.project_url}}",
    long_description=open("README.rst").read(),
    author="{{cookiecutter.full_name}}",
    author_email="{{cookiecutter.email}}",
    license="{{cookiecutter._license_info[cookiecutter.license].license_field}}",
    packages=find_packages(),
    install_requires=[
        "trio",
    ],
    keywords=[
        # COOKIECUTTER-TODO: add some keywords
        # "async", "io", "networking", ...
    ],
    {% if cookiecutter["test_on_cpython_35"] == "y" -%}
    python_requires=">=3.5",
    {%- else -%}
    python_requires=">=3.6",
    {%- endif %}
    classifiers=[
        {% for classifier in cookiecutter["_license_info"][cookiecutter.license]["trove"] -%}
        "{{classifier}}",
        {% endfor -%}
        {% if cookiecutter.test_on_linux == "y" -%}
        "Operating System :: POSIX :: Linux",
        {% endif -%}
        {% if cookiecutter.test_on_macos == "y" -%}
        "Operating System :: MacOS :: MacOS X",
        {% endif -%}
        {% if cookiecutter.test_on_windows == "y" -%}
        "Operating System :: Microsoft :: Windows",
        {% endif -%}
        "Programming Language :: Python :: 3 :: Only",
        {% if cookiecutter.test_on_cpython_35 == "y" or cookiecutter.test_on_cpython_36 -%}
        "Programming Language :: Python :: Implementation :: CPython",
        {% endif -%}
        {% if cookiecutter.test_on_pypy3 == "y" -%}
        "Programming Language :: Python :: Implementation :: PyPy",
        {% endif -%}
        # COOKIECUTTER-TODO: Consider adding:
        # - Development Status
        # - Intended Audience
        # - Topic
    ],
)
