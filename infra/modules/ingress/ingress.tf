resource "helm_release" "ingress_nginx" {
  name         = "ingress-nginx"
  repository   = "https://kubernetes.github.io/ingress-nginx"
  chart        = "ingress-nginx"
  version      = "4.4.2"
  force_update = false

  create_namespace = true
  namespace        = "ingress-nginx"
  dynamic "set" {
    for_each = {
      "controller.service.targetPorts.http"                                                                       = "http"
      "controller.service.targetPorts.https"                                                                      = "https"
      "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-backend-protocol"        = "TCP"
      "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-ports"               = "TCP"
      "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-connection-idle-timeout" = "60"
      "controller.service.internal.enabled"                                                                       = "false"
      "controller.service.internal.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-internal"       = "false"
      "controller.service.type"                                                                                   = "LoadBalancer"
    }

    content {
      name  = set.key
      value = set.value
    }
  }
}
