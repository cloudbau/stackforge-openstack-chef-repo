
## Prerequisites

1. You have to have an external chef server running at the moment (e.g. hosted chef)
2. You need to have the following vagrant plugins installed
 - vagrant-berkshelf
 - vagrant-cachier
 - vagrant-omnibus
 - chef
3. You need to have a valid `knife.rb` config file located at .chef/knife.rb`

## Starting the mutli node setup

1. `knife environment from file environments/vagrant.json`
2. `vagrant up controller`
3. `vagrant up network_node`
4. `vagrant up compute`
5. Go to https://192.168.100.60 and log in
