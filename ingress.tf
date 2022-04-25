resource "kubernetes_ingress" "all" {
  for_each = {
    for ingress in local.ingresses :
    ingress.id => ingress
  }

  metadata {
    name        = "${local.workspace["prefix"]}${each.value.name}"
    annotations = each.value.annotations
  }

  spec {
    dynamic "rule" {
      for_each = each.value.rules

      content {
        host = "${local.workspace["host_prefix"]}${rule.value.host}"
        http {
          dynamic "path" {
            for_each = rule.value.paths

            content {
              path = path.value.path == "" ? null : path.value.path
              backend {
                service_name = "${local.workspace["prefix"]}${path.value.serviceName}"
                service_port = path.value.servicePort
              }
            }
          }
        }
      }
    }

    dynamic "tls" {
      for_each = each.value.tlsSecrets

      content {
        hosts       = tls.value.hosts
        secret_name = tls.value.secretName
      }
    }
  }
}
