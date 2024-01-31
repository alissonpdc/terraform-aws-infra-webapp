variable "enable_nat_gateway" {
  description = "Boolean flag to define whether deploy NAT GWs or not"
  type        = bool
}

variable "enable_nat_instance" {
  description = "Boolean flag to define whether deploy NAT Instances or not"
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

variable "nat_instance_ami" {
  description = "AMI ID for NAT Instance"
  type        = string
  default     = "ami-0a3c3a20c09d6f377"
}

variable "nat_instance_type" {
  description = "Instance Type for NAT Instance"
  type        = string
  default     = "t2.micro"
}