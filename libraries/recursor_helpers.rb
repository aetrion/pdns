#
# Cookbook Name:: pdns
# Libraries:: recursor_helpers
#
# Copyright 2014-2017 Aetrion LLC. dba DNSimple
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
def default_recursor_config_directory
  case node['platform_family']
  when 'debian'
    '/etc/powerdns'
  when 'rhel'
    '/etc/pdns-recursor'
  end
end

def default_recursor_run_user
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

def recursor_instance_service_name(name = nil)
  %W[pdns_recursor #{name}].join('-')
end
