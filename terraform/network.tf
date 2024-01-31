module "network" {
  source = "./network"

  enable_nat_gateway  = var.enable_nat_gateway
  enable_nat_instance = var.enable_nat_instance
  vpc_app_cidr        = var.vpc_app_cidr
  subnets_public      = var.subnets_public
  subnets_private_app = var.subnets_private_app
  subnets_private_db  = var.subnets_private_db
}