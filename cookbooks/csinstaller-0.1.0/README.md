Description
===========

Installs and configures Citrix CloudPlatform/CloudStack 3.0.x.

Requirements
============

Chef 0.10.10+.

Platform
--------

* CentOS, Red Hat (>=6.2)

Tested on:

* CentOS 6.3


Attributes
==========

See the `attributes/server.rb` for the additional information.

Zones

* `node['cloudstack_version']` - CloudPlatform/CloudStack version to be installed
* `node['download_url']` - Locally accessible HTTP URL
* `node['zone']` - Information about the Cloudstack Zone to be setup

Attributes include:

  * `name`
  * `network_type`
  * `local_storage_enabled`
  * `dns1`
  * `dns2`
  * `internal_dns`
  * `security_group_enabled`
  * `guest_cidr_address`

* `node['zone']['network]` - Associated Network

Attributes include:

* `name`

Pods

* `node['zone']['pods']` - Each Zone contains several Pods - usually a rack of hardware

Attributes include:

  * `name`
  * `gateway`
  * `netmask`
  * `start_ip`
  * `end_ip`
  * `clusters`

Clusters

* `node['zone']['pods']['clusters]` - A Pod can contain several Clusters. A cluster consists of one or more hypervisor hosts and primary storage

Attributes include (Current support restricted to VMWare):

  * `hypervisor`
  * `username`
  * `password`
  * `vcenter_host`
  * `vcenter_datacenter`
  * `vcenter_cluster`
  * `primary_storages`

Primarty Storage

* `node['zone']['pods']['clusters']['primary_storages']` - Associated with a cluster, stores disk volumes of all VMs

Attributes include:

  * `name`
  * `nfs_server`
  * `path`

Public IP Range

* `node['zone']['public_ip_range']` - Public IP Range so that the VMs are accessible in the client's network over NAT/Firewall

Attrbutes include:

  * `vlan`
  * `start_ip`
  * `end_ip`
  * `gateway`
  * `netmask`

Secondary Storage

* `node['zone']['sec_storages']` - Associated with a zone,stores Templates, ISOs and Volume snapshots

Attributes include:

  * `nfs_server`
  * `path`

Usage
=====
The cookbook sets up the CloudPlatform management server and can setup a Adv. networking VMware-based Zone.
The steps are:

* Host the CloudPlatform Installer from a HTTP server

Host the Installer tarball so that it is accessible over HTTP. Set the following attribute accordingly:
    default['download_url'] = "http://localhost"

* Setup SELinux to be permissive
* Setup ntp with valid NTP servers
* Setup MySQL server with valid attributes/configurations
* Setup the CloudPlatform Management server
* Setup the Adv. Zone

The following role definition sets attributes and the run-list

    {
      "run_list": [
        "recipe[selinux::permissive]",
        "recipe[ntp]",
        "recipe[mysql::server]",
        "recipe[csinstaller::mgmt_server]",
        "recipe[csinstaller::setup_zone]"
      ],

      ...

      "override_attributes": {

        #MySQL Parameters

        "mysql": {
          "server_root_password": "fr3sca",
          "tunable": {
            "innodb_lock_wait_timeout": "600",
            "binlog_format": "ROW",
            "innodb_rollback_on_timeout": "1",
            "log_bin": "mysql-bin"
          },
          "server_debian_password": "fr3sca",
          "bind_address": "localhost",
          "server_repl_password": "fr3sca"
        },
        "ntp": {
          "packages": [
            "ntp"
          ],
          "service": "ntpd",
          "servers": [
            "0.xenserver.pool.ntp.org",
            "1.xenserver.pool.ntp.org",
            "2.xenserver.pool.ntp.org"
          ]
        }
      }
    }

License and Author
==================

- Author:: Chirag Jog (<chirag@clogeny.com>)

Copyright:: 2013 Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
