# Search for Ubuntu for EKS AMI ID (based on variable eks_version)
data "aws_ami" "ami_ubuntu_eks" {
  most_recent = true
  name_regex  = "ubuntu-eks/k8s_"
  owners      = ["aws-marketplace"]

  filter {
    name   = "name"
    values = ["*${var.eks_master_version}*"]
  }

  filter {
    name   = "architecture"
    values = ["*x86_64*"]
  }
}

# Create launch template for worker nodes
resource "aws_launch_template" "worker_node_launch_template" {
  count = (var.enable_managed_nodes == true || var.enable_self_managed_nodes == true) ? 1 : 0

  name          = "eks-launch-template"
  image_id      = data.aws_ami.ami_ubuntu_eks.image_id
  instance_type = var.worker_node_type
  user_data     = base64encode(data.template_file.bootstrap_script.rendered)

  network_interfaces {
    associate_public_ip_address = false
  }
}

# Replace EKS values on user-data bootstrap
data "template_file" "bootstrap_script" {
  template = file("./eks/files/bootstrap.sh")
  vars = {
    EKS_CLUSTER_NAME          = aws_eks_cluster.eks_cluster.name
    EKS_ENDPOINT              = aws_eks_cluster.eks_cluster.endpoint
    EKS_CERTIFICATE_AUTHORITY = aws_eks_cluster.eks_cluster.certificate_authority[0].data
  }
}

# Create EKS Managed Node Group based on launch template
resource "aws_eks_node_group" "eks_node_group" {
  count = var.enable_managed_nodes == true ? 1 : 0

  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "eks-node-group"
  node_role_arn   = aws_iam_role.worker_node_role[count.index].arn
  subnet_ids      = var.worker_node_subnet_ids
  capacity_type   = var.worker_node_option

  launch_template {
    id      = aws_launch_template.worker_node_launch_template[count.index].id
    version = aws_launch_template.worker_node_launch_template[count.index].latest_version
  }

  scaling_config {
    desired_size = var.worker_node_capacity.desired_size
    max_size     = var.worker_node_capacity.max_size
    min_size     = var.worker_node_capacity.min_size
  }

  timeouts {
    create = "15m"
  }
}

# Worker node Role trust policy
data "aws_iam_policy_document" "worker_node_trust_policy" {
  count = (var.enable_managed_nodes == true || var.enable_self_managed_nodes == true) ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# IAM Role for Worker Nodes to assume
resource "aws_iam_role" "worker_node_role" {
  count = (var.enable_managed_nodes == true || var.enable_self_managed_nodes == true) ? 1 : 0

  name               = "eks-worker-node-role"
  assume_role_policy = data.aws_iam_policy_document.worker_node_trust_policy[count.index].json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
}