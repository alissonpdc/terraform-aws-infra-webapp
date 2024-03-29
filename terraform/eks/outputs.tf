output "eks_cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "eks_cluster_id" {
  value = aws_eks_cluster.eks_cluster.id
}

output "eks_cluster_certificate_authority" {
  value = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}

output "eks_security_group_id" {
  value = aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id
}

output "eks_version" {
  value = aws_eks_cluster.eks_cluster.platform_version
}

output "eks_worker_node_ami" {
  value = {
    ami_id   = data.aws_ami.ami_ubuntu_eks.image_id,
    ami_name = data.aws_ami.ami_ubuntu_eks.name
  }
}