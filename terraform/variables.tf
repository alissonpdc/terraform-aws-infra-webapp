########################################
##       ENABLE TOGGLE FEATURES       ##
########################################
variable "aws_default_region" {
  description = "AWS Region to deploy the infrastructure"
  type        = string
  default     = "us-east-1"
}
# variable "enable_network" {
#   description = "Boolean flag to enable Network (VPC, subnet, IGW, NATGW, EIP) deployment"
#   type        = bool
# }
# variable "enable_eks" {
#   description = "Boolean flag to enable EKS deployment"
#   type        = bool
# }
# variable "enable_rds" {
#   description = "Boolean flag to enable RDS deployment"
#   type        = bool
#   default     = false
# }
variable "enable_managed_nodes" {
  description = "Boolean flag to define whether to provision a Managed Worker Nodes or not"
  type        = bool
}
variable "enable_self_managed_nodes" {
  description = "Boolean flag to define whether to provision a Self Managed Worker Nodes or not"
  type        = bool
}
variable "enable_nat_gateway" {
  description = "Boolean flag to define whether deploy NAT GWs or not"
  type        = bool
}


########################################
##           NETWORK VARIABLES        ##
########################################
variable "vpc_app_cidr" {
  description = "VPC for Instances"
  type        = string
  default     = "10.0.0.0/16"
}
variable "subnets_public" {
  description = "Map AZ x CIDR for public subnets"
  type        = map(map(string))
  default = {
    "public-1a" = {
      "az"   = "us-east-1a",
      "cidr" = "10.0.0.0/24"
    },
    "public-1b" = {
      "az"   = "us-east-1b",
      "cidr" = "10.0.1.0/24"
    },
    # "public-1c" = {
    #   "az"   = "us-east-1c",
    #   "cidr" = "10.0.2.0/24"
    # }
  }
}
variable "subnets_private_app" {
  description = "Map AZ x CIDR for private app subnets"
  type        = map(map(string))
  default = {
    "private-app-1a" = {
      "az"   = "us-east-1a",
      "cidr" = "10.0.10.0/24"
    },
    "private-app-1b" = {
      "az"   = "us-east-1b",
      "cidr" = "10.0.11.0/24"
    },
    # "private-app-1c" = {
    #   "az"   = "us-east-1c",
    #   "cidr" = "10.0.12.0/24"
    # }
  }
}
variable "subnets_private_db" {
  description = "Map AZ x CIDR for private db subnets"
  type        = map(map(string))
  default = {
    "private-db-1a" = {
      "az"   = "us-east-1a",
      "cidr" = "10.0.20.0/24"
    },
    "private-db-1b" = {
      "az"   = "us-east-1b",
      "cidr" = "10.0.21.0/24"
    },
    # "private-db-1c" = {
    #   "az"   = "us-east-1c",
    #   "cidr" = "10.0.22.0/24"
    # }
  }
}


########################################
##             EKS VARIABLES          ##
########################################
variable "worker_node_ami" {
  description = "EC2 AMI ID"
  type        = string
  default     = "ami-0ea6ebeab50b26cee"
}
variable "worker_node_type" {
  description = "EC2 Instance Type"
  type        = string
}
variable "worker_node_capacity" {
  description = "Map to represent Worker Node capacity"
  type        = map(number)
  default = {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }
}
variable "worker_node_option" {
  description = "Worker Node purchase option [ SPOT / ON_DEMAND ]"
  type        = string
}
variable "role_sso_identity_center" {
  description = "Role created by SSO Identity Center (users will be able to manage eks cluster)"
  type        = string
}


########################################
##           RDS VARIABLES            ##
########################################
variable "db_username" {
  description = "Username for RDS Postgres DB"
  type        = string
}
variable "db_name" {
  description = "DB Name for RDS Postgres DB"
  type        = string
}
variable "db_instance_type" {
  description = "Instance type to run RDS on"
  type        = string
  default     = "db.t3.micro"
}