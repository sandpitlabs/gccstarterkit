resource "azurerm_user_assigned_identity" "aks_identity" {
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  name = "${var.name}Identity"

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                             = var.name
  location                         = var.location
  resource_group_name              = var.resource_group_name
  default_node_pool {
    name                    = var.system_node_pool_name
    vm_size                 = var.system_node_pool_vm_size
    vnet_subnet_id          = try(var.vnet_subnet_id, null)
    pod_subnet_id           = try(var.pod_subnet_id, null)
    zones                   = var.system_node_pool_availability_zones
    node_labels             = var.system_node_pool_node_labels

    # TODO: The AKS API has removed support for tainting all nodes in the default node pool and it is no longer possible to configure this. To taint a node pool, create a separate one.
    # node_taints             = var.system_node_pool_node_taints

    enable_auto_scaling     = var.system_node_pool_enable_auto_scaling
    enable_host_encryption  = var.system_node_pool_enable_host_encryption
    enable_node_public_ip   = var.system_node_pool_enable_node_public_ip
    max_pods                = var.system_node_pool_max_pods
    max_count               = var.system_node_pool_max_count
    min_count               = var.system_node_pool_min_count
    node_count              = var.system_node_pool_node_count
    os_disk_type            = var.system_node_pool_os_disk_type
    tags                    = var.tags
    upgrade_settings {
      max_surge = "10%"  # defaul to "10%", so that there will not be change when reapply
    }

    # dynamic "upgrade_settings" {
    #   for_each = var.agents_pool_max_surge == null ? [] : ["upgrade_settings"]

    #   content {
    #     max_surge = null var.agents_pool_max_surge
    #   }
    # }    
  }
  dns_prefix                       = var.dns_prefix
  dns_prefix_private_cluster       = try(var.dns_prefix_private_cluster, null)
  # TODO: to be tested
  # aci_connector_linux {
  #   subnet_name = var aci_connector_linux.subnet_name
  # }
  automatic_channel_upgrade        = try(var.automatic_channel_upgrade, null) 
  # api_server_access_profile 
  # auto_scaler_profile 
  azure_active_directory_role_based_access_control {
    managed                    = true
    tenant_id                  = var.tenant_id
    admin_group_object_ids     = var.admin_group_object_ids
    azure_rbac_enabled         = var.azure_rbac_enabled
  }
  azure_policy_enabled             = var.azure_policy_enabled
  # confidential_computing
  # custom_ca_trust_certificates_base64
  # disk_encryption_set_id
  # edge_zone
  http_application_routing_enabled = var.http_application_routing_enabled
  # http_proxy_config 
  identity {
    type = "UserAssigned"
    identity_ids = var.identity.identity_ids # tolist([azurerm_user_assigned_identity.aks_identity.id])
  }
  image_cleaner_enabled            = var.image_cleaner_enabled
  # image_cleaner_interval_hours
  dynamic "ingress_application_gateway" {
    for_each = try(var.ingress_application_gateway.gateway_id, null) == null ? [] : [1]

    content {
      gateway_id                 = var.ingress_application_gateway.gateway_id
      subnet_cidr                = var.ingress_application_gateway.subnet_cidr
      subnet_id                  = var.ingress_application_gateway.subnet_id
    }
  } 
  # key_management_service
  # key_vault_secrets_provider
  # kubelet_identity
  kubernetes_version               = var.kubernetes_version
  # TODO: is this required?????
  # linux_profile {
  #   admin_username = var.admin_username
  #   ssh_key {
  #       key_data = var.ssh_public_key
  #   }
  # }
  # local_account_disabled
  # maintenance_window
  # maintenance_window_auto_upgrade
  # maintenance_window_node_os
  # microsoft_defender
  # monitor_metrics
  network_profile {
    network_plugin     = var.network_profile.network_plugin # azure
    # network_mode = var.network_profile.network_mode # [bridge and transparent] "Network mode bridge is not valid, the valid values are 'transparent' or ''. We are looking to deprecate network mode",
    network_policy = var.network_profile.network_policy # [calico, azure and cilium]
    dns_service_ip     = var.network_profile.dns_service_ip # 172.16.0.10

# docker_bridge_cidr
# ebpf_data_plane

    network_plugin_mode = try(var.network_profile.network_plugin_mode,null) # e.g. overlay   
    outbound_type      = var.network_profile.outbound_type # userDefinedRouting
    pod_cidr           = var.network_profile.pod_cidr # 172.31.0.0/18"
    service_cidr       = var.network_profile.service_cidr # 172.16.0.0/18
# ip_versions
    load_balancer_sku = var.network_profile.load_balancer_sku # [basic standard]
  }

  #   network_profile = {
  #   network_plugin     = "azure"
  #   # When network_plugin_mode is set to overlay, the network_plugin field can only be set to azure. When upgrading from Azure CNI without overlay, pod_subnet_id must be specified.
  #   network_plugin_mode = "overlay" 

  #   network_policy     = "azure"
  #   service_cidr       = "8.0.0.0/16" # to change 10 to 8 or 11
  #   dns_service_ip     = "8.0.0.10" # to change 10 to 8 or 11
  #   # azure cni overlay
  #   pod_cidr           = "8.244.0.0/16" # to change 10 to 8 or 11 
  #   # docker_bridge_cidr` has been deprecated as the API no longer supports it and will be removed in version 4.0 of the provider.
  #   # docker_bridge_cidr = "10.244.0.0/16" # to change 10 to 8 or 11 - why this value is not taking effect.

  #   # expected network_profile.0.load_balancer_sku to be one of [basic standard], got Standard
  #   load_balancer_sku = "standard" # "Standard"      
  # }
 
  # node_os_channel_upgrade
  node_resource_group              = var.node_resource_group # default to "aks-nodes"
  oidc_issuer_enabled              = var.oidc_issuer_enabled
  oms_agent {
    msi_auth_for_monitoring_enabled = true
    log_analytics_workspace_id      = coalesce(var.oms_agent.log_analytics_workspace_id, var.log_analytics_workspace_id)
  }
  open_service_mesh_enabled        = var.open_service_mesh_enabled
  private_cluster_enabled          = var.private_cluster_enabled
  private_dns_zone_id           = var.private_dns_zone_id
  private_cluster_public_fqdn_enabled = var.private_cluster_public_fqdn_enabled
  # service_mesh_profile
  workload_autoscaler_profile {
    keda_enabled                    = var.keda_enabled
    vertical_pod_autoscaler_enabled = var.vertical_pod_autoscaler_enabled
  }
  workload_identity_enabled        = var.workload_identity_enabled
  # public_network_access_enabled
  # role_based_access_control_enabled
  # run_command_enabled
  # service_principal
  sku_tier                         = var.sku_tier
  # storage_profile
  # support_plan
  tags                    = var.tags
  # web_app_routing
  # windows_profile

  lifecycle {
    ignore_changes = [
      kubernetes_version,
      tags
    ]
  }
}

resource "azurerm_monitor_diagnostic_setting" "settings" {
  name                       = "DiagnosticsSettings"
  target_resource_id         = azurerm_kubernetes_cluster.aks_cluster.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "kube-apiserver"

    retention_policy {
      enabled = true  
      # TODO: ERROR: Diagnostic settings does not support retention for new diagnostic settings.
      # days    = var.log_analytics_retention_days
    }
  }

  enabled_log {
    category = "kube-audit"

    retention_policy {
      enabled = true
      # days    = var.log_analytics_retention_days
    }
  }

  enabled_log {
    category = "kube-audit-admin"

    retention_policy {
      enabled = true
      # days    = var.log_analytics_retention_days
    }
  }

  enabled_log {
    category = "kube-controller-manager"

    retention_policy {
      enabled = true
      # days    = var.log_analytics_retention_days
    }
  }

  enabled_log {
    category = "kube-scheduler"

    retention_policy {
      enabled = true
      # days    = var.log_analytics_retention_days
    }
  }

  enabled_log {
    category = "cluster-autoscaler"

    retention_policy {
      enabled = true
      # days    = var.log_analytics_retention_days
    }
  }

  enabled_log {
    category = "guard"

    retention_policy {
      enabled = true
      # days    = var.log_analytics_retention_days
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
      # days    = var.log_analytics_retention_days
    }
  }
}