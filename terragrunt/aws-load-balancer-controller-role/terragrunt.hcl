include "root" {
  path = find_in_parent_folders()
  expose = true
}

dependency "eks" {
  config_path = "../eks"
}

terraform {
  source    = "tfr:///terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks?version=5.30.0"
}

inputs = {
  remote_state_config = include.root.remote_state
  role_name = "${dependency.eks.outputs.cluster_name}EKSLoadBalancerRole"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn               = dependency.eks.outputs.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}
