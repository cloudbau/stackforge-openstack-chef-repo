Vagrant.require_plugin "vagrant-berkshelf"
Vagrant.require_plugin "vagrant-cachier"
Vagrant.require_plugin "vagrant-omnibus"
Vagrant.require_plugin "chef"

Chef::Config.from_file(File.join(File.dirname(__FILE__), '.chef', 'knife.rb'))

chef_server_url = Chef::Config[:chef_server_url]
validation_client_name = Chef::Config[:validation_client_name]
validation_key = Chef::Config[:validation_key]

Vagrant.configure("2") do |config|
  # Berkshelf plugin configuration
  config.berkshelf.enabled = true

  # Cachier plugin configuration
  config.cache.auto_detect = true

  # Omnibus plugin configuration
  config.omnibus.chef_version = :latest

  # OpenStack-related settings
  config.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--cpus", 2]
      vb.customize ["modifyvm", :id, "--memory", 2048]
      vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
      vb.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
  end

  config.vm.define :controller do |controller|
    controller.vm.hostname = "controller"
    controller.vm.box = "opscode-ubuntu-12.04"
    controller.vm.box_url = "https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_provisionerless.box"
    controller.vm.network "private_network", ip: "33.33.33.60"
    controller.vm.network "private_network", ip: "192.168.100.60"
    
    controller.vm.provision :chef_client do |chef|
        chef.environment = "vagrant"
        chef.run_list = [ "role[os-compute-single-controller]" ]
        chef.chef_server_url = chef_server_url
        chef.validation_client_name = validation_client_name
        chef.validation_key_path = validation_key
        chef.provisioning_path = '/etc/chef'
      end
  end

  config.vm.define :network_node do |controller|
    controller.vm.hostname = "network"
    controller.vm.box = "opscode-ubuntu-12.04"
    controller.vm.box_url = "https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_provisionerless.box"
    controller.vm.network "private_network", ip: "33.33.33.61"
    controller.vm.network "private_network", ip: "192.168.100.61"
    
    controller.vm.provision :chef_client do |chef|
        chef.environment = "vagrant"
        chef.run_list = [ "role[os-network-server]" ]
        chef.chef_server_url = chef_server_url
        chef.validation_client_name =  validation_client_name
        chef.validation_key_path =  validation_key
        chef.provisioning_path = '/etc/chef'
      end
  end

  config.vm.define :compute do |controller|
    controller.vm.hostname = "compute"
    controller.vm.box = "opscode-ubuntu-12.04"
    controller.vm.box_url = "https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_provisionerless.box"
    controller.vm.network "private_network", ip: "33.33.33.62"
    controller.vm.network "private_network", ip: "192.168.100.62"    
    controller.vm.provision :chef_client do |chef|
        chef.environment = "vagrant"
        chef.run_list = [ "role[os-compute-worker]" ]
        chef.chef_server_url = chef_server_url
        chef.validation_key_path =  validation_key
        chef.validation_client_name = validation_client_name
        chef.provisioning_path = '/etc/chef'
      end
  end

end

