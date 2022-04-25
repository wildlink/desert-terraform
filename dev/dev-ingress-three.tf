resource "kubernetes_ingress" "dev-ingress-three" {

  metadata {
    name = "dev-ingress-three"
    annotations = {
      "networking.gke.io/managed-certificates" : "dev-ingress-three"
    }
  }

  spec {
    rule {
      host = "dev.example3.com"
      http {
        path {
          path = "/"
          backend {
            service_name = "dev-app-three"
            service_port = 80
          }
        }

        path {
          path = "/test"
          backend {
            service_name = "dev-app-two"
            service_port = 80
          }
        }

        path {
          path = "/test/eight"
          backend {
            service_name = "dev-app-eight"
            service_port = 80
          }
        }
      }
    }
  }
}
