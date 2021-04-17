Vagrant.configure("2") do |config|
  config.vm.define :test do |test|
    test.vm.hostname = "focal"
    test.vm.box = "generic/ubuntu2004"
    test.vm.box_check_update = false
    test.vm.network "private_network", ip: "192.168.18.9"
    test.vm.synced_folder "./", "/vagrant", type: "rsync"
    test.vm.provision "shell", path: "./bin/vagrant-provisioner"
    test.vm.provider :libvirt do |v|
      v.memory = 1024
    end
  end
end
