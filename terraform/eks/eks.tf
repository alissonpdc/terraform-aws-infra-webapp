## Get AWS Account info
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Replace AWS values on rbac deploy script
data "template_file" "rbac_deploy" {
  template = file("./eks/files/k8s-rbac-deploy.sh")
  vars = {
    EKS_CLUSTER_NAME = var.eks_cluster_name
    EKS_REGION       = data.aws_region.current.name
  }
}
# Replace AWS values on rbac auth-map script
data "template_file" "rbac_auth_map" {
  count = length(var.eks_auth_map)

  template = file("./eks/files/k8s-rbac-auth-map.sh")
  vars = {
    EKS_CLUSTER_NAME  = var.eks_cluster_name
    EKS_REGION        = data.aws_region.current.name
    AWS_ROLE_ARN      = var.eks_auth_map[count.index].role
    EKS_RBAC_USERNAME = var.eks_auth_map[count.index].username
  }
}
# Create a command list to add ARN to auth-map
resource "terraform_data" "auth_map" {
  count = length(data.template_file.rbac_auth_map)

  provisioner "local-exec" {
    command = "cat <<EOF >>auth-map\n${data.template_file.rbac_auth_map[count.index].rendered}\nEOF"
  }
}

# Deploy an EKS cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.eks_role.arn
  version  = var.eks_master_version == "" ? null : var.eks_master_version

  vpc_config {
    subnet_ids = var.eks_cluster_subnet_ids
  }

  # Script to add RBAC permissions to additional AWS users/roles
  provisioner "local-exec" {
    command = "cat <<EOF >>tmp.sh\n${data.template_file.rbac_deploy.rendered}\nEOF"
  }
  provisioner "local-exec" {
    command = "cat auth-map >> tmp.sh && chmod +x tmp.sh && ./tmp.sh && rm -f auth-map tmp.sh"
  }

  depends_on = [ 
    data.template_file.rbac_auth_map,
    data.template_file.rbac_deploy,
    terraform_data.auth_map
   ]
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