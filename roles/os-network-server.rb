name "os-network-server"
description "Configures OpenStack networking, managed by attribute for either nova-network or quantum"
run_list(
  "role[os-base]",
    "recipe[openstack-network::common]",
    "recipe[openstack-network::openvswitch]",
    "recipe[openstack-network::identity_registration]",
    "recipe[openstack-network::server]",
    "recipe[openstack-network::dhcp_agent]",
    "recipe[openstack-network::l3_agent]",
    "recipe[openstack-network::metadata_agent]"
  )
