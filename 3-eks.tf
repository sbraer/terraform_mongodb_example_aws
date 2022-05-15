resource "aws_iam_role_policy_attachment" "nodes-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role" "demo" {
  name = "eks-cluster-${var.cluster_name}"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "eks.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role" "nodes" {
  name = "eks-node-group-nodes-${var.cluster_name}"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "demo-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.demo.name
}

resource "aws_eks_cluster" "demo" {
  name     = var.cluster_name
  role_arn = aws_iam_role.demo.arn
  version = var.cluster_version

  vpc_config {
    subnet_ids = module.vpc.private_subnets
  }

  depends_on = [aws_iam_role_policy_attachment.demo-AmazonEKSClusterPolicy]
}

data "aws_eks_cluster_auth" "demo" {
  name = var.cluster_name
}

resource "aws_eks_node_group" "mongodb-nodes" {
  cluster_name    = aws_eks_cluster.demo.name
  node_group_name = "mongodb-nodes"
  node_role_arn   = aws_iam_role.nodes.arn

  subnet_ids = module.vpc.private_subnets

  capacity_type  = "ON_DEMAND"
  instance_types = [var.worker_group_mongodb_instance_type]

  scaling_config {
    desired_size = var.worker_group_mongodb_desidered_size
    max_size     = var.worker_group_mongodb_desidered_size
    min_size     = var.worker_group_mongodb_desidered_size
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "mongodb"
    name = "mongodb"
  }

  tags = {
    name = "mongodb1"
  }

depends_on = [
    aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "aws_eks_node_group" "webapp-nodes" {
  cluster_name    = aws_eks_cluster.demo.name
  node_group_name = "webapp-nodes"
  node_role_arn   = aws_iam_role.nodes.arn

  subnet_ids = module.vpc.private_subnets

  capacity_type  = "ON_DEMAND"
  instance_types = [var.worker_group_webapp_instance_type]

  scaling_config {
    desired_size = var.worker_group_webapp_desidered_size
    max_size     = var.worker_group_webapp_desidered_size
    min_size     = var.worker_group_webapp_desidered_size
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "webapp"
    name = "webapp"
  }

  tags = {
    name = "webapp"
  }

  depends_on = [
    aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly,
  ]
}