#-------------------------------------------------------------------------------
# ** IMPORTANT: DO NOT CHANGE
#-------------------------------------------------------------------------------
# Example usage
# vnet_id = local.remote.networking.virtual_networks.spoke_project.virtual_network.id  
# vnet_name = local.remote.networking.virtual_networks.spoke_project.virtual_network.name  
# subnet_id = local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["ServiceSubnet"].id 
# subnet_id = local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["WebSubnet"].id 
# subnet_id = local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["AppSubnet"].id 
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

# This allow use to randomize the name of resources
resource "random_string" "this" {
  length  = 3
  special = false
  upper   = false
}

data "azurerm_client_config" "current" {}

# local remote variables
locals {
  global_settings = module.landingzone.global_settings   
  remote =  module.landingzone.remote   
} 

# local variable structures
# # local remote variables
# locals {
#   global_settings = data.terraform_remote_state.gcci_platform.outputs.global_settings     
#   # virtual network name - from gcci-platform
#   # e.g. 
#   # local.remote.networking.virtual_networks.spoke_project.virtual_network.id 
#   # local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["ServiceSubnet"].id
#   remote = {
#     networking = {
#       virtual_networks = {
#         hub_internet_ingress = {
#           virtual_network = data.terraform_remote_state.gcci_platform.outputs.hub_internet_ingress
#           virtual_subnets = data.terraform_remote_state.hub_internet_virtual_subnets.outputs.virtual_subnets.ingress
#         }
#         hub_internet_egress  = {
#           virtual_network = data.terraform_remote_state.gcci_platform.outputs.hub_internet_egress
#           virtual_subnets = data.terraform_remote_state.hub_internet_virtual_subnets.outputs.virtual_subnets.egress
#         }
#         hub_intranet_ingress = {
#           virtual_network = data.terraform_remote_state.gcci_platform.outputs.hub_intranet_ingress
#           virtual_subnets = data.terraform_remote_state.hub_intranet_virtual_subnets.outputs.virtual_subnets.ingress
#         }
#         hub_intranet_egress = {
#           virtual_network = data.terraform_remote_state.gcci_platform.outputs.hub_intranet_egress
#           virtual_subnets = data.terraform_remote_state.hub_intranet_virtual_subnets.outputs.virtual_subnets.egress
#         }
#         spoke_project = {
#           virtual_network = data.terraform_remote_state.gcci_platform.outputs.spoke_project
#           virtual_subnets = data.terraform_remote_state.spoke_project_virtual_subnets.outputs.virtual_subnets
#         }
#         spoke_management = {
#           virtual_network = data.terraform_remote_state.gcci_platform.outputs.spoke_management
#           virtual_subnets = data.terraform_remote_state.spoke_management_virtual_subnets.outputs.virtual_subnets
#         }
#         spoke_devops  = {
#           virtual_network = data.terraform_remote_state.gcci_platform.outputs.spoke_devops
#           virtual_subnets = data.terraform_remote_state.spoke_devops_virtual_subnets.outputs.virtual_subnets
#         } 
#       }
#     }
#     log_analytics_workspace = {
#       name = data.terraform_remote_state.gcci_platform.outputs.gcci_agency_workspace.name
#       id = data.terraform_remote_state.gcci_platform.outputs.gcci_agency_workspace.id 
#     }
#     resource_group = data.terraform_remote_state.gcci_platform.outputs.gcci_platform
#   }
# } 