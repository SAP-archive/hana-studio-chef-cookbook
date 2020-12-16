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
# provides hana_studio
resource_name :hana_studio

attribute :destination, String, name_property: true
attribute :source,      String
attribute :extractor,   String
attribute :features,    String

load_current_value do |desired|
  # puts ""
  destination '' unless ::Dir.exist?(desired.destination) && ::File.exist?("#{desired.destination}/install/hdbuninst.exe")
end

action :install do
  converge_if_changed :destination do
    temp_extract_dir = "#{Chef::Config[:file_cache_path]}\\sap_temp"
    installer_file = temp_extract_dir + '\SAP_HANA_STUDIO\hdbinst.exe'

    # Extract the remote installer
    hana_studio_remote_package temp_extract_dir do
      source new_resource.source
      creates installer_file
      extractor node['sap']['sapcar'] if node['sap']['sapcar']
      action :extract
    end

    installation_command = "cd #{::File.dirname(installer_file)}"
    installation_command += " && #{::File.basename(installer_file)} --batch "
    installation_command += "--features=#{new_resource.features} " if new_resource.features
    installation_command += "-p=\"#{new_resource.destination}\""

    # puts "::File.exist?(#{installer_file}) = #{::File.exist?(installer_file)}"
    # cmd_result = Mixlib::ShellOut.new(installation_command).run_command # may ghave to do this as a resource
    execute 'Install HANA Studio' do
      command installation_command
      live_stream true
      action :run
    end

    # raise installation_command + "\nSTDOUT: " + cmd_result.stdout + "\nSTDERR: " + cmd_result.stderr unless cmd_result.stderr.empty?

    directory temp_extract_dir do
      recursive true
      action :delete
    end
  end
end

action :uninstall do
  # Setup removal options
  uninstaller = "#{new_resource.destination}/install/hdbuninst.exe"
  return unless ::File.exist?(uninstaller)

  uninstall_command = '"' + uninstaller + '"'
  uninstall_command += " --batch --path=\"#{new_resource.destination}\""

  # Execute uninstallation
  cmd_result = Mixlib::ShellOut.new(uninstall_command).run_command

  raise cmd_result.stderr unless cmd_result.stderr.empty?
end
