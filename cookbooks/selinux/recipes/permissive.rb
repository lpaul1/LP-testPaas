#
# Author:: Sean OMeara (<someara@opscode.com>)
# Cookbook Name:: selinux
# Recipe:: permissive
#
# Copyright 2011, Opscode, Inc.
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

# install libselinux-utils which provides getenforce tool (used below)
include_recipe 'selinux::default'

execute "enable selinux as permissive" do
  not_if "getenforce | egrep -qx 'Permissive|Disabled'"
  command "setenforce 0"
  ignore_failure true
  action :run
end

template "/etc/selinux/config" do
  source "sysconfig/selinux.erb"
  not_if "getenforce | grep -qx 'Disabled'"
  variables(
    :selinux => "permissive",
    :selinuxtype => "targeted"
  )
end