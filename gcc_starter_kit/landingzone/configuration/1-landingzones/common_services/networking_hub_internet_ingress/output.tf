output "virtual_subnets" {
  value       = module.virtual_subnet1
  # {
  #   ingress = module.virtual_subnet1 # azurerm_virtual_network.vnet
  #   # egress = module.virtual_subnet2 # azurerm_virtual_network.vnet
  # }
  description = "The Azure Virtual Subnets resource"
}

output "global_settings" {
  value       = local.global_settings
  description = "The framework global_settings"
}
