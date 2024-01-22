data "tls_certificate" "tls" {
  url = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

# Create EKS OIDC Provider as an IAM Trusted IdP
resource "aws_iam_openid_connect_provider" "oidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.tls.certificates[0].sha1_fingerprint]
  url             = data.tls_certificate.tls.url
}

# IAM Role trust policy to be assumed by EKS pods
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.oidc.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-node"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.oidc.arn]
      type        = "Federated"
    }
  }
}

# IAM Role to be assumes by EKS pods
resource "aws_iam_role" "role" {
  name               = "k8s-serviceaccount-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
  ]
  tags = {
    Name = "k8s-serviceaccount-role"
  }
}