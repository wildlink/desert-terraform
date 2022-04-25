resource "kubernetes_ingress" "ingress-one" {

  metadata {
    name = "${local.workspace["prefix"]}ingress-one"
    annotations = {
      "networking.gke.io/managed-certificates" : "${local.workspace["prefix"]}ingress-one"
    }
  }

  spec {
    rule {
      host = "${local.workspace["host_prefix"]}example.com"
      http {
        path {
          path = "/"
          backend {
            service_name = "${local.workspace["prefix"]}app-one"
            service_port = 80
          }
        }
      }
    }
  }
}
