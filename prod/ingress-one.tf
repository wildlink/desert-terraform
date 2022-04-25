resource "kubernetes_ingress" "ingress-one" {

  metadata {
    name = "ingress-one"
    annotations = {
      "networking.gke.io/managed-certificates" : "ingress-one"
    }
  }

  spec {
    rule {
      host = "example.com"
      http {
        path {
          path = "/"
          backend {
            service_name = "app-one"
            service_port = 80
          }
        }
      }
    }
  }
}
