variable "enable_managed_nodes" {
  description = "Boolean flag to define whether to provision a Managed Worker Nodes or not"
  type        = bool
}

variable "enable_self_managed_nodes" {
  description = "Boolean flag to define whether to provision a Self Managed Worker Nodes or not"
  type        = bool
}

variable "eks_cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "eks_cluster_subnet_ids" {
  description = "List of subnet IDs for EKS Master Node"
  type        = list(string)
}

variable "eks_master_version" {
  description = "EKS Master version"
  type        = string
}

variable "eks_auth_map" {
  description = "List of objects to add in EKS's auth-map configmap"
  type = list(object({
    role = string
    username = string
  }))
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
