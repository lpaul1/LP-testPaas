#
# Author:: Chirag Jog <chirag@clogeny.com>
# Copyright:: Copyright (c) 2013, Opscode, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

default['cloudstack_trial'] = "3.0.6.1-trial-rhel6.2"
default['cloudstack_version'] = "3.0.6-1-rhel6.2"
default['cloudstack_installer'] = "/home/lp03306/CloudStack-#{default['cloudstack_trial']}.tar.gz"
default['cloudstack_tempdir'] = "/tmp"
default['download_url'] = "http://localhost"
default['zone']['name'] = "Opscode-Zone-001"
default['zone']['network_type'] = 'Advanced'
default['zone']['local_storage_enabled'] = "true"
default['zone']['dns1'] = '8.8.8.8'
default['zone']['dns2'] = '4.4.4.4'
default['zone']['internal_dns'] = '192.168.100.1'
default['zone']['security_group_enabled'] = false
default['zone']['guest_cidr_address'] = "10.1.1.0/16"

default['zone']['network']['name'] = "PhysicalNetwork1"

default['zone']['pods'] = [
  {
    "name" => "Pod_001",
    "gateway" => "192.168.100.1",
    "netmask" => "255.255.255.0",
    "start_ip" => "192.168.100.70",
    "end_ip" => "192.168.100.90",
    "clusters" => [{
       "primary_storages" => [{
              "name" => "nfs-4",
              "nfs_server" => "192.168.100.229",
              "path" => "/media/usbdrive/nfs4"

      }],
      "hypervisor" => "VMware",
      "username" => "Administrator",
      "password" => "fr3sca",
      "vcenter_host" => "192.168.100.174",
      "vcenter_datacenter" => "Pune-Opscode-001",
      "vcenter_cluster" => "Cluster-001",

    }]
}
]

default['zone']['public_ip_ranges'] = [{
  "vlan" => "untagged",
  "start_ip" => "192.168.100.91",
  "end_ip" => "192.168.100.111",
  "gateway" => "192.168.100.1",
  "netmask" => "255.255.255.0"
}]

#default['zone']['primary_storages'] = [{
#  "name" => "nfs-4",
#  "nfs_server" => "192.168.100.229",
#  "path" => "/media/usbdrive/nfs4"
#
#}]

default['zone']['sec_storages'] = [
  {
    "nfs_server" => "10.40.97.79",
    "path" => "/export"
  }

]
