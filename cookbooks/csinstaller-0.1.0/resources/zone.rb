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

actions :setup, :enable
attribute :name
attribute :id
attribute :network_type
attribute :local_storage_enabled
attribute :dns1
attribute :dns2
attribute :internal_dns
attribute :security_group_enabled
attribute :guest_cidr_address

def initialize(*args)
  super
  @action = :setup
end
