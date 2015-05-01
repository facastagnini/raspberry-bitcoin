default['apt']['unattended_upgrades']['enable'] = true
default['apt']['unattended_upgrades']['auto_fix_interrupted_dpkg'] = true
default['apt']['unattended_upgrades']['allowed_origins'] = [
  "#{node['platform'].capitalize} stable"
]

default['bitcoin']['source']['version'] = '0.10.1'
default['bitcoin']['source']['checksum'] = '18a88785748588bb90764dc7f0aad5548da880d4d91f5803c7076cbcadb2959e'

default['tz'] = 'EDT'