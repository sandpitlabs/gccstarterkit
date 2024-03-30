module "natgateway" {
  source  = "Azure/avm-res-network-natgateway/azurerm"

  name                = module.naming.nat_gateway.name_unique
  enable_telemetry    = true
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

}

module "subnet_nat_gateway_association" {
  source  = "./../../../../../../modules/networking/terraform-azurerm-mspsdi-avm-res-network-subnetnatgatewayassociation"

  nat_gateway_id                = module.natgateway.resource.id
  subnet_ids          = {
      subnet_id1 = module.virtual_subnet1.subnets["AgwSubnet"].id
      subnet_id2 = module.virtual_subnet1.subnets["AzureFirewallSubnet"].id
    }  
}

module "public_ip" {
  source  = "Azure/avm-res-network-publicipaddress/azurerm"
  version = "0.1.0"
  # insert the 3 required variables here
  enable_telemetry    = var.enable_telemetry
  resource_group_name = azurerm_resource_group.this.name
  name                = module.naming.public_ip.name_unique
  location            = azurerm_resource_group.this.location 
  sku = "Standard"
}

resource "azurerm_nat_gateway_public_ip_association" "nat_gategay_public_ip_association" {
  nat_gateway_id       = module.natgateway.resource.id
  public_ip_address_id = module.public_ip.public_ip_id
}

