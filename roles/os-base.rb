name "os-base"
description "OpenStack Base role"
run_list(
  "recipe[openstack-common-wrapper::set-ip-by-interface]",
  "recipe[openstack-network-wrapper]",
  "recipe[openstack-network-wrapper::common]",
  "recipe[openstack-common]",
  "recipe[openstack-common::logging]"
)
