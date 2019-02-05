# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.
import subprocess
import unittest

import jetpack.config

ANACONDA_VERSION = jetpack.config.get("anaconda.version").strip()

class TestAnaconda(unittest.TestCase):
    def test_install(self):
        """ Verifies conda was installed """
        self.assertEquals("/opt/anaconda/%s/bin/conda" % ANACONDA_VERSION, subprocess.check_output("which conda", shell=True).strip())

    def test_basic(self):
        """ Create a test-env with numpy installed and verify functionality """
        script = """
#!/bin/bash
conda create -c conda-forge -n test-env python=2.7 numpy --yes
source activate test-env
python -c "import numpy; assert(sum(numpy.array([1,2,3,4]) + 1) == 14)"
source deactivate
conda remove --name myenv --all
        """
        with open("/tmp/test.sh", 'w') as f:
            f.write(script)
        subprocess.check_call(["sh /tmp/test.sh"], shell=True)
