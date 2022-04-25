resource "kubernetes_deployment" "app-three" {

  metadata {
    name = "${local.workspace["prefix"]}app-three"
    labels = {
      run = "${local.workspace["prefix"]}app-three"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        run = "${local.workspace["prefix"]}app-three"
      }
    }
    template {
      metadata {
        annotations = {
        }
        labels = {
          run = "${local.workspace["prefix"]}app-three"
        }
      }
      spec {
        automount_service_account_token = false
        enable_service_links            = false
        container {
          image   = "path.to.container.${local.workspace["prefix"]}image:tag"
          name    = "${local.workspace["prefix"]}app-three"
          args    = []
          command = []

          env {
            name = "DB_URI"
            value_from {
              secret_key_ref {
                key      = local.workspace["db_uri"]
                name     = "secret-env"
                optional = false
              }
            }
          }

          env {
            name = "REPLICA_URI"
            value_from {
              secret_key_ref {
                key      = local.workspace["db_replica_uri"]
                name     = "secret-env"
                optional = false
              }
            }
          }

          env {
            name = "VAR_3"
            value_from {
              secret_key_ref {
                key      = "VAR_3"
                name     = "secret-env"
                optional = false
              }
            }
          }

          env {
            name = "VAR_4"
            value_from {
              secret_key_ref {
                key      = "VAR_4"
                name     = "secret-env"
                optional = false
              }
            }
          }

          port {
            container_port = 80
            protocol       = "TCP"
          }

          readiness_probe {
            failure_threshold     = 3
            initial_delay_seconds = 10
            period_seconds        = 10
            success_threshold     = 1
            timeout_seconds       = 1
            http_get {
              path   = "/"
              port   = 80
              scheme = "HTTP"
            }
          }

          resources {
            requests = {
              "cpu"    = "100m"
              "memory" = "100M"
            }
            limits = {
              "cpu"    = "500m"
              "memory" = "300M"
            }
          }

          volume_mount {
            mount_path = "/mount/path"
            name       = "volume-1"
            read_only  = true
          }

          volume_mount {
            mount_path = "/mount/path2"
            name       = "volume-2"
            read_only  = true
          }
        }

        container {
          name    = "sidecar1"
          command = []
          image   = "sidecar.${local.workspace["prefix"]}image:tag"

          env {
            name = "SIDECAR_VAR_1"
            value_from {
              secret_key_ref {
                key      = "SIDECAR_VAR_1"
                name     = "secret-env"
                optional = false
              }
            }
          }

          env {
            name = "SIDECAR_VAR_2"
            value_from {
              secret_key_ref {
                key      = "SIDECAR_VAR_2"
                name     = "secret-env"
                optional = false
              }
            }
          }

          env {
            name = "SIDECAR_VAR_3"
            value_from {
              secret_key_ref {
                key      = "SIDECAR_VAR_3"
                name     = "secret-env"
                optional = false
              }
            }
          }

          volume_mount {
            mount_path = "/sidecar/mount/path"
            name       = "sidecar-volume"
            read_only  = true
          }
        }

        volume {
          name = "volume-1"
          secret {
            default_mode = "0644"
            optional     = false
            secret_name  = "secret-volume-1"
          }
        }

        volume {
          name = "volume-2"
          secret {
            default_mode = "0644"
            optional     = false
            secret_name  = "secret-volume-1"
          }
        }

        volume {
          name = "sidecar-volume"
          secret {
            default_mode = "0644"
            optional     = false
            secret_name  = "secret-volume-3"
          }
        }
      }
    }
  }
}
