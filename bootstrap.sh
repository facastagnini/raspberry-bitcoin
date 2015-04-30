#/usr/bin/env bash
# Bootstrap the raspberry pi: install chef client and execute chef-solo
set -eux

apt_stuff() {
  apt-get update
  apt-get dist-upgrade -y
}

install_dependencies() {
  sudo apt-get -y install git build-essential libyaml-dev libssl-dev autoconf libgecode-dev dphys-swapfile
}

increase_swap() {
  echo "CONF_SWAPSIZE=4096" > /etc/dphys-swapfile
  dphys-swapfile swapoff
  dphys-swapfile setup
  dphys-swapfile swapon
}

install_ruby() {
  # reference: http://everydaytinker.com/raspberry-pi/installing-chef-client-on-a-raspberry-pi-2-model-b/

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

  # use the system version, instead of downloading the source and building its own copy.
  gem list --local | grep dep-selector-libgecode || USE_SYSTEM_GECODE=1 gem install dep-selector-libgecode

  # install berks
  which berks || gem install berkshelf --no-ri --no-rdoc
}

clone_repo() {
  pushd /usr/src
  if test -d raspberry-bitcoin
  then
    pushd raspberry-bitcoin
    git pull
    popd
  else
    git clone https://github.com/facastagnini/raspberry-bitcoin.git
  fi
  popd
}

run_berks() {
  pushd /usr/src/raspberry-bitcoin
  rm -rf berks-cookbooks
  berks install --berksfile=./cookbooks/raspberry-bitcoin/Berksfile
  berks update  --berksfile=./cookbooks/raspberry-bitcoin/Berksfile
  berks vendor  --berksfile=./cookbooks/raspberry-bitcoin/Berksfile
  popd
}

run_chef() {
  pushd /usr/src/raspberry-bitcoin
  chef-client --local-mode -o raspberry-bitcoin --conf .chef/client.rb
  popd
}


apt_stuff
install_dependencies
increase_swap
install_ruby
install_chef
clone_repo
run_berks
run_chef


echo "Installation complete. You should reboot now."
