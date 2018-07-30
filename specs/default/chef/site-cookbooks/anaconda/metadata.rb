name             'anaconda'
description      'Installs/Configures Anaconda or Miniconda on a CycleCloud Node'
version          '1.0.0'


chef_version '>= 11' if respond_to?(:chef_version)
