locals {
  elb_labels = yamlencode({
    "service" = {
      "annotations" = {
        "labels.service.beta.kubernetes.io/aws-load-balancer-type" = "external"
        "labels.service.beta.kubernetes.io/aws-load-balancer-nlb-target-type" = "ip"
        "service.beta.kubernetes.io/aws-load-balancer-scheme" = "internet-facing"
        "service.beta.kubernetes.io/aws-load-balancer-subnets" = join(",", var.public_subnets)
      }
    }
  })
}

resource "helm_release" "app" {
  name       = var.helm_release_name
  # repository = var.helm_repo_path
  chart      = "${var.helm_repo_path}/${var.helm_chart_name}"
  namespace  = var.namespace
  create_namespace = true

  values = concat(
    [for f in var.values: file(f)],
    [local.elb_labels],
  )
}

