output "endpoint" {
  value = data.kubernetes_ingress_v1.app.status.0.load_balancer.0.ingress.0.hostname
}
