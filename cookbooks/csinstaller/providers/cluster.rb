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

 # if new_resource.hypervisor == "VMWare"
    response = send_request(
    {
    "zoneid" => new_resource.zone_id,
    "command" => "addCluster",
    "clustertype" => "ExternalManaged",
    "podId" => new_resource.pod_id,
    "username" => new_resource.username,
    "password" => new_resource.password,
    "url" => "http://#{new_resource.vcenter_host}/#{new_resource.vcenter_datacenter}/#{new_resource.vcenter_cluster}",
    "clustername" => "http://#{new_resource.vcenter_host}/#{new_resource.vcenter_datacenter}/#{new_resource.vcenter_cluster}",
    "hypervisor" => new_resource.hypervisor
    })

end
