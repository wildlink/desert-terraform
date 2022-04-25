resource "kubernetes_deployment" "app-six" {

  metadata {
    name = "app-six"
    labels = {
      run = "app-six"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        run = "app-six"
      }
    }
    template {
      metadata {
        annotations = {
        }
        labels = {
          run = "app-six"
        }
      }
      spec {
        automount_service_account_token = false
        enable_service_links            = false
        container {
          image   = "path.to.container.image:tag"
          name    = "app-six"
          args    = []
          command = []

          env {
            name = "VAR_1"
            value_from {
              secret_key_ref {
                key      = "VAR_1"
                name     = "secret-env"
                optional = false
              }
            }
          }

          env {
            name = "VAR_2"
            value_from {
              secret_key_ref {
                key      = "VAR_2"
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
      }
    }
  }
}
