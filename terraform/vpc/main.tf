resource "aws_vpc" "main" {
  cidr_block       = var.cidr
  instance_tenancy = "default"

  tags = var.tags
}


resource "aws_subnet" "public" {
  for_each = toset(var.azs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnets[index(var.azs, each.value)]
  availability_zone = each.key

  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(var.tags, var.public_subnet_tags)
}


resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main.id

  tags = var.tags
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = var.tags
}

resource "aws_route_table_association" "public" {
  for_each = toset(var.azs)
  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id
}


resource "aws_network_acl" "public" {
  vpc_id = aws_vpc.main.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  egress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  egress {
    protocol   = "tcp"
    rule_no    = 140
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535

  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 140
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  tags = var.tags
}

resource "aws_network_acl_association" "public" {
  for_each = toset(var.azs)
  network_acl_id = aws_network_acl.public.id
  subnet_id      = aws_subnet.public[each.key].id
}
