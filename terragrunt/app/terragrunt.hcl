include "root" {
  path = find_in_parent_folders()
  expose = true
}

include "helm" {
  path = find_in_parent_folders("helm.hcl")
}

terraform {
  source    = "../../terraform/app"
}

inputs = {
  remote_state_config = include.root.remote_state
  helm_repo_path = find_in_parent_folders("helm")
}
