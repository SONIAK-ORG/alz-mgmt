/*
--- Built-in Replacements ---
This file contains built-in replacements to avoid repeating the same hard-coded values.
Replacements are denoted by the dollar-dollar curly braces token (e.g., $${starter_location_01}). The following details each built-in replacement that you can use:
- `starter_location_01`: Primary Azure location sourced from the `starter_locations` variable. 
- `starter_location_02` to `starter_location_10`: Secondary Azure locations sourced from the `starter_locations` variable.
- `starter_location_01_availability_zones` to `starter_location_10_availability_zones`: Availability zones for the Azure locations sourced from the `starter_locations` variable.
- `starter_location_01_virtual_network_gateway_sku_express_route` to `starter_location_10_virtual_network_gateway_sku_express_route`: Default SKUs for the ExpressRoute virtual network gateways.
- `starter_location_01_virtual_network_gateway_sku_vpn` to `starter_location_10_virtual_network_gateway_sku_vpn`: Default SKUs for VPN virtual network gateways.
- `root_parent_management_group_id`: ID of the management group for the ALZ hierarchy.
- `subscription_id_identity`: Subscription ID for identity resources, sourced from the `subscription_id_identity` variable.
- `subscription_id_connectivity`: Subscription ID for connectivity resources, sourced from the `subscription_id_connectivity` variable.
- `subscription_id_management`: Subscription ID for management resources, sourced from the `subscription_id_management` variable.
*/

/*
--- Custom Replacements ---
You can define custom replacements to use throughout the configuration.
*/
custom_replacements = {
  names = {
    # Resource group names
    management_resource_group_name               = "rg-management-$${starter_location_01}"
    connectivity_hub_vwan_resource_group_name    = "rg-hub-vwan-$${starter_location_01}"
    connectivity_hub_primary_resource_group_name = "rg-hub-$${starter_location_01}"
    dns_resource_group_name                      = "rg-hub-dns-$${starter_location_01}"
    asc_export_resource_group_name               = "rg-asc-export-$${starter_location_01}"

    # Resource names
    log_analytics_workspace_name            = "law-management-$${starter_location_01}"
    automation_account_name                 = "aa-management-$${starter_location_01}"
    ama_user_assigned_managed_identity_name = "uami-management-ama-$${starter_location_01}"
    dcr_change_tracking_name                = "dcr-change-tracking"
    dcr_defender_sql_name                   = "dcr-defender-sql"
    dcr_vm_insights_name                    = "dcr-vm-insights"

    # Resource names for primary connectivity
    primary_hub_name                                   = "vwan-hub-$${starter_location_01}"
    primary_sidecar_virtual_network_name               = "vnet-sidecar-$${starter_location_01}"
    # primary_firewall_name                              = "fw-hub-$${starter_location_01}"
    # primary_firewall_policy_name                       = "fwp-hub-$${starter_location_01}"
    # primary_virtual_network_gateway_express_route_name = "vgw-hub-er-$${starter_location_01}"
    # primary_virtual_network_gateway_vpn_name           = "vgw-hub-vpn-$${starter_location_01}"
    primary_private_dns_resolver_name                  = "pdr-hub-dns-$${starter_location_01}"
    # primary_bastion_host_name                          = "btn-hub-$${starter_location_01}"
    # primary_bastion_host_public_ip_name                = "pip-bastion-hub-$${starter_location_01}"

    # Private DNS Zones
    primary_auto_registration_zone_name = "$${starter_location_01}.azure.local"

    # IP Ranges for Primary Hub
    primary_hub_address_space                          = "10.0.0.0/22"
    primary_side_car_virtual_network_address_space     = "10.0.4.0/22"
    primary_bastion_subnet_address_prefix              = "10.0.4.0/26"
    primary_private_dns_resolver_subnet_address_prefix = "10.0.4.64/28"
  }

  resource_group_identifiers = {
    management_resource_group_id = "/subscriptions/$${subscription_id_management}/resourcegroups/$${management_resource_group_name}"
  }

  resource_identifiers = {
    ama_change_tracking_data_collection_rule_id = "$${management_resource_group_id}/providers/Microsoft.Insights/dataCollectionRules/$${dcr_change_tracking_name}"
    ama_mdfc_sql_data_collection_rule_id        = "$${management_resource_group_id}/providers/Microsoft.Insights/dataCollectionRules/$${dcr_defender_sql_name}"
    ama_vm_insights_data_collection_rule_id     = "$${management_resource_group_id}/providers/Microsoft.Insights/dataCollectionRules/$${dcr_vm_insights_name}"
    ama_user_assigned_managed_identity_id       = "$${management_resource_group_id}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/$${ama_user_assigned_managed_identity_name}"
    log_analytics_workspace_id                  = "$${management_resource_group_id}/providers/Microsoft.OperationalInsights/workspaces/$${log_analytics_workspace_name}"
  }
}

enable_telemetry = false

/*
--- Tags ---
This variable can be used to apply tags to all resources that support it. Some resources allow overriding these tags.
*/
tags = {
  deployed_by = "terraform"
  source      = "Azure Landing Zones Accelerator"
}

/* 
--- Management Resources ---
*/
management_resource_settings = {
  automation_account_name      = "$${automation_account_name}"
  location                     = "$${starter_location_01}"
  log_analytics_workspace_name = "$${log_analytics_workspace_name}"
  resource_group_name          = "$${management_resource_group_name}"
  user_assigned_managed_identities = {
    ama = {
      name = "$${ama_user_assigned_managed_identity_name}"
    }
  }
  data_collection_rules = {
    change_tracking = {
      name = "$${dcr_change_tracking_name}"
    }
    defender_sql = {
      name = "$${dcr_defender_sql_name}"
    }
    vm_insights = {
      name = "$${dcr_vm_insights_name}"
    }
  }
}

/* 
--- Management Groups and Policy ---
*/
management_group_settings = {
  location           = "$${starter_location_01}"
  architecture_name  = "alz"
  parent_resource_id = "$${root_parent_management_group_id}"
  policy_default_values = {
    ama_change_tracking_data_collection_rule_id = "$${ama_change_tracking_data_collection_rule_id}"
    ama_mdfc_sql_data_collection_rule_id        = "$${ama_mdfc_sql_data_collection_rule_id}"
    ama_vm_insights_data_collection_rule_id     = "$${ama_vm_insights_data_collection_rule_id}"
    ama_user_assigned_managed_identity_id       = "$${ama_user_assigned_managed_identity_id}"
    ama_user_assigned_managed_identity_name     = "$${ama_user_assigned_managed_identity_name}"
    log_analytics_workspace_id                  = "$${log_analytics_workspace_id}"
    private_dns_zone_subscription_id            = "$${subscription_id_connectivity}"
    private_dns_zone_region                     = "$${starter_location_01}"
    private_dns_zone_resource_group_name        = "$${dns_resource_group_name}"
  }
  subscription_placement = {
    identity = {
      subscription_id       = "$${subscription_id_identity}"
      management_group_name = "Fabric-identity"
    }
    connectivity = {
      subscription_id       = "$${subscription_id_connectivity}"
      management_group_name = "Fabric-connectivity"
    }
    management = {
      subscription_id       = "$${subscription_id_management}"
      management_group_name = "Fabric-management"
    }
  }
  policy_assignments_to_modify = {
    connectivity = {
      policy_assignments = {
        Enable-DDoS-VNET = {
          enforcement_mode = "DoNotEnforce"
        }
      }
    }
  }
}

/* 
--- Connectivity - Virtual WAN ---
*/
connectivity_type = "virtual_wan"

connectivity_resource_groups = {
  vwan = {
    name     = "$${connectivity_hub_vwan_resource_group_name}"
    location = "$${starter_location_01}"
  }
  vwan_hub_primary = {
    name     = "$${connectivity_hub_primary_resource_group_name}"
    location = "$${starter_location_01}"
  }
  dns = {
    name     = "$${dns_resource_group_name}"
    location = "$${starter_location_01}"
  }
}

virtual_wan_settings = {
  name                = "vwan-$${starter_location_01}"
  resource_group_name = "$${connectivity_hub_vwan_resource_group_name}"
  location            = "$${starter_location_01}"
}

virtual_wan_virtual_hubs = {
  primary = {
    hub = {
      name            = "$${primary_hub_name}"
      resource_group  = "$${connectivity_hub_primary_resource_group_name}"
      location        = "$${starter_location_01}"
      address_prefix  = "$${primary_hub_address_space}"
    }
    firewall = {
      name     = "$${primary_firewall_name}"
      sku_name = "AZFW_Hub"
      sku_tier = "Standard"
      zones    = "$${starter_location_01_availability_zones}"
    }
    firewall_policy = {
      name = "$${primary_firewall_policy_name}"
    }
    virtual_network_gateways = {
      express_route = {
        name = "$${primary_virtual_network_gateway_express_route_name}"
      }
      vpn = {
        name = "$${primary_virtual_network_gateway_vpn_name}"
      }
    }
    private_dns_zones = {
      resource_group_name            = "$${dns_resource_group_name}"
      is_primary                     = true
      auto_registration_zone_enabled = true
      auto_registration_zone_name    = "$${primary_auto_registration_zone_name}"
      subnet_address_prefix          = "$${primary_private_dns_resolver_subnet_address_prefix}"
      private_dns_resolver = {
        name = "$${primary_private_dns_resolver_name}"
      }
    }
    bastion = {
      subnet_address_prefix = "$${primary_bastion_subnet_address_prefix}"
      bastion_host = {
        name = "$${primary_bastion_host_name}"
      }
      bastion_public_ip = {
        name  = "$${primary_bastion_host_public_ip_name}"
        zones = "$${starter_location_01_availability_zones}"
      }
    }
    side_car_virtual_network = {
      name          = "$${primary_sidecar_virtual_network_name}"
      address_space = ["$${primary_side_car_virtual_network_address_space}"]
    }
  }
}