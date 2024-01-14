resource "aws_launch_template" "eks_launch_template" {
  name          = "eks-launch-template"
  image_id      = var.eks_worker_node_ami
  instance_type = var.eks_worker_node_type
  # key_name      = aws_key_pair.key_worker_node.key_name
  user_data     = data.template_file.bootstrap_script.rendered

  network_interfaces {
    associate_public_ip_address = false
  }
}

data "template_file" "bootstrap_script" {
  template = file("./bootstrap.sh")
  vars = {
    EKS_CLUSTER_NAME          = aws_eks_cluster.eks_cluster.name
    EKS_ENDPOINT              = aws_eks_cluster.eks_cluster.endpoint
    EKS_CERTIFICATE_AUTHORITY = aws_eks_cluster.eks_cluster.certificate_authority[0].data
  }
}

resource "aws_eks_cluster" "eks_cluster" {
  name     = "eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [for subnet in aws_subnet.subnets_private_app : subnet.id]
  }

  depends_on = [
    aws_iam_role.eks_cluster_role
  ]
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "eks-node-group"
  node_role_arn   = aws_iam_role.eks_worker_node_role.arn
  subnet_ids      = [for subnet in aws_subnet.subnets_private_app : subnet.id]
  launch_template {
    id      = aws_launch_template.eks_launch_template.id
    version = aws_launch_template.eks_launch_template.latest_version
  }

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }

  depends_on = [
    aws_iam_role.eks_cluster_role
  ]
}

resource "aws_security_group" "sg_worker_node_bastion" {
  name        = "worker-node-bastion"
  description = "Allow inbound traffic from Bastion Host"
  vpc_id      = aws_vpc.vpc_app.id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "worker-node-bastion"
  }
}

# resource "aws_key_pair" "key_worker_node" {
#   key_name   = "workers-key"
#   public_key = file("./workers-key-mac.pub")
# }

#############################################
##  IAM ROLE FOR EKS CLUSTER
#############################################
data "aws_iam_policy_document" "eks_cluster_trust_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "AmazonEKSClusterPolicy" {
  name = "AmazonEKSClusterPolicy"
}

resource "aws_iam_role" "eks_cluster_role" {
  name               = "eks-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_trust_policy.json
  managed_policy_arns = [
    data.aws_iam_policy.AmazonEKSClusterPolicy.arn
  ]
}
#############################################


#############################################
##  IAM ROLE FOR EKS WORKER NODES
#############################################
data "aws_iam_policy_document" "eks_node_trust_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "AmazonEC2ContainerRegistryReadOnly" {
  name = "AmazonEC2ContainerRegistryReadOnly"
}
data "aws_iam_policy" "AmazonEKS_CNI_Policy" {
  name = "AmazonEKS_CNI_Policy"
}
data "aws_iam_policy" "AmazonEKSWorkerNodePolicy" {
  name = "AmazonEKSWorkerNodePolicy"
}
data "aws_iam_policy" "AmazonSSMManagedInstanceCore" {
  name = "AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role" "eks_worker_node_role" {
  name               = "eks-worker-node-role"
  assume_role_policy = data.aws_iam_policy_document.eks_node_trust_policy.json
  managed_policy_arns = [
    data.aws_iam_policy.AmazonEC2ContainerRegistryReadOnly.arn,
    data.aws_iam_policy.AmazonEKS_CNI_Policy.arn,
    data.aws_iam_policy.AmazonEKSWorkerNodePolicy.arn,
    data.aws_iam_policy.AmazonSSMManagedInstanceCore.arn
  ]
}
#############################################