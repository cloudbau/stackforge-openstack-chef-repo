name "os-compute-worker"
description "The compute node, most likely with a hypervisor."
run_list(
  "role[os-base]",
  "recipe[openstack-compute-wrapper::compute]",
  "recipe[openstack-network-wrapper::common]",
  "recipe[openstack-network-wrapper::l2-agent]",
  "recipe[openstack-compute::compute]"
)
