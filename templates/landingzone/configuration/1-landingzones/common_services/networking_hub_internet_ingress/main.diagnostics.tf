# nsg diagnostics
module "diagnosticsetting1" {
  source  = "./../../../../../../modules/diagnostics/terraform-azurerm-mspsdi-avm-res-diagnostics-diagnosticsetting"

  name                = "${module.naming.monitor_diagnostic_setting.name_unique}-nsg"
  target_resource_id = module.nsg1.nsg_resource.id
  log_analytics_workspace_id = local.remote.log_analytics_workspace.id
  diagnostics = {
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["NetworkSecurityGroupEvent", true, false, 7],
        ["NetworkSecurityGroupRuleCounter", true, false, 7],
      ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        #["AllMetrics", true, false, 7],
      ]
    }
  }
}

# # public ip diagnostics
# module "diagnosticsetting2" {
#   source  = "./../../../../../../modules/diagnostics/terraform-azurerm-mspsdi-avm-res-diagnostics-diagnosticsetting"

#   name                = "${module.naming.monitor_diagnostic_setting.name_unique}-pip"
#   target_resource_id = module.public_ip.public_ip_id
#   log_analytics_workspace_id = local.remote.log_analytics_workspace.id
#   diagnostics = {
#     categories = {
#       log = [
#         # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
#         ["DDoSProtectionNotifications", true, false, 7],
#         ["DDoSMitigationFlowLogs", true, false, 7],
#         ["DDoSMitigationReports", true, false, 7],
#       ]
#       metric = [
#         #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
#         ["AllMetrics", true, false, 7],
#       ]
#     }
#   }
# }
