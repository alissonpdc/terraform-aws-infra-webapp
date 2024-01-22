variable "enable_managed_nodes" {
  description = "Boolean flag to define whether to provision a Managed Worker Nodes or not"
  type        = bool
}

variable "enable_self_managed_nodes" {
  description = "Boolean flag to define whether to provision a Self Managed Worker Nodes or not"
  type        = bool
}

variable "eks_cluster_subnet_ids" {
  description = "List of subnet IDs for EKS Master Node"
  type        = list(string)
}

variable "worker_node_ami" {
  description = "EC2 AMI ID"
  default     = "ami-0ea6ebeab50b26cee"
  type        = string
}

variable "worker_node_type" {
  description = "EC2 Instance Type"
  type        = string
}

variable "worker_node_option" {
  description = "Worker Node purchase option [ SPOT / ON_DEMAND ]"
  type        = string
}

variable "worker_node_subnet_ids" {
  description = "List of subnet IDs for EKS Worker Node"
  type        = list(string)
}

variable "worker_node_capacity" {
  description = "Map to represent Worker Node capacity"
  type        = map(number)
}

variable "role_sso_identity_center" {
  description = "Role created by SSO Identity Center (users will be able to manage eks cluster)"
  type        = string
}