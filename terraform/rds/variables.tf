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

variable "vpc_id" {
  description = "VPC ID to deploy RDS on"
  type        = string
}

variable "worker_node_sec_group_id" {
  description = "Securiy Group ID of the Worker Nodes"
  type        = string
}

variable "db_subnets_private_ids" {
  description = "Subnet IDs of the RDS instances"
  type        = list(string)
}