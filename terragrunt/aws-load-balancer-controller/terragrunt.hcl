include "root" {
  path = find_in_parent_folders()
  expose = true
}

dependency "eks" {
  config_path = "../eks"
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "lb_role" {
  config_path = "../aws-load-balancer-controller-role"
}

include "helm" {
  path = find_in_parent_folders("helm.hcl")
}

terraform {
  source    = "../../terraform/aws-load-balancer-controller"
}

inputs = {
  remote_state_config = include.root.remote_state

  vpc_id = dependency.vpc.outputs.vpc_id
  cluster_name = dependency.eks.outputs.cluster_name
  iam_role_arn = dependency.lb_role.outputs.iam_role_arn
}
