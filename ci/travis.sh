#!/bin/bash

set -exu -o pipefail

pip install -r test-requirements.txt

pytest tests/
