#
# Cookbook Name:: hana-studio
# Resource:: sap_media
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

resource_name :hana_studio_sap_media

attribute :extractDir,  String, name_property: true
attribute :remote_path, String
attribute :sapcar,      String

load_current_value do
  sapcar_path = node['platform_family'] == 'windows' ? ENV['WINDIR'] : '/usr/local/bin' # Where to look for SAPCAR
  sapcar_path += '/SAPCAR'
  sapcar_path += '.exe' if node['platform_family'] == 'windows' # add exe if windows

  puts "\n::File.exist?(#{sapcar_path}) = #{::File.exist?(sapcar_path)}"
  extractDir '' unless ::File.exist?(sapcar_path) # mark the resource as not up-to-date
end

action :extract do
  converge_if_changed :extractDir do
    #######################
    ## Collect Variables ##
    #######################

    sapcar_dir = node['platform_family'] == 'windows' ? ENV['WINDIR'] : '/usr/local/bin/' # Where to put SAPCAR
    sapcar_ex = 'SAPCAR' # The file name of the sapcar binary
    sapcar_ex += '.exe' if node['platform_family'] == 'windows' # add exe if windows

    sar_url = new_resource.remote_path # The full URL to the sar package
    sar_file = sar_url.split('/')[-1] # The file name of the sar package, for friendly logging
    sar_extract_dir = new_resource.extractDir # Where to put the extracted contents
    local_sar = "#{Chef::Config[:file_cache_path]}/#{sar_file}" # The path to the loac copy of the SAR

    ########################
    ##  Download SAPCAR   ##
    ########################

    remote_file "#{sapcar_dir}/#{sapcar_ex}" do
      source new_resource.sapcar
      mode 00755 unless node['platform_family'] == 'windows'
      action :create_if_missing
    end

    ######################
    ## Download the SAR ##
    ######################
    remote_file local_sar do
      source sar_url
      mode 0755 unless node['platform_family'] == 'windows'
      backup false
      action :create_if_missing
    end

    ##########################
    ## Extract the package  ##
    ##########################

   # Creates the destination directory
    directory sar_extract_dir do
      recursive true
      action :create
    end

   # Use SAPCAR to extract the downloaded package to its destination
   # Using execute here instead of shell_out to ensure proper flow order.
    execute "Extract media #{sar_file} to #{sar_extract_dir}" do
      command "#{sapcar_ex} -xf #{local_sar} -R #{sar_extract_dir}"
      notifies :delete, "remote_file[#{local_sar}]", :immediately
    end
  end
end
