rovider "azurerm" {
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
      resource_group_name  = "aoaidev-rg-launchpad" # DO NOT CHANGE - codegen 
      storage_account_name = "aoaidevstgtfstatewny" # DO NOT CHANGE - codegen 
      container_name       = "2-solution-accelerators" # DO NOT CHANGE - codegen
      key                  = "solution-accelerators-firewall-ingress-internet.tfstate" 
  }  
}
