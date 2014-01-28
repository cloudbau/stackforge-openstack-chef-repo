name "extreme"
description "Environment used in testing the upstream cookbooks and reference Chef repository"

dashboard_path = "/opt/cloudbau/horizon-virtualenv/openstack_dashboard"
debian_pkg_repository = "http://10.20.0.18:9090"

override_attributes(
  "postgresql" => {
    "pg_hba" => [
        {:type => 'local', :db => 'all', :user => 'postgres', :addr => nil, :method => 'ident'},
        {:type => 'local', :db => 'all', :user => 'all', :addr => nil, :method => 'ident'},
        {:type => 'host', :db => 'all', :user => 'all', :addr => '127.0.0.1/32', :method => 'md5'},
        {:type => 'host', :db => 'all', :user => 'all', :addr => '::1/128', :method => 'md5'},
        # FIXME: Need to automatically set controller ip here.
        # {:type => 'host', :db => 'all', :user => 'all', :addr => controller_ip_address + "/32", :method => 'md5'}
    ]
  },
  "mysql" => {
    "allow_remote_root" => true,
    "root_network_acl" => "%"
  },
  "openstack" => {
    "apt" => {
       "uri" => debian_pkg_repository,
       "components" => ["cloudbau", "main"]
    },
    "auth" => {
      "validate_certs" => false
    },
    "dashboard" => {
      "platform" => {
        "mysql_python_packages" => [],
	    "postgresql_python_packages" => [],
        "memcache_python_packages" => [],
        "horizon_packages" => ["cloudbau-horizon"],
        "package_overrides" => "-o Dpkg::Options::='--force-confold' -o Dpkg::Options::='--force-confdef' --force-yes"
      },
      "static_path" => "#{dashboard_path}/static",
      "local_settings_path" => "#{dashboard_path}/local/local_settings.py",
      "dash_path" => "#{dashboard_path}",
      "python_path" => "/opt/cloudbau/horizon-virtualenv/lib/python2.7/site-packages",
      "stylesheet_path" => "#{dashboard_path}/templates/_stylesheets.html"
    },
    "network" => {
      "platform" => {
        "mysql_python_packages" => [],
        "postgresql_python_packages" => [],
        "nova_network_packages" => [],
        "quantum_lb_packages" => ["cloudbau-neutron"],
        "quantum_packages" => ["cloudbau-neutron"],
        "quantum_client_packages" => [],
        "quantum_dhcp_packages" => ["cloudbau-neutron"],
        "quantum_l3_packages" => [],
        "quantum_openvswitch_agent_packages" => [],
        "quantum_linuxbridge_agent_packages" => [],
        "quantum_metadata_agent_packages" => ["cloudbau-neutron"],
        "quantum_openvswitch_agent_service" => "neutron-openvswitch-agent",
        "quantum_plugin_package" => "cloudbau-neutron",
        "quantum_server_packages" => ["cloudbau-neutron"],
        "quantum_openvswitch_packages" => ["openvswitch-datapath-dkms", "openvswitch-switch", "bridge-utils"],
        "package_overrides" => "-o Dpkg::Options::='--force-confold' -o Dpkg::Options::='--force-confdef' --force-yes"
      },
      "core_plugin" => "neutron.plugins.ml2.plugin.Ml2Plugin",
      "service_plugins" => %w{
        neutron.services.l3_router.l3_router_plugin.L3RouterPlugin
      },
      "interface_driver" => "neutron.agent.linux.interface.BridgeInterfaceDriver",
      "openvswitch" => {
        "tenant_network_type" => "gre",
        "enable_tunneling" => "True",
        "tunnel_id_ranges" => "1:1000",
        "local_ip_interface" => "p1p1"
      },
      "linuxbridge" => {
        "tenant_network_type" => "vlan",
        "physical_interface_mappings" => "public:p1p1,default:p1p2"
      },
      "ml2" => {
        "type_drivers" => %w{vlan flat},
        "tenant_network_types" => %w{vlan},
        "mechanism_drivers" => %w{extreme linuxbridge},
	"vlan" => {
          "network_vlan_ranges" => %w{default:2:4090}
        },
        "flat" => {
          "flat_networks" => %w{public},
        },
        "extreme" => {
          "host_to_port" => [
            "node1-07-2d:5",
            "node1-07-2c:3"
          ],
          "endpoints" => [
            {
              "url" => "http://10.30.0.1",
              "username" => "mbenchchaoui",
              "password" => "mbenchchaoui",
              "api" => "soap"
            }, 
          ]
        }
      },
      "l3" => {
        "external_network_bridge_interface" => "",
        "external_network_bridge" => ""
      },
      "allow_overlapping_ips" => "True"
    },
    "block-storage" => {
      "platform" => {
        "mysql_python_packages" => [],
        "postgresql_python_packages" => [],
        "cinder_common_packages" => ["cloudbau-cinder"],
        "cinder_api_packages" => [],
        "cinder_volume_packages" => ["cloudbau-cinder"],
        "cinder_scheduler_packages" => ["cloudbau-cinder"],
        "package_overrides" => "-o Dpkg::Options::='--force-confold' -o Dpkg::Options::='--force-confdef' --force-yes"
      },
      "syslog" => {
        "use" => false
      },
      "api" => {
        "ratelimit" => "False"
      },
      "debug" => true,
      "image_api_chef_role" => "os-image",
      "identity_service_chef_role" => "os-identity",
      "rabbit_server_chef_role" => "os-ops-messaging",
      "volume" => {
        "driver" => "cinder.volume.drivers.lvm.LVMISCSIDriver"
      }
    },
    "compute" => {
      "platform" => {
        "mysql_python_packages" => [],
        "postgresql_python_packages" => [],
        "api_ec2_packages" => ["cloudbau-nova"],
        "api_os_compute_packages" => ["cloudbau-nova"],
        "neutron_python_packages" => [],
        "compute_api_metadata_packages" => ["cloudbau-nova"],
        "compute_compute_packages" => ["cloudbau-nova"],
        "compute_network_packages" => ["iptables", "cloudbau-nova"],
        "compute_scheduler_packages" => ["cloudbau-nova"],
        "compute_conductor_packages" => ["cloudbau-nova"],
        "compute_vncproxy_packages" => [],
        "compute_vncproxy_consoleauth_packages" => ["cloudbau-nova"],
        "compute_cert_packages" => ["cloudbau-nova"],
        "common_packages" => ["cloudbau-nova"],
        "cinder_volume_packages" => ["open-iscsi", "open-iscsi-utils"],
        "package_overrides" => "-o Dpkg::Options::='--force-confold' -o Dpkg::Options::='--force-confdef' --force-yes"
      },
      "syslog" => {
        "use" => false
      },
      "libvirt" => {
        "virt_type" => "qemu", # FIXME(Mouad): Test kvm again.
        "bind_interface" => "p1p1"
      },
      "novnc_proxy" => {
        "bind_interface" => "p1p1"
      },
      "xvpvnc_proxy" => {
        "bind_interface" => "p1p1"
      },
      "image_api_chef_role" => "os-image",
      "identity_service_chef_role" => "os-identity",
      "nova_setup_chef_role" => "os-compute-api",
      "rabbit_server_chef_role" => "os-ops-messaging",
      "network" => {
        "fixed_range" => "10.0.0.0/8",
        "plugins" => ["openvswitch", "dhcp_agent"],
        "quantum" => {
          "libvirt_vif_driver" => "nova.virt.libvirt.vif.LibvirtGenericVIFDriver"
        }
      },
      "networks" => [
      ]
    },
    "db" => {
      "bind_interface" => "p1p1"
    },
    "developer_mode" => true,
    "endpoints" => {
      "compute-api" => {
        "bind_interface" => "p1p1",
        "scheme" => "http",
        "port" => "8774",
        "path" => "/v2/%(tenant_id)s"
      },
      "compute-ec2-admin" => {
        "bind_interface" => "p1p1",
        "scheme" => "http",
        "port" => "8773",
        "path" => "/services/Admin"
      },
      "compute-ec2-api" => {
        "bind_interface" => "p1p1",
        "scheme" => "http",
        "port" => "8773",
        "path" => "/services/Cloud"
      },
      "compute-xvpvnc" => {
        "bind_interface" => "p1p1",
        "scheme" => "http",
        "port" => "6081",
        "path" => "/console"
      },
      "compute-novnc" => {
        "bind_interface" => "p1p1",
        "scheme" => "https",
        "port" => "6080",
        "path" => "/vnc_auto.html"
      },
      "image-api" => {
        "bind_interface" => "p1p1",
        "scheme" => "http",
        "port" => "9292",
        # XXX(Mouad): image-api should not include version, else tempest run fail.
        "path" => ""
      },
      "image-registry" => {
        "bind_interface" => "p1p1",
        "scheme" => "http",
        "port" => "9191",
        "path" => "v2"
      },
      "identity-api" => {
        "bind_interface" => "p1p1",
        "scheme" => "http",
        "port" => "5000",
        "path" => "/v2.0"
      },
      "identity-admin" => {
        "bind_interface" => "p1p1",
        "scheme" => "http",
        "port" => "35357",
        "path" => "/v2.0"
      },
      "volume-api" => {
        "bind_interface" => "p1p1",
        "scheme" => "http",
        "port" => "8776",
        "path" => "/v1/%(tenant_id)s"
      },
      "metering-api" => {
        "bind_interface" => "p1p1",
        "scheme" => "http",
        "port" => "8777",
        "path" => "/v1"
      },
      "network-api" => {
        "bind_interface" => "p1p1",
        "scheme" => "http",
        "port" => "9696"
      }
    },
    "identity" => {
      "platform" => {
        "keystone_packages" => ["cloudbau-keystone"],
        "mysql_python_packages" => [],
        "postgresql_python_packages" => [],
        "package_options" => "-o Dpkg::Options::='--force-confold' -o Dpkg::Options::='--force-confdef' --force-yes"
      },
      "admin_user" => "ksadmin",
      "bind_interface" => "p1p1",
      "catalog" => {
        "backend" => "sql"
      },
      "debug" => true,
      "rabbit_server_chef_role" => "os-ops-messaging",
      "roles" => [
        "admin",
        "keystone_admin",
        "keystone_service_admin",
        "member",
        "netadmin",
        "sysadmin"
      ],
      "syslog" => {
        "use" => false
      },
      "tenants" => [
        "admin",
        "service",
        "demo"
      ],
      "users" => {
        "ksadmin" => {
          "password" => "ksadmin",
          "default_tenant" => "admin",
          "roles" => { # Each key is the role name, each value is a list of tenants
            "admin" => [
              "admin"
            ],
            "keystone_admin" => [
              "admin"
            ],
            "keystone_service_admin" => [
              "admin"
            ]
          }
        },
        "demo" => {
          "password" => "demo",
          "default_tenant" => "demo",
          "roles" => { # Each key is the role name, each value is a list of tenants
            "sysadmin" => [
              "demo"
            ],
            "netadmin" => [
              "demo"
            ],
            "member" => [
              "demo"
            ]
          }
        }
      }
    },
    "image" => {
      "platform" => {
        "mysql_python_packages" => [],
        "postgresql_python_packages" => [],
        "image_packages" => ["cloudbau-glance"],
        "package_overrides" => "-o Dpkg::Options::='--force-confold' -o Dpkg::Options::='--force-confdef' --force-yes"
      },
      "api" => {
        "bind_interface" => "p1p1"
      },
      "debug" => true,
      "identity_service_chef_role" => "os-identity",
      "image_upload" => true,
      "rabbit_server_chef_role" => "os-ops-messaging",
      "registry" => {
        "bind_interface" => "p1p1"
      },
      "syslog" => {
        "use" => false
      },
      "upload_image" => {
        "cirros" => "https://launchpad.net/cirros/trunk/0.3.0/+download/cirros-0.3.0-x86_64-disk.img",
      },
      "upload_images" => [
        "cirros"
      ]
    },
    "mq" => {
      "bind_interface" => "p1p1",
      "user" => "guest"
    }
  }
)
