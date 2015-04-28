# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "https://s3.eu-central-1.amazonaws.com/ffuenf-vagrantboxes/debian/debian-7.8.0-amd64_virtualbox.box"

  config.vm.provider "virtualbox" do |v|

    v.gui = false
    v.name = "raspberry-pi"

    host = RbConfig::CONFIG['host_os']

    v.customize ["modifyvm", :id, "--memory", "1024"]
    v.customize ["modifyvm", :id, "--cpus", "4"]
    v.customize ["modifyvm", :id, "--ioapic", "on"]

  end

  config.vm.provision "shell", path: "bootstrap.sh"

end
