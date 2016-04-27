VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Configure the box.
  config.vm.box = "gbarbieru/xenial"
  config.vm.hostname = "relight"

  # Don't replace the default key https://github.com/mitchellh/vagrant/pull/4707
  config.ssh.insert_key = false

  config.vm.provider :virtualbox do |vb|
    vb.name = "relight-base"
    vb.customize ["modifyvm", :id, "--memory", "2048"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end

  # Configure port forwarding.
  config.vm.network "forwarded_port", guest: 80, host: 8000

  config.vm.synced_folder "./", "/vagrant", disabled: true
end
