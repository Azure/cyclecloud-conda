default['anaconda']['install_type'] = 'anaconda'
default['anaconda']['version'] = (node['anaconda']['install_type'] == "miniconda") ? 'latest' : '2019.03'
default['anaconda']['home'] = "/opt/#{node['anaconda']['install_type']}/#{node['anaconda']['version']}"
default['anaconda']['python'] = 'python2'  # Allowed: ['2', 'python2', '3', 'python3']


# For latest URLs See:
#          https://www.anaconda.com/download/#linux
#          https://conda.io/miniconda.html
#
# The current project defaults to these urls:
#          https://repo.anaconda.com/archive/Anaconda3-2019.03-Linux-x86_64.sh
#          https://repo.anaconda.com/archive/Anaconda2-2019.03-Linux-x86_64.sh
#          https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.shh
#          https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh
#
# Previous project version used Anaconda 5.2.0
default['anaconda']['platform'] = 'Linux-x86_64'
default['anaconda']['base_url'] = (node['anaconda']['install_type'] == "miniconda") ? 'https://repo.continuum.io/miniconda' : 'https://repo.anaconda.com/archive'

