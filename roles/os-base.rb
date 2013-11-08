name "os-base"
description "OpenStack Base role"
run_list(
  "recipe[stackforge-havana]",
  "recipe[stackforge-havana::neutron-default]",
  "recipe[openstack-common]",
  "recipe[openstack-common::logging]"
)
