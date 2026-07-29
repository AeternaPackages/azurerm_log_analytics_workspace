variable "log_analytics_workspaces" {
  description = <<EOT
Map of log_analytics_workspaces, attributes below
Required:
    - location
    - name
    - resource_group_name
Optional:
    - allow_resource_only_permissions
    - cmk_for_query_forced
    - daily_quota_gb
    - data_collection_rule_id
    - immediate_data_purge_on_30_days_enabled
    - internet_ingestion_access_type
    - internet_query_access_type
    - local_authentication_enabled
    - reservation_capacity_in_gb_per_day
    - retention_in_days
    - sku
    - tags
    - identity (block)
Nested log_analytics_saved_searches (azurerm_log_analytics_saved_search):
    Required:
        - category
        - display_name
        - name
        - query
    Optional:
        - function_alias
        - function_parameters
        - tags
EOT

  type = map(object({
    location                                = string
    name                                    = string
    resource_group_name                     = string
    allow_resource_only_permissions         = optional(bool)
    cmk_for_query_forced                    = optional(bool)
    daily_quota_gb                          = optional(number)
    data_collection_rule_id                 = optional(string)
    immediate_data_purge_on_30_days_enabled = optional(bool)
    internet_ingestion_access_type          = optional(string)
    internet_query_access_type              = optional(string)
    local_authentication_enabled            = optional(bool)
    reservation_capacity_in_gb_per_day      = optional(number)
    retention_in_days                       = optional(number)
    sku                                     = optional(string)
    tags                                    = optional(map(string))
    identity = optional(object({
      identity_ids = optional(set(string))
      type         = string
    }))
    log_analytics_saved_searches = optional(map(object({
      category            = string
      display_name        = string
      name                = string
      query               = string
      function_alias      = optional(string)
      function_parameters = optional(list(string))
      tags                = optional(map(string))
    })))
  }))

  validation {
    condition = alltrue(concat(
      [for kk in keys(var.log_analytics_workspaces) : !strcontains(kk, "/")],
      flatten([for k0, v0 in var.log_analytics_workspaces : [for kk in keys(coalesce(v0.log_analytics_saved_searches, {})) : !strcontains(kk, "/")]])
    ))
    error_message = "Map keys in this package must not contain '/': it is used internally as a nesting-key separator, so a key containing it can silently collide two different nested entries into one. Rename the offending key(s)."
  }
}
