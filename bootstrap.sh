#/usr/bin/env bash
# Bootstrap the raspberry pi: install chef client and execute chef-solo
# References:
#             http://everydaytinker.com/raspberry-pi/installing-chef-client-on-a-raspberry-pi-2-model-b/
#             https://gist.github.com/blacktm/8302741#file-install_ruby_rpi-sh


install_dependencies() {
  sudo apt-get -y install git build-essential libyaml-dev libssl-dev
}

#clone_repo() {
#  git clone git@github.com:facastagnini/raspberry-bitcoin.git
#}

install_ruby() {
  # remove outdated ruby
  apt-get purge ruby1.9 ruby1.8 -y

  # install ruby 2.2.2, it will take a while...
  pushd /usr/src/
  wget http://cache.ruby-lang.org/pub/ruby/2.2/ruby-2.2.2.tar.gz
  tar -xvzf ruby-2.2.2.tar.gz
  pushd ruby-2.2.2
  ./configure --enable-shared --disable-install-doc --disable-install-rdoc --disable-install-capi
  make install
  popd
  popd
}

install_chef() {
  gem install chef --no-ri --no-rdoc
  #chef-server --version  
}


# update apt references
apt-get update

install_dependencies
install_ruby
#install_chef
#clone_repo
#run_chef_solo
