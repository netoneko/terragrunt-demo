locals {
    env = get_env("TERRAGRUNT_ENV")
}

remote_state {
  backend = "s3"
  config = {
    bucket = "kirill-terragrunt-demo-state"
    key    = "${local.env}/${path_relative_to_include()}/terraform.tfstate"
    region = "us-east-2"
    encrypt = true
    dynamodb_table = "kirill-terragrunt-demo-lock"
  }
}

generate "backend" {
    path = "backend.tf"
    if_exists = "overwrite_terragrunt"
    contents = <<-EOF
terraform {
  backend "s3" {}
}
EOF
}

generate "default_vars" {
    path = "default_vars.tf"
    if_exists = "overwrite_terragrunt"
    contents = <<-EOF
variable "region" {
  type = string
}
EOF
}

terraform {
  extra_arguments "conditional_vars" {
    commands = [
      "apply",
      "plan",
      "import",
      "push",
      "refresh"
    ]

    required_var_files = [
      "${get_parent_terragrunt_dir()}/${local.env}.tfvars",
      "${get_terragrunt_dir()}/${local.env}.tfvars",
    ]

    # optional_var_files = [
    #   "${get_parent_terragrunt_dir()}/${local.env}.tfvars",
    #   "${get_parent_terragrunt_dir()}/${local.env}.tfvars",
    #   "${get_terragrunt_dir()}/${local.env}.tfvars",
    #   "${get_terragrunt_dir()}/${get_env("TF_VAR_region", "us-east-1")}.tfvars"
    # ]
  }
}

# generate "backend" {
#   path      = "backend.tf"
#   if_exists = "overwrite_terragrunt"
#   contents = <<EOF
# terraform {
#   backend "s3" {
#     bucket         = 
#     key            = 
#     region         = "us-east-2"
#     encrypt        = true
#     dynamodb_table = "kirill-terragrunt-demo-lock"
#   }
# }

# variable "env" {
#     type = string
#     default = "${local.env}"
# }
# EOF
# }
