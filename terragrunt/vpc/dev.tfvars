name = "kirill-terragrunt-demo-vpc"
cidr = "10.0.0.0/16"

azs             = ["us-east-2a", "us-east-2b", "us-east-2c"]
private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

enable_nat_gateway = true
map_public_ip_on_launch = true // unless enabled does not allow to create a node group in the public subnet

public_subnet_tags = {
    "kubernetes.io/cluster/kirill-terragrunt-demo-vpc" = "owned"
    "kubernetes.io/role/elb" = ""
    "kubernetes.io/role/alb-ingress" = ""
}