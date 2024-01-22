module "eks" {
  source = "./eks"

  enable_managed_nodes      = var.enable_managed_nodes
  enable_self_managed_nodes = var.enable_self_managed_nodes
  worker_node_ami           = var.worker_node_ami
  worker_node_type          = var.worker_node_type
  worker_node_capacity      = var.worker_node_capacity
  worker_node_option        = var.worker_node_option

  eks_cluster_subnet_ids = module.network.subnet_private_app_ids
  worker_node_subnet_ids = module.network.subnet_private_app_ids

  role_sso_identity_center = var.role_sso_identity_center
}