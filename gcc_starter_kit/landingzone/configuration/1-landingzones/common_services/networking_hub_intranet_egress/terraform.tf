provider "azurerm" {
  features {}
}

# Configure Terraform backend
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.7.0, < 4.0.0"
    }
  }
  backend "azurerm" {
      resource_group_name  = "aoaidev-rg-launchpad" # DO NOT CHANGE - codegen - aoaidev-rg-launchpad "aoaidev-rg-launchpad"
      storage_account_name = "aoaidevstgtfstatewny" # DO NOT CHANGE - codegen - aoaidevstgtfstatewny "aoaidevstgtfstatewny"
      container_name       = "1-landingzones" # DO NOT CHANGE - codegen
      key                  = "network-hub-intranet-egress.tfstate" # TODO
  }  
}
