resource "kubernetes_service" "service-one" {
  metadata {
    name = "service-one"
    labels = {
      "run" = "service-one"
    }
  }

  spec {
    selector = {
      run = "service-one"
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "NodePort"
  }
}
