#
# Cookbook Name:: pdns
# Recipe:: authoritative_package
#
# Copyright 2010, Chef Software, Inc.
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

package 'pdns-server'

pdns_package_module_requirements.each do |pkg|
  package pkg
end

template "#{node['pdns']['authoritative']['config_dir']}/pdns.conf" do
  source 'authoritative.conf.erb'
  owner node['pdns']['user']
  group node['pdns']['group']
  mode 0644
  notifies :restart, 'service[pdns]'
end

service 'pdns' do
  provider Chef::Provider::Service::Init::Debian
  supports status: true, restart: true, reload: true
  action [:enable, :start]
end
