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
    response = send_request(
    {
        "command" => "createZone",
        "name" => new_resource.name,
        "networktype" => new_resource.network_type,
        "localstorageenabled" => new_resource.local_storage_enabled,
        "dns1" => new_resource.dns1,
        "dns2" => new_resource.dns2,
        "internaldns1" => new_resource.internal_dns,
        "securitygroupenabled" => new_resource.security_group_enabled,
        "guestcidraddress" => new_resource.guest_cidr_address
    })
end

action :enable do
  zone_id = get_zone_id(new_resource.name)
  send_request({"command" =>"updateZone", "id" => zone_id, "allocationstate" => "Enabled" })
end
