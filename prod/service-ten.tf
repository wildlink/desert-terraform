resource "kubernetes_service" "service-ten" {
  metadata {
    name = "service-ten"
    labels = {
      "run" = "service-ten"
    }
  }

  spec {
    selector = {
      run = "service-ten"
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "NodePort"
  }
}
