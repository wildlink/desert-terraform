resource "kubernetes_service" "all" {
  for_each = {
    for service in local.services :
    service.name => service
  }

  metadata {
    name = "${local.workspace["prefix"]}${each.value.name}"
    labels = {
      "run" = each.value.run
    }
  }

  spec {
    selector = {
      run = each.value.run
    }
    port {
      port        = each.value.port
      target_port = each.value.targetPort
    }
    type = each.value.type
  }
}
