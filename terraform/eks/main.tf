resource "aws_eks_cluster" "cluster" {
  name     = var.cluster_name
  version  = var.cluster_version
  role_arn = aws_iam_role.cluster.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
  ]
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "cluster" {
  name               = "${var.cluster_name}EKSClusterRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_eks_addon" "addons" {
  for_each = var.cluster_addons
  cluster_name = aws_eks_cluster.cluster.name
  addon_name   = each.key
}

resource "aws_eks_node_group" "node_group" {
  for_each = var.eks_managed_node_groups

  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = each.key
  node_role_arn   = aws_iam_role.node_group.arn
  subnet_ids      = try(each.value.subnet_ids, var.subnet_ids)
  instance_types  = try(each.value.instance_types, ["t3.medium"])

  scaling_config {
    desired_size = try(each.value.desired_size, 1)
    max_size     = try(each.value.max_size, 1)
    min_size     = try(each.value.min_size, 1)
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "aws_iam_role" "node_group" {
  name =  "${var.cluster_name}EKSNodeGroupRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_group.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node_group.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node_group.name
}

resource "null_resource" "kubectl" {
  provisioner "local-exec" {
    command = "aws eks --region ${var.region} update-kubeconfig --name ${var.cluster_name}"
  }

  depends_on = [aws_eks_cluster.cluster]
}
