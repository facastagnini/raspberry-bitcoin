default['apt']['unattended_upgrades']['enable'] = true
default['apt']['unattended_upgrades']['auto_fix_interrupted_dpkg'] = true
default['apt']['unattended_upgrades']['allowed_origins'] = [
  "#{node['platform'].capitalize} stable"
]

default['bitcoin']['source']['url'] = 'https://github.com/bitcoinxt/bitcoinxt'
default['bitcoin']['source']['version'] = '0.11A'
default['bitcoin']['source']['checksum'] = 'bd7a9226a14e74aab5ae684e7fa90d7815a2335c'

# default['tz'] = 'EDT'
