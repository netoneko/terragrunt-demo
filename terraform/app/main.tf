locals {
  elb_labels = yamlencode({
    "ingress" = {
      "annotations" = {
        "alb.ingress.kubernetes.io/subnets" = join(",", var.public_subnets)
      }
    }
  })

  templates = yamlencode({
    "templates" = var.templates
  })
}

resource "helm_release" "app" {
  name       = var.helm_release_name
  # repository = var.helm_repo_path
  chart      = "${var.helm_repo_path}/${var.helm_chart_name}"
  namespace  = var.namespace
  create_namespace = true
  force_update = true

  values = concat(
    [for f in var.values: file(f)],
    [local.elb_labels, local.templates],
  )  
}

data "kubernetes_ingress_v1" "app" {
  metadata {
    name = var.helm_release_name
    namespace = var.namespace
  }

  depends_on = [ helm_release.app ]
}
