#
# Cookbook Name:: raspberry-bitcoin
# Recipe:: default
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

#include_recipe 'apt'
include_recipe 'apt::unattended-upgrades'
include_recipe 'ntp'
include_recipe 'timezone-ii'
include_recipe 'locale'

####################
# install base tools
base_packages = ['htop', 'iotop', 'usbutils', 'dosfstools', 'bridge-utils', 'iw', 'wpasupplicant', 'vim', 'ifmetric']
base_packages.each do |base_pkg|
  package base_pkg
end
####################
