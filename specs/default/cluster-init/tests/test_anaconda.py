# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.
import unittest
import os
import jetpack.util
import jetpack.config

ANACONDA_VERSION = jetpack.config.get("anaconda.version").strip()


class TestMaster(unittest.TestCase):
    
    def test_basic(self):
        anaconda_license = "/opt/anaconda/%s/LICENSE.txt" % ANACONDA_VERSION
        self.assertTrue(os.path.isfile(anaconda_license))
