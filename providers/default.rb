#
# Cookbook Name:: hana-studio
# provider:: default
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

use_inline_resources

action :install do
  # Setup install options
  studio = ::File.exist?("#{new_resource.destination}/install/hdbuninst.exe")
  installer = new_resource.installer
  install_dir = ::File.dirname(installer)
  options = ' --batch '
  options += "--features=#{new_resource.features} " if new_resource.features
  options += "-p=\"#{new_resource.destination}\""

  # Execute installation with options
  execute "Installing Hana Studio to: {#{new_resource.destination}}" do
    cwd install_dir
    command installer + options
    action :run
    not_if { studio }
  end
end

action :uninstall do
  # Setup removal options
  uninstaller = "#{new_resource.destination}/install/hdbuninst.exe"
  options = " --batch --path=\"#{new_resource.destination}\""

  # Execute uninstallation
  execute "Uninstalling Hana Studio from: {#{new_resource.destination}}" do
    command '"' + uninstaller + '"' + options
    action :run
    only_if { ::File.exist?(uninstaller) }
  end
end
