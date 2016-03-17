# hana-studio Cookbook

This cookbook installs SAP HANA Studio onto a Windows instance.  This is a BYOP
cookbook (**B**ring **Y**our **O**wn **P**ackage).  You need to provide the
installer in a zipped package or provide a download location for SAPCAR if using
a SAR package.  If zipped, that package should be of a *standard* layout:
`installer.zip\SAP_HANA_STUDIO\hdbinst.exe`.   

## Supports

This cookbooks supports the following windows versions, and has been tested on
SAP's internal cloud and AWS as noted below.

|            OS          | Internally Tested | AWS EC2 Tested |
| ---------------------- | ----------------- | -------------- |
| Windows Server 2008    |         ⃠        |        ✓       |
| Windows Server 2008 R2 |         ✓        |        ✓       |
| Windows Server 2012    |         ⃠        |        ✓       |
| Windows Server 2012 R2 |         ✓        |        ✓       |
| Windows Server 2016 TP |         ✓        |        ⃠       |
| Windows 10             |         ✓        |        ⃠       |


## Attributes
### Basic and Required
You **must** provide these values to the cookbook so that it can install the
client on your system.  You may have specified these values as a part of
another cookbook.

|           Key           |  Type  |                               Description                               | Default |
| ----------------------- | ------ | ----------------------------------------------------------------------- | ------- |
| `['sap']['hanastudio']` | String | Where can I find the package file containing the HANA Studio installer. | nil |

### Advanced and Optional
These attributes are used to fine tune the installation.

|                Key               |  Type  |                          Description                         | Default |
| -------------------------------- | ------ | ------------------------------------------------------------ | ------- |
| `['sap']['sapcar']`              | String | Where can I find the SAPCAR executable to extract sar files. (Required if using a SAR package) | nil |
| `['hana-studio']['install_dir']` | String | Where do you want the Studio to be installed?                | 'C:\Program Files\SAP\Hdbstudio' |
| `['hana-studio']['features']`    | String | Which features¹ do you want to include? (comma separated list)                     | 'all' |

¹*__NOTE:__* The available features may differ from one version to another.  Some
common features include:
- admin
- appdev
- dbdev
- answers
- importmetadata

Please consult your package documentation for an accurate list of your package's
features, and their descriptions.

## Resource/Provider
### hana_studio
#### Actions
 - `:install`
 - `:uninstall`

Use the actions to install or remove an installation of the studio to or from
the specified location.  `uninstall` removes the HANA studio exactly in the
path you specify.

##### Example
```ruby
hana_studio "C:\\Root\\Path\\To\\Install\\hana-studio\\" do
	installer "C:\\Path\\To\\Extracted\\Installer\\hdbinst.exe"
  features "comma,seperate,list,of,features"
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
 - `:cleanup`

Use the actions to extract and then cleanup a remote zip package.  This makes
use of the remote_file resource for the download.

##### Example
```ruby
hana_studio_remote_package 'c:\Path\to\extract\the\zip' do
	source 'http://zip,file/location.zip'
	creates 'file.name.created'
	action :extract
end
```
## Usage
### hana-studio::default
So you want to install the SAP HANA studio?  In addition to the resources
provided above, you can use this cookbook's default recipe to install the SAP
HANA Studio.  Here's how:
1. Depend on me (in your `metadata.rb`).
```ruby
depends 'hana-studio'
```

- Setup your installation (using attributes).
 - [REQUIRED]: You **must** provide the location of the packaged installer using
 the `['sap']['hanastudio']` attribute.
 - [OPTIONAL]: The location to download SAPCAR if using a `sar` package.
 - [OPTIONAL]: Change the default installation directory.
 - [OPTIONAL]: Use a custom list of comma separated features.

- Include `hana-studio` in your node's `run_list`:
```json
{
  "name":"my_node",
  "run_list": [
    "recipe[hana-studio]"
  ]
}
```
- Enjoy SAP HANA Studio!

## Contributing
Contributions are welcomed!

1. Fork the repo
2. Create a feature branch (like `add_component_x`)
3. Write your change
4. Test your change
5. Submit a Pull Request using Github

## License and Authors
### Authors
- Alon Antoshvinski (alon.antoshvinski@sap.com )
- Dan-Joe Lopez (Dan-Joe.Lopez@sap.com)

### License

Copyright 2016, SAP

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
