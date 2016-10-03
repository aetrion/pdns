#
# Cookbook Name:: pdns
# Attributes:: default
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

default['pdns']['build_method'] = 'package'
default['pdns']['flavor'] = 'recursor'
if node['pdns']['flavor'] == 'recursor' && node['platform_family'].include?('rhel')
  default['pdns']['user'] = 'pdns-recursor'
  default['pdns']['group'] = 'pdns-recursor'
else
  default['pdns']['user'] = 'pdns'
  default['pdns']['group'] = 'pdns'
end
