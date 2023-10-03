include "root" {
  path = find_in_parent_folders()
  expose = true
}

# terraform {
#   source = "tfr:///terraform-aws-modules/vpc/aws?version=5.1.2"
# }

terraform {
  source    = "../../terraform/vpc"
}

inputs = {
  remote_state_config = include.root.remote_state
}
