name = "kirill-terragrunt-demo-vpc-1"
cidr = "10.0.0.0/16"

azs             = ["us-east-2a", "us-east-2b", "us-east-2c"]
public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

public_subnet_tags = {
    "kubernetes.io/cluster/kirill-terragrunt-demo-vpc-1" = "owned"
    "kubernetes.io/role/elb" = ""
    "kubernetes.io/role/alb-ingress" = ""
}
