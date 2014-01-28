name "os-network"
description "Configures OpenStack networking, managed by attribute for either nova-network or quantum"
run_list(
  "role[os-base]",
  "recipe[openstack-network::identity_registration]",
  "recipe[openstack-network::server]",
  "recipe[openstack-network-wrapper::l2-agent]",
  "recipe[openstack-network::l3_agent]",
  "recipe[openstack-network-wrapper::dhcp-agent]",
  "recipe[openstack-network::metadata_agent]",
  "recipe[openstack-network-wrapper::common]",
  "recipe[openstack-network-wrapper::l3-agent]",
  "recipe[openstack-network-wrapper::ml2-plugin]",
  )
