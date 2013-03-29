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

include Opscode::Cloudstack::Admin

action :setup do

  zone_id = get_zone_id(node["zone"]["name"])
  response = send_async_request(
  {
    "command" => "createPhysicalNetwork",
    "zoneid" => zone_id,
    "name" => new_resource.name
    })

  phy_network = response['physicalnetwork']
  new_resource.traffic_type.each do |traffic_type|
    csinstaller_admin_api "add traffic type" do
      command "addTrafficType"
      async true
      params "trafficType" => traffic_type, "physicalnetworkid" => phy_network['id']
    end
  end

  csinstaller_admin_api "Enable physical network" do
    command "updatePhysicalNetwork"
    async true
    params "state" => "Enabled", "id" => phy_network['id']
  end

  ["VirtualRouter", "VpcVirtualRouter" ].each do |nsp_type|
    response = send_request(
      {
        "command" => "listNetworkServiceProviders",
        "name" => nsp_type,
        "physicalNetworkId" => phy_network['id']
    })

    nsp = response['networkserviceprovider'][0]
    response = send_request(
    {
      "command" => "listVirtualRouterElements",
      "nspid" => nsp['id']
      })

    vre = response['virtualrouterelement'][0]

    csinstaller_admin_api "configure virtual router element" do
      command "configureVirtualRouterElement"
      params "enabled" => true, "id" => vre['id']
      async true
    end

    csinstaller_admin_api "update network service provider" do
      command "updateNetworkServiceProvider"
      params "state" => "Enabled", "id" => nsp['id']
      async true
    end

  end

  csinstaller_admin_api "update network with VLAN range" do
    command "updatePhysicalNetwork"
    params "vlan" => "699-999", "id" => phy_network['id']
  end
end


