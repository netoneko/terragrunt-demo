resource "helm_release" "app" {
  name       = var.helm_release_name
  repository = "file://${var.helm_repo_path}"
  chart      = var.helm_chart_name  
  namespace  = var.namespace
  create_namespace = true

  values = [for f in var.values: file(f)]
}

