Vagrant.require_plugin "vagrant-berkshelf"
Vagrant.require_plugin "vagrant-chef-zero"
Vagrant.require_plugin "vagrant-omnibus"
Vagrant.require_plugin "chef"

Chef::Config.from_file(File.join(File.dirname(__FILE__), '.chef', 'knife.rb'))

chef_server_url = Chef::Config[:chef_server_url]
validation_client_name = Chef::Config[:validation_client_name]
validation_key = Chef::Config[:validation_key]

Vagrant.configure("2") do |config|
  # Berkshelf plugin configuration
  config.berkshelf.enabled = true

  # Chef-Zero plugin configuration
  config.chef_zero.enabled = false
  config.chef_zero.chef_repo_path = "."

  # Omnibus plugin configuration
  config.omnibus.chef_version = :latest

  # # Port forwarding rules, for access to openstack services
  # config.vm.network "forwarded_port", guest: 443, host: 8443     # dashboard-ssl
  # config.vm.network "forwarded_port", guest: 8773, host: 8773    # compute-ec2-api
  # config.vm.network "forwarded_port", guest: 8774, host: 8774    # compute-api

  # OpenStack-related settings
  config.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--cpus", 2]
      vb.customize ["modifyvm", :id, "--memory", 2048]
      vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
      vb.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
  end


  config.vm.box = "opscode-ubuntu-12.04"
  config.vm.box_url = "https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_provisionerless.box"

  config.vm.define :chefserver do |chefserver|
    chefserver.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--cpus", 1]
      vb.customize ["modifyvm", :id, "--memory", 512]
    end
    chefserver.vm.hostname = "chefserver"
    chefserver.vm.network "private_network", ip: "33.33.33.11"
    chefserver.vm.provision :chef_solo do |chef|
      chef.run_list = 'chef-server'
      chef.json = {
        'chef-server' => {
          'api_fqdn' => '33.33.33.11'
        }
      }
    end
    chefserver.vm.provision :shell,
      :inline => "cp /etc/chef-server/chef-validator.pem /vagrant/; " \
                 "stat /vagrant/#{ENV['USER']}.pem || knife user create -a -k /etc/chef-server/admin.pem -u admin -f /vagrant/#{ENV['USER']}.pem -d -k /etc/chef-server/admin.pem -u admin -f /vagrant/#{ENV['USER']}.pem -d -p #{ENV['USER']} #{ENV['USER']} "
  end

  config.vm.define :controller do |controller|
    controller.vm.hostname = "controller"
    controller.vm.network "private_network", ip: "33.33.33.60"
    controller.vm.network "private_network", ip: "192.168.100.50"
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

  config.vm.define :network_node do |node|
    node.vm.hostname = "network"
    node.vm.network "private_network", ip: "33.33.33.61"
    node.vm.network "private_network", ip: "192.168.100.61"
    
    node.vm.provision :chef_client do |chef|
        chef.environment = "vagrant"
        chef.run_list = [ "role[os-network-server]" ]
        chef.chef_server_url = chef_server_url
        chef.validation_client_name =  validation_client_name
        chef.validation_key_path =  validation_key
        chef.provisioning_path = '/etc/chef'
      end
  end

  config.vm.define :compute do |node|
    node.vm.hostname = "compute"
    node.vm.network "private_network", ip: "33.33.33.62"
    node.vm.network "private_network", ip: "33.33.33.52"
    node.vm.network "private_network", ip: "192.168.100.62"    
    node.vm.provision :chef_client do |chef|
        chef.environment = "vagrant"
        chef.run_list = [ "role[os-compute-worker]" ]
        chef.chef_server_url = chef_server_url
        chef.validation_key_path =  validation_key
        chef.validation_client_name = validation_client_name
        chef.provisioning_path = '/etc/chef'
      end
  end

end
