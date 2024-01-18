resource "aws_launch_template" "worker_node_launch_template" {
  count = (var.enable_managed_nodes == true || var.enable_self_managed_nodes == true) ? 1 : 0

  name          = "eks-launch-template"
  image_id      = var.worker_node_ami
  instance_type = var.worker_node_type
  user_data     = base64encode(data.template_file.bootstrap_script.rendered)

  network_interfaces {
    associate_public_ip_address = false
  }
}

data "template_file" "bootstrap_script" {
  template = file("./eks/bootstrap.sh")
  vars = {
    EKS_CLUSTER_NAME          = aws_eks_cluster.eks_cluster.name
    EKS_ENDPOINT              = aws_eks_cluster.eks_cluster.endpoint
    EKS_CERTIFICATE_AUTHORITY = aws_eks_cluster.eks_cluster.certificate_authority[0].data
  }
}