default['apt']['unattended_upgrades']['enable'] = true
default['apt']['unattended_upgrades']['auto_fix_interrupted_dpkg'] = true
default['apt']['unattended_upgrades']['allowed_origins'] = [
  "#{node['platform'].capitalize} stable"
]

default['bitcoin']['source']['version'] = '0.11.2'
default['bitcoin']['source']['checksum'] = '2d9c66d31b24720c5e5317dd16d8fd9f4123c95c6d4aa4cec8f5c325afb94b08'

# default['tz'] = 'EDT'
