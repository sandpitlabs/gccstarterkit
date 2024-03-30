provider "azurerm" {
  features {}

  subscription_id = data.azurerm_client_config.current.subscription_id
  tenant_id       = data.azurerm_client_config.current.tenant_id
  use_msi        = true
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
      resource_group_name  = "aoaidev-rg-launchpad" # DO NOT CHANGE - codegen 
      storage_account_name = "aoaidevstgtfstatewny" # DO NOT CHANGE - codegen 
      container_name       = "2-solution-accelerators" # DO NOT CHANGE - codegen
      key                  = "solution-accelerators-mssql.tfstate"
  }  
}
