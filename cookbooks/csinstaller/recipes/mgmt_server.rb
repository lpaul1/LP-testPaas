#
# Cookbook Name:: cs_installer
# Recipe:: mgmt_server
#
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


#
# Extract trial installer and execute install.sh
#
script "install_mgmt_server" do
  interpreter "bash"
  user "root"
  cwd node['cloudstack_tempdir']
  code <<-EOH
  tar -zxf #{node["cloudstack_installer"]}
  cd CloudStack-#{node["cloudstack_version"]}
  ./install.sh -m
  EOH
end

#
# Install packages rpcbind, nfs-utils, nfs-utils-lib
#
%w{rpcbind nfs-utils nfs-utils-lib
  }.each do |package_name|
    yum_package package_name do
    end
  end

#
# Enable and start rpcbind and nfs services (if required).
#
[
  "rpcbind", "nfs"
].each do |service_name|
  service service_name do
    action [:start, :enable]
  end
end

#
# cloud-setup-databases script will login to mysql instance and create required tables.
# Note: at this point Chef has already deployed/configured mysql (using mysql cookbook as a dependency).
#
execute "cloud-setup-databases" do
  command "cloud-setup-databases cloud:#{node['mysql']['server_root_password']}@localhost --deploy-as=root:#{node['mysql']['server_root_password']}"
end

#
# This script will setup iptables, sudoers, and the management server.
#
execute 'cloud-setup-management' do
  command "cloud-setup-management"
end

#
# Prepare secondary NFS storage.  Assumes NFS is already configured per the CloudStack lab installer guide.
#
directory '/mnt/secondary' do
  owner "root"
  group "root"
  not_if do FileTest.directory? "/mnt/secondary" end
end

#
# Mount secondary storage - NFS should be preconfigured.
#
#mount '/mnt/secondary' do
#  fstype 'nfs'
#  device "#{node['zone']['sec_storages'].first['nfs_server']}:#{node['zone']['sec_storages'].first['path']}"
#  action :mount
#end

#
# Download and install system VM.
#
script "install system VM template" do
  interpreter "bash"
  user "root"
  code "<<-EOH
      /usr/lib64/cloud/agent/scripts/storage/secondary/cloud-install-sys-tmplt -m\
      /mnt/secondary -u http://download.cloud.com/templates/acton/acton-systemvm-02062012.ova\
      -h vmware
  EOH"
end

ruby_block "sleep" do
  block do
    sleep 120
  end
end
#sleep, enable port 8096
service 'cloud-management' do
  action [:stop]
end

script "enable_mgmt_port" do
  interpreter "bash"
  user "root"
  cwd "/tmp"
  code <<-EOH
  mysql -ucloud -pfr3sca -Dcloud  -e "update configuration set value=8096 where name='integration.api.port'"
  EOH
end

  script "allow system vms to use local storage" do
    interpreter "bash"
    user "root"
    cwd "/tmp"
    code <<-EOH
    mysql -ucloud -pfr3sca -Dcloud  -e "update configuration set value='true' where name='system.vm.use.local.storage'"
    EOH
  end

#mount '/mnt/secondary' do
#  fstype 'nfs'
#  device "#{node['zone']['sec_storages'].first['nfs_server']}:#{node['zone']['sec_storages'].first['path']}"
#  action :umount
#end

service 'cloud-management' do
  action [:start]
end

ruby_block "sleep" do
  block do
    sleep 120
  end
end
