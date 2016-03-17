#
# Cookbook Name:: hana-studio
# provider:: remote_package
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

action :extract do
  # Get file Type
  file_type = new_resource.source.split('.')[-1].downcase

  # raise error if filetype is not supported
  err_msg = "The file type {#{file_type}} is not supported by this cookbook."
  raise err_msg unless file_type == 'zip' || file_type == 'sar'

  # Vars for readability
  local_pkg = "#{Chef::Config[:file_cache_path]}\\remote_package.#{file_type}"

  case file_type
  when 'sar'
    hana_studio_sap_media new_resource.destination do
      remote_path new_resource.source
      sapcar new_resource.extractor
      action :extract
    end
  when 'zip'
    # Download the source file
    remote_file local_pkg do
      source new_resource.source
      action :create
      not_if { ::File.exist?(local_pkg) }
    end

    # Make a home for the source file to be extracted
    directory "Create #{new_resource.destination}" do
      path new_resource.destination
      recursive true
      action :create
      not_if { ::Dir.exist?(new_resource.destination) }
    end

    # Extract the source file
    windows_zipfile "Unzipping #{local_pkg} to #{new_resource.destination}" do
      path new_resource.destination
      source local_pkg
      action :unzip
      not_if { ::File.exist?(new_resource.creates) }
    end

    # Delete the source file
    file "Removing #{local_pkg}" do
      path local_pkg
      action :delete
      only_if { ::File.exist?(new_resource.creates) }
    end
  end
  # err_msg = 'An unknown error has occured.  The expected file {' + new_resource.creates + '} was not created.'
  # raise err_msg unless ::File.exist?(new_resource.creates)
end

action :cleanup do
  # delete the extracted package from the temp folder
  directory "Removing #{new_resource.destination}" do
    recursive true
    action :delete
    only_if { ::Dir.exist?(new_resource.destination) }
  end
end
