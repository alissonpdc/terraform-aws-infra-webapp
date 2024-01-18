output "kubectl_update_context" {
  value = "aws eks update-kubeconfig --region ${provider.aws.region} --name ${module.eks.eks_cluster_name}"
}