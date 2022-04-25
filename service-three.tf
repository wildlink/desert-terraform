resource "kubernetes_service" "service-three" {
  metadata {
    name = "service-three"
    labels = {
      "run" = "service-three"
    }
  }

  spec {
    selector = {
      run = "service-three"
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "NodePort"
  }
}
