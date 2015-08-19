default['apt']['unattended_upgrades']['enable'] = true
default['apt']['unattended_upgrades']['auto_fix_interrupted_dpkg'] = true
default['apt']['unattended_upgrades']['allowed_origins'] = [
  "#{node['platform'].capitalize} stable"
]

default['bitcoin']['source']['url'] = 'https://github.com/bitcoinxt/bitcoinxt'
default['bitcoin']['source']['version'] = '0.11A'
default['bitcoin']['source']['checksum'] = '730eaa117b72778e17bb94f27f985002beb73618775e10623a0af349db84649e'

# default['tz'] = 'EDT'
