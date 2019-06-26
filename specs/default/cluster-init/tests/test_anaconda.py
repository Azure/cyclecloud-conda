#!/opt/cycle/jetpack/system/embedded/bin/python -m pytest
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.
import os
import subprocess
import jetpack.config

ANACONDA_VERSION = jetpack.config.get("anaconda.version").strip()


def test_basic():
    anaconda_license = "/opt/anaconda/%s/LICENSE.txt" % ANACONDA_VERSION
    assert os.path.isfile(anaconda_license)


def test_excercise_conda():
    subprocess.check_call(['conda', 'create', '-y', '-c', 'conda-forge', '-n', 'test-env', 'python=2.7', 'numpy'])

    # Source is a native bash function, so need a shell for this to work
    subprocess.check_call(['source', 'activate', 'test-env'], shell=True)

    # This is the actual sanity test, should be in the test-env venv
    # and numpy should be available.
    subprocess.check_call(['python', '-c', '"import numpy"'])

    # conda env teardown
    subprocess.check_call(['conda', 'env', 'remove', '-y', '-n', 'test-env'])
