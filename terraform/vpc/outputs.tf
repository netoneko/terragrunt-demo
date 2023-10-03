output "public_subnets" {
  value = [for k, v in aws_subnet.public: v.id]
}
