#
# Cookbook Name:: anaconda
# Recipe:: default
#
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.


conda_type = (node['anaconda']['install_type'].downcase == "anaconda") ? 'Anaconda' : 'Miniconda'
python_version = (node['anaconda']['python'] == "3" or node['anaconda']['python'] == "python3") ? '3' : '2'

anaconda_installer = "#{conda_type}#{python_version}-#{node['anaconda']['version']}-#{node['anaconda']['platform']}.sh"
anaconda_url = "#{node['anaconda']['base_url']}/#{anaconda_installer}"

log "Fetching conda installer from: #{anaconda_url}" do level :info end
anaconda_installer_path = "#{Chef::Config[:file_cache_path]}/#{anaconda_installer}"

# First check if the installer is in blobs
execute "#{node['cyclecloud']['jetpack']['executable']} download #{anaconda_installer} #{anaconda_installer_path}  --project anaconda" do
  returns [0, 1]
  not_if { ::File.exists?(anaconda_installer_path) }
end

# If not, then download  installer from anaconda
remote_file anaconda_installer_path do
  source anaconda_url
  mode 0755
  not_if { ::File.exists?(anaconda_installer_path) }
  action :create_if_missing
end

directory File.dirname(node['anaconda']['home']) do
  mode 0755
  recursive true
end

# See: https://conda.io/docs/user-guide/install/macos.html#install-macos-silent
execute 'install conda' do
  command "bash -x #{anaconda_installer_path} -b -p #{node['anaconda']['home']} -f"
  not_if { File.directory?(node['anaconda']['home']) }
end


# Add system-wide path to profile.d and configure all users with local environment home
file '/etc/profile.d/anaconda-env.sh' do
  content <<-EOH
  #!/bin/bash

  export ANACONDA_HOME=#{node['anaconda']['home']}
  export PATH=$PATH:#{node['anaconda']['home']}/bin


  if [ ! -f ~/.condarc ]  && [ "$( whoami )" != "root" ]; then
    conda config --add envs_dirs ${HOME}/.conda/envs
  fi

  EOH
  owner 'root'
  group 'root'
  mode '0755'
end

defer_block 'Defer until after all anaconda cookbooks run' do
  bash 'ensure conda binaries are executable' do
    code "chmod a+rx #{node['anaconda']['home']}/bin/* && chmod -R a+rX #{node['anaconda']['home']}"
  end
end

