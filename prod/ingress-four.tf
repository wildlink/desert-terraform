resource "kubernetes_ingress" "ingress-four" {

  metadata {
    name = "ingress-four"
    annotations = {
      "networking.gke.io/managed-certificates" : "ingress-four"
    }
  }

  spec {
    rule {
      host = "example4.com"
      http {
        path {
          path = "/"
          backend {
            service_name = "app-four"
            service_port = 80
          }
        }
      }
    }
  }
}
