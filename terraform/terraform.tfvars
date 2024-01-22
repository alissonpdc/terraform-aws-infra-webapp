########################################
##       ENABLE TOGGLE FEATURES       ##
########################################
# enable_network            = true
enable_nat_gateway        = true
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
worker_node_type   = "t3.small"
worker_node_option = "SPOT"
worker_node_capacity = {
  desired_size = 2
  max_size     = 2
  min_size     = 2
}
role_sso_identity_center = "AWSReservedSSO_AdministratorAccess_018645c6c1d0e0fc"


########################################
##           RDS VARIABLES            ##
########################################
db_username = "usertodoapp"
db_name     = "dbtodoapp"