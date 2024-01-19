resource "aws_eks_cluster" "eks_cluster" {
  name     = "eks-cluster"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = var.eks_cluster_subnet_ids
  }

  provisioner "local-exec" {
    command = "chmod 777 ./eks/k8s-rbac.sh"
  }
  provisioner "local-exec" {
    command = "./eks/k8s-rbac.sh"
  }
}