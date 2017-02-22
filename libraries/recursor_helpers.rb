#
# Cookbook Name:: pdns
# Libraries:: helpers
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
def default_config_directory
  case node['platform_family']
  when 'debian'
    '/etc/powerdns'
  when 'rhel'
    '/etc/powerdns-recursor'
  end
end

def default_tunables_directory
  case node['platform_family']
  when 'debian'
    "#{default_config_directory}/recursor-tunables"
  when 'rhel'
    "#{default_config_directory}/tunables"
  end
end

def default_run_user
  case node['platform_family']
  when 'debian'
    'pdns'
  when 'rhel'
    'pdns-recursor'
  end
end

def default_user_attributes
  case node['platform_family']
  when 'debian'
    { home: '/var/spool/powerdns', shell: '/bin/false' }
  when 'rhel'
    { home: '/', shell: '/sbin/nologin' }
  end
end