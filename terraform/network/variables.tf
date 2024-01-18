variable "enable_nat_gateway" {
  description = "Boolean flag to define whether deploy NAT GWs or not"
  type        = bool
}

variable "vpc_app_cidr" {
  description = "VPC cidr"
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