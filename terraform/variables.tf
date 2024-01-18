# variable "enable_multi_az" {
#   description = "Boolean flag to enable Multi-AZ deployment"
#   type        = bool
#   default     = false
# }
# variable "enable_nat_gateway" {
#   description = "Boolean flag to enable Nat Gateway deployment"
#   type        = bool
#   default     = false
# }
# variable "enable_eks" {
#   description = "Boolean flag to enable EKS deployment"
#   type        = bool
#   default     = false
# }
# variable "enable_bastion_host" {
#   description = "Boolean flag to enable Bastion Host deployment"
#   type        = bool
#   default     = false
# }
# variable "enable_network" {
#   description = "Boolean flag to enable Network deployment"
#   type        = bool
#   default     = false
# }
# variable "enable_rds" {
#   description = "Boolean flag to enable RDS deployment"
#   type        = bool
#   default     = false
# }





# variable "db_username" {
#   description = "Username for RDS Postgres DB"
#   type = string
#   default = "user_todo_app"
# }
# variable "db_name" {
#   description = "DB Name for RDS Postgres DB"
#   type = string
#   default = "dbtodoapp"
# }


########################################
##           NETWORK VARIABLES        ##
########################################
variable "enable_nat_gateway" {
  description = "Boolean flag to define whether deploy NAT GWs or not"
  type        = bool
}

variable "vpc_app_cidr" {
  description = "VPC for Instances"
  type        = string
}

variable "subnets_public" {
  description = "Map AZ x CIDR for public subnets"
  type        = map(map(string))
}

variable "subnets_private_app" {
  description = "Map AZ x CIDR for private app subnets"
  type        = map(map(string))
}

variable "subnets_private_db" {
  description = "Map AZ x CIDR for private db subnets"
  type        = map(map(string))
}


########################################
##             EKS VARIABLES          ##
########################################
variable "enable_managed_nodes" {
  description = "Boolean flag to define whether to provision a Managed Worker Nodes or not"
  type        = bool
}

variable "enable_self_managed_nodes" {
  description = "Boolean flag to define whether to provision a Self Managed Worker Nodes or not"
  type        = bool
}

variable "worker_node_ami" {
  description = "EC2 AMI ID"
  type        = string
}

variable "worker_node_type" {
  description = "EC2 Instance Type"
  type        = string
}

variable "worker_node_capacity" {
  description = "Map to represent Worker Node capacity"
  type        = map(number)
}