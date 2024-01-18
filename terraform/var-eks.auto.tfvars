enable_managed_nodes      = true
enable_self_managed_nodes = false

worker_node_ami  = "ami-0ea6ebeab50b26cee"
worker_node_type = "t2.micro"
worker_node_capacity = {
  desired_size = 2
  max_size     = 2
  min_size     = 2
}