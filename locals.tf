locals {
  deployment_base = jsondecode(file("tools/templates/deployment.json"))

  # Gather all the deployment definitions
  deployments_path    = "./deployments"
  deployments_patches = "./deployments/${local.workspace["deployment"]}"
  deployments_files = {
    for file in fileset(local.deployments_path, "*.json") :
    trimsuffix(file, ".json") => merge(jsondecode(file("${local.deployments_path}/${file}")), fileexists("${local.deployments_patches}/${file}") ? jsondecode(file("${local.deployments_patches}/${file}")) : null)
  }

  deployments = flatten([for deployment in local.deployments_files : [merge(local.deployment_base, deployment)]])

  # Pull the service definitions out of the deployments
  services = flatten([
    for deployment in local.deployments : [
      for service in deployment.services : merge({
        name = deployment.name
        run  = kubernetes_deployment.all[deployment.name].metadata.0.labels.run
      }, service)
    ]
  ])

  # Ingress definitions
  ingress_base = jsondecode(file("tools/templates/ingress.json"))

  # Gather all the deployment definitions
  ingresses_path    = "./ingresses"
  ingresses_patches = "./ingresses/${local.workspace["deployment"]}"
  ingresses_files = {
    for file in fileset(local.ingresses_path, "*.json") :
    trimsuffix(file, ".json") => merge(jsondecode(file("${local.ingresses_path}/${file}")), fileexists("${local.ingresses_patches}/${file}") ? jsondecode(file("${local.ingresses_patches}/${file}")) : null)
  }

  ingresses = flatten([for ingress in local.ingresses_files : [merge(local.ingress_base, ingress)]])

  # db environment
  db = {
    DB_DRIVER = {
      key      = "DB_DRIVER"
      key_name = "secret-env"
      optional = false
    },
    DB_URI = {
      key      = local.workspace["db_uri"]
      key_name = "secret-env"
      optional = false
    }
  }

  # db replica environment
  db_replica = {
    REPLICA_URI = {
      key      = local.workspace["db_replica_uri"]
      key_name = "secret-env"
      optional = false
    }
  }
}
