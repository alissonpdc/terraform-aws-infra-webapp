########################################
##           NETWORK OUTPUT           ##
########################################
output "vpc_id" {
  value = module.network.vpc_id
}
output "subnet_private_app_ids" {
  value = module.network.subnet_private_app_ids
}
output "subnet_private_db_ids" {
  value = module.network.subnet_private_db_ids
}
output "subnet_public_ids" {
  value = module.network.subnet_public_ids
}

########################################
##           EKS OUTPUT               ##
########################################
output "kubectl_update_context" {
  value = "aws eks update-kubeconfig --region ${var.aws_default_region} --name ${module.eks.eks_cluster_name}"
}
output "eks_cluster_name" {
  value = module.eks.eks_cluster_name
}
output "eks_cluster_endpoint" {
  value = module.eks.eks_cluster_endpoint
}
output "eks_cluster_certificate_authority" {
  value = module.eks.eks_cluster_certificate_authority
}
output "eks_security_group_id" {
  value = module.eks.eks_security_group_id
}
output "eks_version" {
  value = module.eks.eks_version
}
output "eks_worker_node_ami" {
  value = module.eks.eks_worker_node_ami
}

########################################
##               RDS OUPUT            ##
########################################
output "db_endpoint" {
  value = module.rds.db_endpoint
}
output "db_address" {
  value = module.rds.db_address
}
output "db_port" {
  value = module.rds.db_port
}
output "db_az" {
  value = module.rds.db_az
}
output "db_username" {
  value     = module.rds.db_username
  sensitive = true
}
output "db_name" {
  value     = module.rds.db_name
  sensitive = true
}