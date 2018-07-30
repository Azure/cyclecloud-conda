# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.
import unittest
import os
import jetpack.util

class TestMaster(unittest.TestCase):
    def test_basic(self):
        anaconda_license = "/opt/anaconda/4.3.0/LICENSE.txt"
        self.assertTrue(os.path.isfile(anaconda_license))
