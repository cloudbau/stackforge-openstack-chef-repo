name "ci"
description "Environment used in testing the upstream cookbooks and reference Chef repository"

override_attributes(
  "postgresql" => {
    "pg_hba" => [
        {:type => 'local', :db => 'all', :user => 'postgres', :addr => nil, :method => 'ident'},
        {:type => 'local', :db => 'all', :user => 'all', :addr => nil, :method => 'ident'},
        {:type => 'host', :db => 'all', :user => 'all', :addr => '127.0.0.1/32', :method => 'md5'},
        {:type => 'host', :db => 'all', :user => 'all', :addr => '::1/128', :method => 'md5'}# ,
        #{:type => 'host', :db => 'all', :user => 'all', :addr => '10.0.103.5/32', :method => 'md5'} 
    ]
  },
  "openstack" => {
    "auth" => {
      "validate_certs" => false
    },
    "network" => {
      "core_plugin" => "neutron.plugins.linuxbridge.lb_neutron_plugin.LinuxBridgePluginV2",
      "interface_driver" => "neutron.agent.linux.interface.BridgeInterfaceDriver",
      "l3" => {
        "external_network_bridge_interface" => "eth0",
        "external_network_bridge" => ""  # Linux bridge
      },
      "linuxbridge" => {
         "tenant_network_type" => "vlan",
         "network_vlan_ranges" => "physnet1:1000:2999",
         "physical_interface_mappings" => "physnet1:eth0"
      },
      "rabbit" => {
         "host" => "10.0.103.5"
      }
    },
    "block-storage" => {
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
      "rabbit" => {
        "host" => "10.0.103.5"
      },
      "syslog" => {
        "use" => false
      },
      "libvirt" => {
        "bind_interface" => "eth0.211"
      },
      "novnc_proxy" => {
        "bind_interface" => "eth0"
      },
      "xvpvnc_proxy" => {
        "bind_interface" => "eth0"
      },
      "image_api_chef_role" => "os-image",
      "identity_service_chef_role" => "os-identity",
      "nova_setup_chef_role" => "os-compute-api",
      "rabbit_server_chef_role" => "os-ops-messaging",
      "ratelimit" => {  # Disable ratelimiting so Tempest doesn't have issues.
        "api" => {
          "enabled" => false
        },
        "volume" => {
          "enabled" => false
        }
      },
      "network" => {
        "fixed_range" => "10.0.0.0/8",
        "plugins" => ["linuxbridge", "dhcp_agent"]
      },
      "networks" => [
      ]
    },
    "db" => {
      # FIXME: Let'try lo first: "bind_interface" => "eth0.211",
      "service_type" => "postgresql",
      "compute" => {
        "port" => "5432"
      },
      "identity" => {
        "port" => "5432"
      },
      "image" => {
        "port" => "5432"
      },
      "network" => {
        "port" => "5432"
      },
      "volume" => {
        "port" => "5432"
      },
      "dashboard" => {
        "port" => "5432"
      },
      "metering" => {
        "port" => "5432"
      }
    },
    "developer_mode" => true,
    "endpoints" => {
      "compute-api" => {
        "host" => "10.0.3.5",
        "scheme" => "http",
        "port" => "8774",
        "path" => "/v2/%(tenant_id)s"
      },
      "compute-ec2-admin" => {
        "host" => "10.0.3.5",
        "scheme" => "http",
        "port" => "8773",
        "path" => "/services/Admin"
      },
      "compute-ec2-api" => {
        "host" => "10.0.3.5",
        "scheme" => "http",
        "port" => "8773",
        "path" => "/services/Cloud"
      },
      "compute-xvpvnc" => {
        "host" => "10.0.3.5",
        "scheme" => "http",
        "port" => "6081",
        "path" => "/console"
      },
      "compute-novnc" => {
        "host" => "10.0.3.5",
        "scheme" => "http",
        "port" => "6080",
        "path" => "/vnc_auto.html"
      },
      "image-api" => {
        "host" => "10.0.3.5",
        "scheme" => "http",
        "port" => "9292",
        "path" => "/v2"
      },
      "image-registry" => {
        "host" => "10.0.103.5",
        "scheme" => "http",
        "port" => "9191",
        "path" => "/v2"
      },
      "identity-api" => {
        "host" => "10.0.3.5",
        "scheme" => "http",
        "port" => "5000",
        "path" => "/v2.0"
      },
      "identity-admin" => {
        "host" => "10.0.3.5",
        "scheme" => "http",
        "port" => "35357",
        "path" => "/v2.0"
      },
      "volume-api" => {
        "host" => "10.0.3.5",
        "scheme" => "http",
        "port" => "8776",
        "path" => "/v1/%(tenant_id)s"
      },
      "metering-api" => {
        "host" => "10.0.3.5",
        "scheme" => "http",
        "port" => "8777",
        "path" => "/v1"
      },
      "network-api" => {
        "host" => "10.0.3.5",
        "scheme" => "http",
        "port" => "9696"
      }
    },
    "identity" => {
      "admin_user" => "ksadmin",
      "bind_interface" => "eth0",
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
      "api" => {
        "bind_interface" => "eth0"
      },
      "debug" => true,
      "identity_service_chef_role" => "os-identity",
      "image_upload" => true,
      "rabbit_server_chef_role" => "os-ops-messaging",
      "registry" => {
        "bind_interface" => "eth0.211"
      },
      "syslog" => {
        "use" => false
      },
      "upload_image" => {
        "cirros" => "http://hypnotoad/cirros-0.3.0-x86_64-disk.img",
      },
      "upload_images" => [
        "cirros"
      ]
    },
    "mq" => {
      "bind_interface" => "eth0.211",
      "host" => "10.0.103.5",
      "user" => "guest"
    }
  }
)
