name "os-base"
description "OpenStack Base role"
run_list(
  "recipe[openstack-network-wrapper]",
  "recipe[openstack-network-wrapper::neutron-default]",
  "recipe[openstack-common]",
  "recipe[openstack-common::logging]"
)
