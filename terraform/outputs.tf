output "kubectl_update_context" {
  value = "aws eks update-kubeconfig --region ${var.aws_default_region} --name ${module.eks.eks_cluster_name}"
}