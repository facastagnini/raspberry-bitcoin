#
# Cookbook Name:: raspberry-bitcoin
# Recipe:: bitcoin-core
#
# Copyright (C) 2015 Federico Castagnini
#
# TODO: contribute to https://github.com/infertux/chef-bitcoin/
#

####################
# install compiling tools
base_packages = [
	'build-essential', 'autoconf', 'libssl-dev', 'libboost-dev', 
	'libboost-chrono-dev', 'libboost-filesystem-dev', 'libboost-program-options-dev', 
	'libboost-system-dev', 'libboost-test-dev', 'libboost-thread-dev', 'libtool']
base_packages.each do |base_pkg|
  package base_pkg
end
####################

version="0.10"

remote_file "/usr/src/bitcoin-#{version}.zip" do
  source "https://github.com/bitcoin/bitcoin/archive/#{version}.zip"
  #checksum node[:program][:checksum]
  notifies :run, "bash[install_program]", :immediately
end

# install Bitcoin Core
bash "install_program" do
  user "root"
  cwd "/usr/src"
  code <<-EOH
    tar -zxf bitcoin-#{version}.zip
    (cd bitcoin-#{version}/ && ./autogen.sh && ./configure --disable-wallet && make -j4 && strip bitcoind && make install)
  EOH
  action :nothing
end

# setup the bitcoin config file
directory /root/.bitcoin

template "/etc/bitcoin/bitcoin.conf" do
  mode "0600"
  action :create_if_missing
end