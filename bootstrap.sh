#/usr/bin/env bash
# Bootstrap the raspberry pi: install chef client and execute chef-solo
# References:
#             http://everydaytinker.com/raspberry-pi/installing-chef-client-on-a-raspberry-pi-2-model-b/

set -eux

apt_stuff() {
  apt-get update
  apt-get dist-upgrade -y
}

install_dependencies() {
  sudo apt-get -y install git build-essential libyaml-dev libssl-dev
}

install_ruby() {
  # remove outdated ruby
  apt-get purge ruby1.9 ruby1.8 -y
  apt-get autoremove --purge -y

  # install ruby 2.2.2, it will take a while...
  pushd /usr/src/
  test -f ruby-2.2.2.tar.gz || wget http://cache.ruby-lang.org/pub/ruby/2.2/ruby-2.2.2.tar.gz
  test -d ruby-2.2.2 || tar -xvzf ruby-2.2.2.tar.gz
  pushd ruby-2.2.2
  test -f config.status || ./configure --enable-shared --disable-install-doc --disable-install-rdoc --disable-install-capi
  test -f /usr/local/bin/ruby || make install
  popd
  popd
}

install_chef() {
  which chef-client || gem install chef --no-ri --no-rdoc
  which berks || gem install berkshelf --no-ri --no-rdoc
  #chef-client --version  
}

clone_repo() {
  pushd /usr/src
  test -d raspberry-bitcoin || git clone https://github.com/facastagnini/raspberry-bitcoin.git
  popd
}




apt_stuff
install_dependencies
install_ruby
install_chef
clone_repo
#run_chef_solo


echo "Installation complete. You should reboot now."