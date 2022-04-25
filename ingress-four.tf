resource "kubernetes_ingress" "ingress-four" {

  metadata {
    name = "${local.workspace["prefix"]}ingress-four"
    annotations = {
      "networking.gke.io/managed-certificates" : "${local.workspace["prefix"]}ingress-four"
    }
  }

  spec {
    rule {
      host = "${local.workspace["host_prefix"]}example4.com"
      http {
        path {
          path = "/"
          backend {
            service_name = "${local.workspace["prefix"]}app-four"
            service_port = 80
          }
        }
      }
    }
  }
}
