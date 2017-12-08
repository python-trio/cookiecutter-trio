from os.path import join
import glob
import shutil

license_slug = '{{ cookiecutter["_license_info"][cookiecutter.license]["slug"] }}'

for path in glob.glob(join("license-files", license_slug, "*")):
    shutil.move(path, ".")

shutil.rmtree("license-files")
