require File.expand_path('test/libraries/helpers.rb')

describe package(default_authoritative_package) do
  it { should be_installed }
end

describe package(default_authoritative_postgres_backend_package) do
  it { should be_installed }
end

describe port(53) do
  it { should be_listening }
  its('processes') { should match([/pdns_server/]) }
end

describe user(default_authoritative_run_user) do
  it { should exist }
end

describe group(default_authoritative_run_user) do
  it { should exist }
end

if service('pdns_server').type == 'systemd'
  describe processes('pdns_server') do
    its('users') { should eq ['pdns'] }
  end
else
  describe processes('pdns_server-instance') do
    its('users') { should eq ['pdns'] }
  end
end

describe command('dig chaos txt version.bind @127.0.0.1 +short') do
  its('stdout.chomp') { should match(/"PowerDNS Authoritative Server 4\.\d\.\d/) }
end

describe command('dig @127.0.0.1 smoke.example.org') do
  its('stdout.chomp') { should match(/127.0.0.123/) }
end
