name             'cloudstack-installer'
maintainer       'Opscode'
maintainer_email 'chirag@clogeny.com'
license          'All rights reserved'
description      'Installs/Configures Citrix CloudPlatform 3.0.6'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.2'
recipe            'cs_installer:mgmt_server', "Setup the Management Server correctly"
recipe            'cs_installer:setup_zone', "Setup the CloudPlatform Environment(Zone)"

supports          'centos', '>= 6.2'
supports          'rhel', '>= 6.2'

depends           'selinux'
depends           'ntp'
depends           'mysql'
