variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type = string
  default = "1.27"
}

variable "cluster_endpoint_public_access" {
  type = bool
  default = true
}

variable "cluster_addons" {
  type = map(map(any))
}

variable "eks_managed_node_groups" {
  type = map
  default = {}
}

variable "subnet_ids" {
  type = list(string)
}