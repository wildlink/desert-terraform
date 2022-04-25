locals {
  env = {
    default = {
      cluster        = "dev"
      db_uri         = "DEV_DB_URI_V4"
      db_replica_uri = "DEV_REPLICA_URI_V4"
      deployment     = "dev"
      host_prefix    = "dev."
      prefix         = "dev-"
      project        = "wildfire-cloud-project"
    }
    prod = {
      cluster        = "prod"
      db_uri         = "DB_URI"
      db_replica_uri = "REPLICA_URI"
      deployment     = "prod"
      host_prefix    = ""
      prefix         = ""
    }
  }

  environmentvars = contains(keys(local.env), terraform.workspace) ? terraform.workspace : "default"
  workspace       = merge(local.env["default"], local.env[local.environmentvars])
}
