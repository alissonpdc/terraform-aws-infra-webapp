module "eks" {
  source = "./eks"

  enable_managed_nodes      = var.enable_managed_nodes
  enable_self_managed_nodes = var.enable_self_managed_nodes

  eks_cluster_name     = var.eks_cluster_name
  eks_master_version   = var.eks_master_version
  eks_auth_map         = var.eks_auth_map
  worker_node_type     = var.worker_node_type
  worker_node_capacity = var.worker_node_capacity
  worker_node_option   = var.worker_node_option

  eks_cluster_subnet_ids = module.network.subnet_private_app_ids
  worker_node_subnet_ids = module.network.subnet_private_app_ids
}