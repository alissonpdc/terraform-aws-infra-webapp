variable "enable_nat_gateway" {
  description = "Boolean flag to define whether deploy NAT GWs or not"
  type        = bool
}

variable "vpc_app_cidr" {
  description = "VPC cidr"
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