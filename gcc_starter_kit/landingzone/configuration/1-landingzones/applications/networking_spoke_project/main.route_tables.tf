resource "azurerm_route_table" "this" {
  name                = module.naming.route_table.name_unique 
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_route" "this" {
  name                = "${module.naming.route_table.name}-route0" 
  resource_group_name = azurerm_resource_group.this.name
  route_table_name    = azurerm_route_table.this.name
  address_prefix      = "0.0.0.0/0" # all internet traffic
  next_hop_type       = "VirtualAppliance" # ["VirtualNetworkGateway" "VnetLocal" "Internet" "VirtualAppliance" "None"]
  next_hop_in_ip_address = "100.127.1.4" # var.firewall_private_ip  # firewall ip 
}

# resource "azurerm_subnet_route_table_association" "hub_gateway" {
#   count = lookup(module.virtual_subnet1.subnets, "AppSubnet", null) == null ? 0 : 1  

#   subnet_id      = module.virtual_subnet1.subnets["AppSubnet"].id
#   route_table_id = azurerm_route_table.this.id

#   depends_on = [azurerm_route_table.this]
# }