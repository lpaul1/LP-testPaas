#
# Cookbook Name:: cs_installer
# Recipe:: setup_zone
#
# Copyright 2013, Opscode, Inc.
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

csinstaller_zone node['zone']['name'] do
  network_type node['zone']['network_type']
  local_storage_enabled node['zone']['local_storage_enabled']
  dns1 node['zone']['dns1']
  dns2 node['zone']['dns2']
  internal_dns node['zone']['internal_dns']
  security_group_enabled node['zone']['security_group_enabled']
  guest_cidr_address node['zone']['guest_cidr_address']
end


csinstaller_network node['zone']['network']['name'] do
  zone_name node['zone']['name']
  type node['zone']['network_type']
  traffic_type ["Guest", "Management", "Public"]
end

 node['zone']['pods'].each do |pod|
     csinstaller_pod pod['name'] do
         zone_name node['zone']['name']
         gateway pod['gateway']
         netmask pod['netmask']
         start_ip pod['start_ip']
         end_ip pod['end_ip']
         clusters pod['clusters']
     end
end

node["zone"]["public_ip_ranges"].each do |public_ip_range|
  csinstaller_public_ip_range "Public IP Range" do
    zone_name node["zone"]["name"]
    vlan public_ip_range["vlan"]
    gateway public_ip_range["gateway"]
    netmask public_ip_range["netmask"]
    start_ip public_ip_range["start_ip"]
    end_ip public_ip_range["end_ip"]
  end
end


node["zone"]["sec_storages"].each do |ss|
  csinstaller_sec_storage "add secondary storage" do
    zone_name node["zone"]["name"]
    nfs_server ss["nfs_server"]
    path ss["path"]
  end
end


csinstaller_zone node['zone']['name'] do
  action :enable
end
