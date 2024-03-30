# since these variables are re-used - a locals block makes this more maintainable
locals {
  backend_address_pool_name      = "default-example-beap"
  frontend_port_name             = "default-example-feport"
  frontend_ip_configuration_name = "default-example-feip"
  http_setting_name              = "default-example-be-htst"
  listener_name                  = "default-example-httplstn"
  request_routing_rule_name      = "default-example-rqrt"
  redirect_configuration_name    = "default-example-rdrcfg"
}

module "public_ip" {
  source  = "Azure/avm-res-network-publicipaddress/azurerm"
  version = "0.1.0"

  enable_telemetry    = var.enable_telemetry
  resource_group_name = azurerm_resource_group.this.name
  name                = module.naming.public_ip.name_unique
  location            = azurerm_resource_group.this.location 
  sku = "Standard"
}

module "application_gateway" {
  source = "./../../../../../../modules/networking/terraform-azurerm-mspsdi-avm-res-network-applicationgateway"

  name                         = "${module.naming.application_gateway.name}${random_string.this.result}" 
  resource_group_name          = azurerm_resource_group.this.name
  location                     = azurerm_resource_group.this.location
  tags = { 
    purpose = "hub internet reverse proxy" 
    project_code = local.global_settings.prefix 
    env = local.global_settings.environment 
    zone = "hub internet"
    tier = "na"          
  }  
  sku = {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }
  gateway_ip_configuration  = {
    name      = "agw-gateway-ip-configuration"
    subnet_id = local.remote.networking.virtual_networks.hub_internet_ingress.virtual_subnets.subnets["AgwSubnet"].id 
  }
  frontend_port  = {
    name = local.frontend_port_name
    port = 80
  }
  frontend_ip_configuration  = {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = module.public_ip.public_ip_id 
  }
  backend_address_pool  = {
    name = local.backend_address_pool_name
  }
  backend_http_settings  = {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/path1/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }
  http_listener  = {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }
  request_routing_rule  = {
    name                       = local.request_routing_rule_name
    priority                   = 9
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }    
}