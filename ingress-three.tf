resource "kubernetes_ingress" "ingress-three" {

  metadata {
    name = "${local.workspace["prefix"]}ingress-three"
    annotations = {
      "networking.gke.io/managed-certificates" : "${local.workspace["prefix"]}ingress-three"
    }
  }

  spec {
    rule {
      host = "${local.workspace["host_prefix"]}example3.com"
      http {
        path {
          path = "/"
          backend {
            service_name = "${local.workspace["prefix"]}app-three"
            service_port = 80
          }
        }

        path {
          path = "/test"
          backend {
            service_name = "${local.workspace["prefix"]}app-two"
            service_port = 80
          }
        }

        path {
          path = "/test/eight"
          backend {
            service_name = "${local.workspace["prefix"]}app-eight"
            service_port = 80
          }
        }
      }
    }
  }
}
