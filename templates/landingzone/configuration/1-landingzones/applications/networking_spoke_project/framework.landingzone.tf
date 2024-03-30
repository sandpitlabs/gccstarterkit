#-------------------------------------------------------------------------------
# ** IMPORTANT: DO NOT CHANGE
#-------------------------------------------------------------------------------
# Example usage
# vnet_id = local.remote.networking.virtual_networks.hub_internet.virtual_network.id  
# vnet_name = local.remote.networking.virtual_networks.hub_internet.virtual_network.name  
# vnet_id = local.remote.networking.virtual_networks.hub_intranet.virtual_network.id  
# vnet_name = local.remote.networking.virtual_networks.hub_intranet.virtual_network.name  
# vnet_id = local.remote.networking.virtual_networks.spoke_devops.virtual_network.id  
# vnet_name = local.remote.networking.virtual_networks.spoke_devops.virtual_network.name  
# vnet_id = local.remote.networking.virtual_networks.spoke_management.virtual_network.id  
# vnet_name = local.remote.networking.virtual_networks.spoke_management.virtual_network.name  
# vnet_id = local.remote.networking.virtual_networks.spoke_project.virtual_network.id  
# vnet_name = local.remote.networking.virtual_networks.spoke_project.virtual_network.name  
# log_analytics_workspace_id = local.remote.log_analytics_workspace.id 
# resource_group_name = local.remote.resource_group.name  
#-------------------------------------------------------------------------------
variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see https://aka.ms/avm/telemetryinfo.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
}

module "landingzone" {
  source="./../../../../../../modules/framework/terraform-azurerm-mspsdi-avm-res-framework-landingzone"

  resource_group_name  = "{{resource_group_name}}" # DO NOT CHANGE - codegen
  storage_account_name = "{{storage_account_name}}" # DO NOT CHANGE - codegen 
}

module "naming" {
  source  = "Azure/naming/azurerm"
  version = ">= 0.3.0"
  prefix                 = ["${local.global_settings.prefix}"] 
  unique-seed            = "random"
  unique-length          = 3
  unique-include-numbers = false  
}

data "azurerm_client_config" "current" {}

# This allow use to randomize the name of resources
resource "random_string" "this" {
  length  = 3
  special = false
  upper   = false
}

# local remote variables
locals {
  global_settings = module.landingzone.global_settings   
  remote =  module.landingzone.remote # remote virtual networks resources   
} 

# example usage
# local.remote.networking.virtual_networks.hub_internet_ingress.id 
# local.remote.networking.virtual_networks.hub_internet_ingress.name 
# local.remote.networking.virtual_networks.hub_internet_egress.id 
# local.remote.networking.virtual_networks.hub_internet_egress.name 

# example: local variables structure
# # local remote variables
# locals {
#   global_settings = data.terraform_remote_state.gcci_platform.outputs.global_settings   
#   # virtual network name - from gcci-platform
#   remote = {
#     networking = {
#       virtual_networks = {
#         hub_internet_ingress = data.terraform_remote_state.gcci_platform.outputs.hub_internet_ingress
#         hub_internet_egress = data.terraform_remote_state.gcci_platform.outputs.hub_internet_egress
#         hub_intranet_ingress = data.terraform_remote_state.gcci_platform.outputs.hub_intranet_ingress
#         hub_intranet_egress = data.terraform_remote_state.gcci_platform.outputs.hub_intranet_egress
#         spoke_project = data.terraform_remote_state.gcci_platform.outputs.spoke_project
#         spoke_management = data.terraform_remote_state.gcci_platform.outputs.spoke_management
#         spoke_devops = data.terraform_remote_state.gcci_platform.outputs.spoke_devops
#       }
#     }
#     log_analytics_workspace = {
#       name = data.terraform_remote_state.gcci_platform.outputs.gcci_agency_workspace.name
#       id = data.terraform_remote_state.gcci_platform.outputs.gcci_agency_workspace.id 
#     }
#     resource_group = data.terraform_remote_state.gcci_platform.outputs.gcci_platform
#   }
# } 
