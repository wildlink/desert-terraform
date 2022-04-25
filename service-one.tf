resource "kubernetes_service" "service-one" {
  metadata {
    name = "${local.workspace["prefix"]}service-one"
    labels = {
      "run" = "${local.workspace["prefix"]}service-one"
    }
  }

  spec {
    selector = {
      run = "${local.workspace["prefix"]}service-one"
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "NodePort"
  }
}
