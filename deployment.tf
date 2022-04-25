resource "kubernetes_deployment" "all" {
  for_each = {
    for deployment in local.deployments :
    deployment.name => deployment
  }

  metadata {
    name = "${local.workspace["prefix"]}${each.value.name}"
    labels = {
      run = "${local.workspace["prefix"]}${each.value.name}"
    }
  }

  # Needed to keep from redeploying every time the resource_version changes
  lifecycle {
    ignore_changes = [metadata[0].resource_version]
  }

  spec {
    replicas = each.value.replicas
    selector {
      match_labels = {
        run = "${local.workspace["prefix"]}${each.value.name}"
      }
    }
    template {
      metadata {
        annotations = {
        }
        labels = {
          run = "${local.workspace["prefix"]}${each.value.name}"
        }
      }
      spec {
        automount_service_account_token = false
        enable_service_links            = false
        container {
          image   = each.value.image
          name    = "${local.workspace["prefix"]}${each.value.name}"
          args    = []
          command = []

          env {
            name = "FLAVOR"
            value_from {
              secret_key_ref {
                key      = "FLAVOR"
                name     = "db-env"
                optional = false
              }
            }
          }

          # Optionally include db references
          dynamic "env" {
            for_each = each.value.db ? local.db : {}
            content {
              name = env.key
              value_from {
                secret_key_ref {
                  key      = env.value.key
                  name     = env.value.key_name
                  optional = env.value.optional
                }
              }
            }
          }

          # Optionally include db replica references
          dynamic "env" {
            for_each = each.value.dbReplica ? local.db_replica : {}
            content {
              name = env.key
              value_from {
                secret_key_ref {
                  key      = env.value.key
                  name     = env.value.key_name
                  optional = env.value.optional
                }
              }
            }
          }

          # Include dynamic blocks for any additional non-standard customization a deployment
          # needs to do.
          dynamic "env" {
            for_each = each.value.extraEnv
            content {
              name  = env.value.name
              value = env.value.value
            }
          }

          dynamic "env" {
            for_each = each.value.extraSecretEnv
            content {
              name = env.value.name
              value_from {
                secret_key_ref {
                  key      = env.value.key
                  name     = env.value.key_name
                  optional = env.value.optional
                }
              }
            }
          }

          dynamic "port" {
            for_each = each.value.ports
            content {
              container_port = port.value.container_port
              protocol       = port.value.protocol
            }
          }

          dynamic "readiness_probe" {
            for_each = each.value.readinessProbes

            content {
              failure_threshold     = readiness_probe.value.failure_threshold
              initial_delay_seconds = readiness_probe.value.initial_delay_seconds
              period_seconds        = readiness_probe.value.period_seconds
              success_threshold     = readiness_probe.value.success_threshold
              timeout_seconds       = readiness_probe.value.timeout_seconds
              http_get {
                path   = readiness_probe.value.http_path
                port   = readiness_probe.value.http_port
                scheme = readiness_probe.value.http_scheme
              }
            }
          }

          dynamic "resources" {
            for_each = each.value.resources

            content {
              requests = {
                "cpu"    = resources.value.cpu_request
                "memory" = resources.value.memory_request
              }
              limits = {
                "cpu"    = resources.value.cpu_limit
                "memory" = resources.value.memory_limit
              }
            }
          }

          dynamic "volume_mount" {
            for_each = each.value.volumeMounts
            content {
              mount_path = volume_mount.value.mount_path
              name       = volume_mount.value.name
              read_only  = volume_mount.value.read_only
            }
          }
        }

        dynamic "container" {
          for_each = each.value.sidecars

          content {
            name    = container.value.name
            command = container.value.command
            image   = container.value.image

            dynamic "env" {
              for_each = container.value.secretEnv
              content {
                name = env.value.name
                value_from {
                  secret_key_ref {
                    key      = env.value.key
                    name     = env.value.key_name
                    optional = env.value.optional
                  }
                }
              }
            }

            dynamic "volume_mount" {
              for_each = container.value.volumeMounts
              content {
                mount_path = volume_mount.value.mount_path
                name       = volume_mount.value.name
                read_only  = volume_mount.value.read_only
              }
            }
          }
        }

        dynamic "volume" {
          for_each = each.value.volumes

          content {
            name = volume.value.name
            secret {
              default_mode = volume.value.default_mode
              optional     = false
              secret_name  = volume.value.secret_name
            }
          }
        }
      }
    }
  }
}
