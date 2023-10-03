variable name {
  type = string
}

variable "cidr" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "map_public_ip_on_launch" {
  type = bool
  default = true // unless enabled does not allow to create a node group in the public subnet
}

variable "public_subnet_tags" {
  type = map(string)
  default = {}
}
