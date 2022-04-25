resource "kubernetes_service" "dev-service-ten" {
  metadata {
    name = "dev-service-ten"
    labels = {
      "run" = "dev-service-ten"
    }
  }

  spec {
    selector = {
      run = "dev-service-ten"
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "NodePort"
  }
}
