name "os-compute-worker"
description "The compute node, most likely with a hypervisor."
run_list(
  "role[os-base]",
  "recipe[stackforge-havana::nova-compute]",
  "recipe[stackforge-havana::neutron-common]",
  "recipe[openstack-compute::compute]"
)
