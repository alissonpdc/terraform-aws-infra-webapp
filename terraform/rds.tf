module "rds" {
  # count = var.enable_rds == true ? 1 : 0

  source = "./rds"

  db_username              = var.db_username
  db_name                  = var.db_name
  db_instance_type         = var.db_instance_type
  vpc_id                   = module.network.vpc_id
  worker_node_sec_group_id = module.eks.eks_security_group_id
  db_subnets_private_ids   = module.network.subnet_private_db_ids
}