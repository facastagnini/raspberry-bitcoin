default['apt']['unattended_upgrades']['enable'] = true
default['apt']['unattended_upgrades']['auto_fix_interrupted_dpkg'] = true
default['apt']['unattended_upgrades']['allowed_origins'] = [
  "#{node['platform'].capitalize} stable"
]

default['bitcoin']['source']['url'] = 'https://github.com/bitcoinxt/bitcoinxt'
default['bitcoin']['source']['version'] = '0.11A'
default['bitcoin']['source']['checksum'] = '06b30f040696490474667e57d0802069'

# default['tz'] = 'EDT'
