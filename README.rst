cookiecutter-trio
=================

This is a cookiecutter template for Python projects using `Trio
<https://trio.readthedocs.io>`__. It makes it easy to start a new
project.

You don't have to use this – Trio's just an ordinary Python package
that you can use like any other, and if you already have a preferred
way of setting up Python projects, then go for it. But using this
template sets up a number of handy things:

* pytest with trio integration
* sphinx docs with sphinxcontrib-trio enabled
* Readthedocs to publish your docs
* Using Travis and Appveyor to test your package on all the different
  platforms Trio supports: Windows + MacOS + Linux, CPython + PyPy
* Codecov to track code coverage information
* towncrier for easy release note management
* yapf so you don't have to think about formatting

This is the same setup used to develop Trio itself and many related
projects, so using it makes it easy for new contributors to get
started.


XX ughhh what are we going to do about in-tree tests vs. out-of-tree
tests.


Let's do this!
--------------

1. ``pip install -U cookiecutter`` (or check out the `detailed
   cookiecutter install instructions
   <https://cookiecutter.readthedocs.io/en/latest/installation.html>`__)
2. ``cookiecutter gh:python-trio/cookiecutter-trio``
3. Answer the questions. This will create a directory named after your
   project (e.g., if you said your project is called
   ``superwhizbang``, then there will be a directory called
   ``superwhizbang/``).
4. Look through ``{your project}/NEW-PROJECT-TODO.rst`` for a
   checklist of things to think about.


License
-------

This cookiecutter template is released under the CC0 Public Domain
Dedication – see the file LICENSE for details. Basically what this
means is that you can use it for any kind of project you want under
whatever license terms you want, and you don't even have to worry
about giving us credit or anything like that.
