########################################
##       ENABLE TOGGLE FEATURES       ##
########################################
# enable_network            = true
enable_nat_gateway  = false
enable_nat_instance = true
# enable_eks                = true
enable_managed_nodes      = true
enable_self_managed_nodes = false
# enable_rds                = true


########################################
##           NETWORK VARIABLES        ##
########################################
aws_default_region = "us-east-1"


########################################
##             EKS VARIABLES          ##
########################################
eks_cluster_name   = "eks-cluster"
eks_master_version = "1.27"
# worker_node_type   = "t2.micro"
# worker_node_option = "ON_DEMAND"
worker_node_type   = "t3.small"
worker_node_option = "SPOT"
worker_node_capacity = {
  desired_size = 2
  max_size     = 2
  min_size     = 2
}
eks_auth_map = [
  {
    role     = "arn:aws:iam::211125453026:user/console",
    username = "admin"
  },
  {
    role     = "arn:aws:iam::211125453026:role/github-oidc-auth-Role-mVCfrIMPaYfi",
    username = "admin"
  }
]


########################################
##           RDS VARIABLES            ##
########################################
db_username = "usertodoapp"
db_name     = "dbtodoapp"