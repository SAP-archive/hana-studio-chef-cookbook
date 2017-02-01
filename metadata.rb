name             'hana-studio'
maintainer       'SAP'
maintainer_email 'Dan-Joe.Lopez@sap.com'
license          'Apache 2.0'
description      'Installs/Configures SAP HANA Studio'
source_url       'https://github.com/sap/hana-studio-chef-cookbook' if respond_to?(:source_url)
issues_url       'https://github.com/sap/hana-studio-chef-cookbook/issues' if respond_to?(:issues_url)
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.1'

depends 'windows', '~>1.0'

supports 'windows'
