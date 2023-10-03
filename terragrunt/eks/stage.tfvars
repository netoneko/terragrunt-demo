cluster_name    = "kirill-terragrunt-demo-1"
cluster_version = "1.27"

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

eks_managed_node_groups = {
    default = {
        min_size     = 1
        max_size     = 2
        desired_size = 1

        instance_types = ["m5.large"]
    }
}

