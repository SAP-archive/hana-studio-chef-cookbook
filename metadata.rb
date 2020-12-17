name             'hana-studio'
maintainer       'SAP'
maintainer_email 'Dan-Joe.Lopez@sap.com'
license          'Apache-2.0'
description      'Installs/Configures SAP HANA Studio'
version          '2.0.1'

chef_version     '~> 15.0'
source_url       'https://github.com/sap/hana-studio-chef-cookbook'
issues_url       'https://github.com/sap/hana-studio-chef-cookbook/issues'

depends 'windows'# , '~>1.0'

supports 'windows'
