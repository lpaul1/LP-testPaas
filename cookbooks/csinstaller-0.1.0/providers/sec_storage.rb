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
  zone_id = get_zone_id(new_resource.zone_name)
  response = send_request({
  "command" => "addSecondaryStorage",
  "zoneid" => zone_id,
  "url" => "nfs://#{new_resource.nfs_server}/#{new_resource.path}"
  })

end

