include "root" {
  path = find_in_parent_folders()
  expose = true
}

dependency "vpc" {
  config_path = "../vpc"
}

# terraform {
#   source = "tfr:///terraform-aws-modules/eks/aws?version=19.16.0"
# }

terraform {
  source    = "../../terraform/eks"
}

inputs = {
  remote_state_config = include.root.remote_state
  vpc_id = dependency.vpc.outputs.vpc_id
  subnet_ids = dependency.vpc.outputs.public_subnets // using only public subnets according to the doc
}
