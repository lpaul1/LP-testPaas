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

  response = send_request(
    {
        "command" => "createPod",
        "zoneid" => zone_id,
        "name" => new_resource.name,
        "gateway" => new_resource.gateway,
        "netmask" => new_resource.netmask,
        "startIp" => new_resource.start_ip,
        "endIp" => new_resource.end_ip
    })

  new_resource.clusters.each do |cluster|
    podid = response["pod"]["id"]
    response = send_request(
      {
        "zoneid" => zone_id,
        "command" => "addCluster",
        "clustertype" => "ExternalManaged",
        "podId" => podid,
        "username" => cluster['username'],
        "password" => cluster['password'],
        "url" => "http://#{cluster['vcenter_host']}/#{cluster['vcenter_datacenter']}/#{cluster['vcenter_cluster']}",
        "clustername" => "http://#{cluster['vcenter_host']}/#{cluster['vcenter_datacenter']}/#{cluster['vcenter_cluster']}",
        "hypervisor" => cluster['hypervisor']
      })

    Chef::Log.info("Primary storage: #{cluster}")
    if cluster['primary_storages']
      cluster['primary_storages'].each do |pri_storage|
        clusterid = response['cluster'].first["id"]
        csinstaller_admin_api "Add Primary Storage" do
          command "createStoragePool"
          params "name" => pri_storage['name'], "zoneid" => zone_id, "podid" => podid, "clusterid" => clusterid,
                  "url" => "nfs://#{pri_storage["nfs_server"]}/#{pri_storage["path"]}"
        end
      end
    end
  end
end
