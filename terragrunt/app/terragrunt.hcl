locals {
    env = get_env("TERRAGRUNT_ENV")
}

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
  templates = {
    for f in fileset(get_terragrunt_dir(), "${local.env}.*.html"): substr(f, length(local.env) + 1, -1) => file(f)
  }
}
