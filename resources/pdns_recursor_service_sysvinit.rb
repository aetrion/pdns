#
# Cookbook Name:: pdns
# Resources:: pdns_recursor_service
#
# Copyright 2017, Aetrion, LLC DBA DNSimple
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

resource_name :pdns_recursor_service_sysvinit

provides :pdns_recursor_service, platform: 'ubuntu' do |node| #~FC005
  node['platform_version'].to_f >= 14.04
end

provides :pdns_recursor_service, platform: 'debian' do |node| #~FC005
  node['platform_version'].to_i >= 8
end

provides :pdns_recursor_service, platform: 'centos' do |node| #~FC005
  node['platform_version'].to_i >= 6
end

property :instance_name, String, name_property: true
property :cookbook, [String,nil], default: 'pdns'
property :config_dir, String, default: lazy { default_recursor_config_directory }
property :source, [String,nil], default: lazy { "recursor.init.#{node['platform_family']}.erb" }
property :socket_dir, String, default: lazy { |resource| "/var/run/#{resource.instance_name}" }

action :enable do
  service_name = recursor_instance_service_name(new_resource.instance_name)

  template "/etc/init.d/#{service_name}" do
    source new_resource.source
    owner 'root'
    group 'root'
    mode '0755'
    variables(
      pdns_virtual_instance: new_resource.instance_name,
      service_name: service_name,
      config_dir: new_resource.config_dir,
      socket_dir: new_resource.socket_dir,
      )
    cookbook new_resource.cookbook
    action :create
  end

  # To make sure the default package doesn't start any "pdns_recursor" daemon
  service 'pdns-recursor' do
    action [:disable, :stop]
    only_if { node['platform_family'] == 'debian' }
  end

  service service_name do
    supports restart: true, status: true
    action :enable
  end

end

action :start do
  service recursor_instance_service_name(new_resource.instance_name) do
    supports restart: true, status: true
    action :start
  end
end

action :stop do
  service recursor_instance_service_name(new_resource.instance_name) do
    supports restart: true, status: true
    action :stop
  end
end

action :restart do
  service recursor_instance_service_name(new_resource.instance_name) do
    supports restart: true, status: true
    action :restart
  end
end
