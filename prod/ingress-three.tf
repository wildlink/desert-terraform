resource "kubernetes_ingress" "ingress-three" {

  metadata {
    name = "ingress-three"
    annotations = {
      "networking.gke.io/managed-certificates" : "ingress-three"
    }
  }

  spec {
    rule {
      host = "example3.com"
      http {
        path {
          path = "/"
          backend {
            service_name = "app-three"
            service_port = 80
          }
        }

        path {
          path = "/test"
          backend {
            service_name = "app-two"
            service_port = 80
          }
        }

        path {
          path = "/test/eight"
          backend {
            service_name = "app-eight"
            service_port = 80
          }
        }
      }
    }
  }
}
