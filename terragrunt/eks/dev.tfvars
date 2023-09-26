cluster_name    = "kirill-terragrunt-demo"
cluster_version = "1.27"

cluster_endpoint_public_access  = true

cluster_addons = {
coredns = {
    most_recent = true
}
kube-proxy = {
    most_recent = true
}
vpc-cni = {
    most_recent = true
}
}

# EKS Managed Node Group(s)
eks_managed_node_group_defaults = {
    instance_types = ["m5.large"]
}

eks_managed_node_groups = {
    default = {
        min_size     = 1
        max_size     = 2
        desired_size = 1

        instance_types = ["m5.large"]
    }
}

# aws-auth configmap
manage_aws_auth_configmap = false

# aws_auth_roles = []

# aws_auth_users = [
#     {
#         userarn  = "arn:aws:iam::329082085800:user/Kiril"
#         username = "kirill"
#         groups   = ["system:masters"]
#     },
# ]

# aws_auth_accounts = [
#     "329082085800",
# ]
