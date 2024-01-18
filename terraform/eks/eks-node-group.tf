resource "aws_eks_node_group" "eks_node_group" {
  count = var.enable_managed_nodes == true ? 1 : 0

  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "eks-node-group"
  node_role_arn   = aws_iam_role.worker_node_role[count.index].arn
  subnet_ids      = var.worker_node_subnet_ids
  launch_template {
    id      = aws_launch_template.worker_node_launch_template[count.index].id
    version = aws_launch_template.worker_node_launch_template[count.index].latest_version
  }

  scaling_config {
    desired_size = var.worker_node_capacity.desired_size
    max_size     = var.worker_node_capacity.max_size
    min_size     = var.worker_node_capacity.min_size
  }
}