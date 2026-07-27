locals {
  log_analytics_workspaces = { for k1, v1 in var.log_analytics_workspaces : k1 => { allow_resource_only_permissions = v1.allow_resource_only_permissions, cmk_for_query_forced = v1.cmk_for_query_forced, daily_quota_gb = v1.daily_quota_gb, data_collection_rule_id = v1.data_collection_rule_id, identity = v1.identity, immediate_data_purge_on_30_days_enabled = v1.immediate_data_purge_on_30_days_enabled, internet_ingestion_enabled = v1.internet_ingestion_enabled, internet_query_enabled = v1.internet_query_enabled, local_authentication_disabled = v1.local_authentication_disabled, local_authentication_enabled = v1.local_authentication_enabled, location = v1.location, name = v1.name, reservation_capacity_in_gb_per_day = v1.reservation_capacity_in_gb_per_day, resource_group_name = v1.resource_group_name, retention_in_days = v1.retention_in_days, sku = v1.sku, tags = v1.tags } }

  log_analytics_saved_searches = merge([
    for k1, v1 in var.log_analytics_workspaces : {
      for k2, v2 in coalesce(v1.log_analytics_saved_searches, {}) :
      "${k1}/${k2}" => merge(v2, {
        log_analytics_workspace_id = module.log_analytics_workspaces.log_analytics_workspaces_id["${k1}"]
      })
    }
  ]...)
}

module "log_analytics_workspaces" {
  source                   = "git::https://github.com/AeternaModules/azurerm_log_analytics_workspace.git?ref=v4.81.0"
  log_analytics_workspaces = local.log_analytics_workspaces
}

module "log_analytics_saved_searches" {
  source                       = "git::https://github.com/AeternaModules/azurerm_log_analytics_saved_search.git?ref=v4.81.0"
  log_analytics_saved_searches = local.log_analytics_saved_searches
  depends_on                   = [module.log_analytics_workspaces]
}

