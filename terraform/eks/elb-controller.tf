resource "aws_iam_policy" "elb_controller_policy" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  description = "Policy for ELB Controller on EKS"
  policy      = file("./eks/files/elb-controller-policy.json")
}

resource "aws_iam_role" "elb_controller_role" {
  name                = "eks-elb-controller-role"
  managed_policy_arns = [aws_iam_policy.elb_controller_policy.arn]
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "${aws_iam_openid_connect_provider.oidc.arn}"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "${replace(aws_iam_openid_connect_provider.oidc.url, "https://", "")}:aud" : "sts.amazonaws.com",
            "${replace(aws_iam_openid_connect_provider.oidc.url, "https://", "")}:sub" : "system:serviceaccount:kube-system:aws-load-balancer-controller"
          }
        }
      }
    ]
  })

  tags = {
    Name = "eks-elb-controller-role"
  }

  lifecycle {
    replace_triggered_by = [aws_iam_policy.elb_controller_policy]
  }
}

resource "kubectl_manifest" "elb_controller_serviceaccount" {
  depends_on = [aws_eks_node_group.eks_node_group]

  yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app.kubernetes.io/component: controller
    app.kubernetes.io/name: aws-load-balancer-controller
  name: aws-load-balancer-controller
  namespace: kube-system
  annotations:
    eks.amazonaws.com/role-arn: ${aws_iam_role.elb_controller_role.arn}
YAML
}

resource "helm_release" "aws_elb_controller" {
  depends_on = [
    aws_eks_node_group.eks_node_group,
    aws_iam_role.elb_controller_role
  ]

  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"

  set {
    name  = "clusterName"
    value = aws_eks_cluster.eks_cluster.name
  }
  set {
    name  = "serviceAccount.create"
    value = false
  }
  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }
}