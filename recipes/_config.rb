#
# Cookbook Name:: pdns
# Recipe:: _config
#
# Copyright 2014, Aetrion, LLC.
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

flavor = node['pdns']['flavor']

# Set the bind config if we're launching with that
if node['pdns']['authoritative']['config']['launch'] == 'bind'
  node.default['pdns']['authoritative']['config']['bind_config'] = "#{node['pdns'][flavor]['config']['config_dir']}/bind-backend.conf"
end

# This attribute is only required in authoritative package installs
if node['pdns']['build_method'] == 'package'
  node.default['pdns']['authoritative']['config']['include-dir']="#{node['pdns'][flavor]['config']['config_dir']}/pdns.d"
end

config_file_path = "#{node['pdns'][flavor]['config']['config_dir']}/pdns.conf"
service_name = 'pdns'

if flavor == 'recursor'
  config_file_path = "#{node['pdns'][flavor]['config']['config_dir']}/recursor.conf"
  service_name = 'pdns-recursor'
end

directory "#{node['pdns'][flavor]['config']['config_dir']}/pdns.d" do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

file "#{node['pdns'][flavor]['config']['config_dir']}/pdns.d/pdns.simplebind.conf" do
  action :delete
  only_if { node['pdns']['build_method'] == 'package' }
end

template config_file_path do
  source 'pdns.conf.erb'
  owner node['pdns']['user']
  group node['pdns']['group']
  mode 0640
  notifies :restart, "service[#{service_name}]"
  variables( flavor: flavor )
end

