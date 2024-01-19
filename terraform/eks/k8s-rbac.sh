#!/bin/bash

echo "==> Adding EKS cluster to kubecl context"
aws eks update-kubeconfig --region us-east-1 --name eks-cluster

echo "==> Printing current auth-map"
eksctl get iamidentitymapping --cluster eks-cluster --region=us-east-1

echo "==> Applying new RBAC to cluster"
kubectl apply -f ./eks/files/eks-full-access.yaml

echo "==> Adding new role to auth-map"
eksctl create iamidentitymapping --cluster eks-cluster --region=us-east-1 \
--arn arn:aws:iam::211125453026:role/AWSReservedSSO_AdministratorAccess_018645c6c1d0e0fc \
--username "{{SessionName}}" --group eks-full-access-group --no-duplicate-arns

echo "==> Adding new user to auth-map"
eksctl create iamidentitymapping --cluster eks-cluster --region=us-east-1 \
--arn arn:aws:iam::211125453026:user/console \
--username admin --group eks-full-access-group --no-duplicate-arns

echo "==> Printing updated auth-map"
eksctl get iamidentitymapping --cluster eks-cluster --region=us-east-1

echo "==> Printing aws-auth"
kubectl get configmap/aws-auth -o yaml -n kube-system 