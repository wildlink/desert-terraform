resource "kubernetes_ingress" "dev-ingress-one" {

  metadata {
    name = "dev-ingress-one"
    annotations = {
      "networking.gke.io/managed-certificates" : "dev-ingress-one"
    }
  }

  spec {
    rule {
      host = "dev.example.com"
      http {
        path {
          path = "/"
          backend {
            service_name = "dev-app-one"
            service_port = 80
          }
        }
      }
    }
  }
}
