resource "kubernetes_ingress" "dev-ingress-four" {

  metadata {
    name = "dev-ingress-four"
    annotations = {
      "networking.gke.io/managed-certificates" : "dev-ingress-four"
    }
  }

  spec {
    rule {
      host = "dev.example4.com"
      http {
        path {
          path = "/"
          backend {
            service_name = "dev-app-four"
            service_port = 80
          }
        }
      }
    }
  }
}
