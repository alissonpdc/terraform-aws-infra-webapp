data "aws_iam_policy_document" "worker_node_trust_policy" {
  count = (var.enable_managed_nodes == true || var.enable_self_managed_nodes == true) ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "worker_node_role" {
  count = (var.enable_managed_nodes == true || var.enable_self_managed_nodes == true) ? 1 : 0

  name               = "eks-worker-node-role"
  assume_role_policy = data.aws_iam_policy_document.worker_node_trust_policy[count.index].json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
}