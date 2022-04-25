resource "kubernetes_service" "dev-service-three" {
  metadata {
    name = "dev-service-three"
    labels = {
      "run" = "dev-service-three"
    }
  }

  spec {
    selector = {
      run = "dev-service-three"
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "NodePort"
  }
}
