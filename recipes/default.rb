#
# Cookbook Name:: hana-studio
# Recipe:: default
#
# Copyright 2016, SAP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

###########
# Prepare #
###########

# Setup vars for readability
extract_to_dir = "#{Chef::Config[:file_cache_path]}//sap_temp"
installer_file = extract_to_dir + '/SAP_HANA_STUDIO/hdbinst.exe'
studio = node['hana-studio']['install_dir'] + '/install/hdbuninst.exe'

# Get current state
studio_installed = ::File.exist?(studio)

# Extract the remote installer
hana_studio_remote_package extract_to_dir do
  source node['sap']['hanastudio']
  creates installer_file
  extractor node['sap']['sapcar'] if node['sap']['sapcar']
  action :extract
  not_if { studio_installed || ::File.exist?(installer_file) }
end

###########
# Install #
###########

hana_studio node['hana-studio']['install_dir'] do
  installer installer_file
  features node['hana-studio']['features']
  action :install
  not_if { studio_installed }
end

###########
# Cleanup #
###########

hana_studio_remote_package extract_to_dir do
  action :cleanup
  only_if { ::Dir.exist?(extract_to_dir) }
end
