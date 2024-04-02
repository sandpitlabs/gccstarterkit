# TODO
module "firewall_policy" {
  source              = "Azure/avm-res-network-firewallpolicy/azurerm"

  enable_telemetry    = var.enable_telemetry
  name                = module.naming.firewall_policy.name_unique
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  firewall_policy_sku = "Premium" # "Basic" # both firewall and firewall policy must in same tier
}


resource "azurerm_firewall_nat_rule_collection" "natcollection" {

  name                = module.naming.firewall_nat_rule_collection.name_unique
  azure_firewall_name = module.firewall.firewall_resource.name # var.azure_firewall_name
  resource_group_name = azurerm_resource_group.this.name # var.resource_group_name
  # priority            = "100" # var.azurerm_firewall_nat_rule_collection_definition[each.key].priority
  # action              = var.azurerm_firewall_nat_rule_collection_definition[each.key].action

  priority            = 100
  action              = "Dnat"
  rule {
    name = "ingress_rule"
    source_addresses = [
      "0.0.0.0/0",
    ]
    destination_ports = [
      "443",
    ]
    destination_addresses = [
      module.public_ip_firewall1.public_ip_id # azurerm_public_ip.example.ip_address # firewall public ip
    ]
    translated_port = 53
    translated_address = 100.127.0.74 # agw private ip [subnet ip + 10]
    protocols = [
      "TCP",
    ]
  }

  # dynamic "rule" {
  #   for_each = var.azurerm_firewall_nat_rule_collection_definition[each.key].ruleset
  #   content {
  #     name             = rule.value.name
  #     description      = try(rule.value.description, null)
  #     source_addresses = try(rule.value.source_addresses, null)
  #     source_ip_groups = try(rule.value.source_ip_groups, try(flatten([
  #       for key, value in var.ip_groups : value.id
  #       if contains(rule.value.source_ip_groups_keys, key)
  #       ]), null)
  #     )
  #     destination_ports = rule.value.destination_ports
  #     destination_addresses = try(rule.value.destination_addresses, try(flatten([
  #       for key, value in var.public_ip_addresses : value.ip_address
  #       if contains(rule.value.destination_addresses_public_ips_keys, key)
  #       ]), null)
  #     )
  #     translated_port    = rule.value.translated_port
  #     translated_address = rule.value.translated_address
  #     protocols          = rule.value.protocols
  #   }
  # }
}
