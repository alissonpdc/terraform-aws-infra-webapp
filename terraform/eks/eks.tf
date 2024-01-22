## Get AWS Account info
data "aws_caller_identity" "current" {}

# Replace AWS values on rbac script
data "template_file" "rbac_script" {
  template = file("./eks/files/k8s-rbac.sh")
  vars = {
    AWS_ACCOUNT_ID       = data.aws_caller_identity.current.account_id,
    ROLE_IDENTITY_CENTER = var.role_sso_identity_center
  }
}

# Deploy an EKS cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = "eks-cluster"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = var.eks_cluster_subnet_ids
  }

  # Script to add RBAC permissions to additional AWS users/roles
  provisioner "local-exec" {
    command = "cat <<EOF >>./k8s-rbac.sh\n${data.template_file.rbac_script.rendered}\nEOF"
  }
  provisioner "local-exec" {
    command = "chmod 777 ./k8s-rbac.sh && ./k8s-rbac.sh"
  }
}

# Assume role trust policy
data "aws_iam_policy_document" "eks_role_trust_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

# Role for EKS cluster to assume
resource "aws_iam_role" "eks_role" {
  name               = "eks-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.eks_role_trust_policy.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  ]
}