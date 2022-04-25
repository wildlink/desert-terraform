resource "kubernetes_service" "dev-service-one" {
  metadata {
    name = "dev-service-one"
    labels = {
      "run" = "dev-service-one"
    }
  }

  spec {
    selector = {
      run = "dev-service-one"
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "NodePort"
  }
}
