default['apt']['unattended_upgrades']['enable'] = true
default['apt']['unattended_upgrades']['auto_fix_interrupted_dpkg'] = true
default['apt']['unattended_upgrades']['allowed_origins'] = [
  "#{node['platform'].capitalize} stable"
]

default['bitcoin']['source']['version'] = '0.11.0'
default['bitcoin']['source']['checksum'] = 'efc6c496e0a3649a00aa30f07f7e86600b2d79890735fd5df8cc0fcaaf40e734'

# default['tz'] = 'EDT'
