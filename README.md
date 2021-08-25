# hana-studio Cookbook

[![REUSE status](https://api.reuse.software/badge/github.com/SAP/hana-studio-chef-cookbook)](https://api.reuse.software/info/github.com/SAP/hana-studio-chef-cookbook)

This cookbook installs SAP HANA Studio onto a Windows instance.  This is a BYOP
cookbook (**B**ring **Y**our **O**wn **P**ackage).  You need to provide the
download location for SAPCAR to extract your SAR package.  You can also use a
zip file, so long as it conforms to the *standard* layout:
`installer.zip\SAP_HANA_STUDIO\hdbinst.exe`.   

## Supports

This cookbooks supports the following windows versions, having been tested on
the following GCP Public Images.

 * Windows Server 2012 R2
 * Windows Server 2012 R2 Core
 * Windows Server 2016
 * Windows Server 2016 Core
 * Windows Server 2019
 * Windows Server 2019 Core
 * Windows Server 2019 for Containers
 * Windows Server 2019 Core for Containers


## Attributes
### Basic and Required
When using the default recipe, you **must** provide these values to install
hana studio on your system.

|           Key           |  Type  |                               Description                               | Default |
| ----------------------- | ------ | ----------------------------------------------------------------------- | ------- |
| `['sap']['hanastudio']` | String | Where can I find the package file containing the HANA Studio installer. |   nil   |

### Advanced and Optional
These attributes are used to fine tune the installation.

|                Key               |  Type  |                          Description                         | Default |
| -------------------------------- | ------ | ------------------------------------------------------------ | ------- |
| `['sap']['sapcar']`              | String | Where can I find the SAPCAR executable to extract sar files. (Required if using a SAR package) | nil |
| `['hana-studio']['install_dir']` | String | Where do you want the Studio to be installed?                                                  | 'C:\Program Files\SAP\Hdbstudio' |
| `['hana-studio']['features']`    | String | Which features¹ do you want to include? (comma separated list)                                 | 'all' |

¹*__NOTE:__* The available features may differ from one version to another.  Some
common features include:
- admin
- appdev
- dbdev
- answers
- importmetadata

Please consult your package documentation for an accurate list of your package's
features, and their descriptions.

## Custom Resources
If you would like greater control over the installation, you can use the following custom
resources in your cookbooks directly
### hana_studio
#### Actions
 - `:install`
 - `:uninstall`

Use the actions to manage the presence of HANA Studio at
the specified location.  `uninstall` removes the HANA studio exactly in the
path you specify.

#### Example
```ruby
hana_studio "C:\\Root\\Path\\To\\Install\\hana-studio\\" do
  source    "" # location from which the package can be downloaded
  extractor "" # URL to download SAPCAR or nil if source is a zipfile
  features  "comma,seperated,list,of,features"
  action :install
end
```
```ruby
hana_studio "C:\\Root\\Path\\To\\Uninstall\\hana-studio\\" do
  action :uninstall
end
```

### hana_studio_remote_package
#### Actions
 - `:extract`

Use the actions to extract a remote package.

#### Example
```ruby
hana_studio_remote_package 'c:\Path\to\extract\the\package' do
  source 'http://compressed.file/location.ext'
  creates 'file.name.created'
  extractor "" # URL to download SAPCAR or nil if source is a zipfile
  action :extract
end
```

## License and Authors
### Authors
- Dan-Joe Lopez (Dan-Joe.Lopez@sap.com)

### License

Copyright 2020, SAP

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Detailed information including third-party components and their
licensing/copyright information is available
[via the REUSE tool](https://api.reuse.software/info/github.com/SAP/hana-studio-chef-cookbook).
