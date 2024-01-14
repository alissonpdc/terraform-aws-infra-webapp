variable "enable_multi_az" {
  description = "Boolean flag to enable Multi-AZ deployment"
  type        = bool
  default     = false
}

variable "enable_nat_gateway" {
  description = "Boolean flag to enable Nat Gateway deployment"
  type        = bool
  default     = false
}

variable "enable_eks" {
  description = "Boolean flag to enable EKS deployment"
  type        = bool
  default     = false
}

variable "enable_bastion_host" {
  description = "Boolean flag to enable Bastion Host deployment"
  type        = bool
  default     = false
}

variable "enable_network" {
  description = "Boolean flag to enable Network deployment"
  type        = bool
  default     = false
}

variable "enable_rds" {
  description = "Boolean flag to enable RDS deployment"
  type        = bool
  default     = false
}


variable "eks_worker_node_ami" {
  description = "EC2 AMI ID"
  default     = "ami-0ea6ebeab50b26cee"
  type        = string
}

variable "eks_worker_node_type" {
  description = "EC2 Instance Type"
  default     = "t2.micro"
  type        = string
}





variable "vpc_app_cidr" {
  description = "VPC for Instances"
  default     = "10.0.0.0/16"
  type        = string
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
    "public-1c" = {
      "az"   = "us-east-1c",
      "cidr" = "10.0.2.0/24"
    }
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
    "private-app-1c" = {
      "az"   = "us-east-1c",
      "cidr" = "10.0.12.0/24"
    }
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
    "private-db-1c" = {
      "az"   = "us-east-1c",
      "cidr" = "10.0.22.0/24"
    }
  }
}