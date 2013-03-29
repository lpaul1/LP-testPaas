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

actions :setup
attribute :zone_id, :kind_of => String
attribute :hypervisor, :kind_of => String
attribute :pod_id, :kind_of => String
attribute :vcenter_host, :kind_of => String
attribute :vcenter_datacenter, :kind_of => String
attribute :vcenter_cluster, :kind_of => String
attribute :username, :kind_of => String
attribute :password, :kind_of => String

def initialize(*args)
    super
    @action = :setup
    @vcenter_cluster = @name
end
