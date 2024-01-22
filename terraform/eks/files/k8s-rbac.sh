#!/bin/bash

echo "==> Adding EKS cluster to kubecl context"
aws eks update-kubeconfig --region us-east-1 --name eks-cluster

echo "==> Printing current auth-map"
eksctl get iamidentitymapping --cluster eks-cluster --region=us-east-1

echo "==> Applying new RBAC to cluster"
kubectl apply -f ./eks/files/eks-full-access.yaml

echo "==> Adding new role to auth-map"
eksctl create iamidentitymapping --cluster eks-cluster --region=us-east-1 \
--arn arn:aws:iam::${AWS_ACCOUNT_ID}:role/${ROLE_IDENTITY_CENTER} \
--username "{{SessionName}}" --group eks-full-access-group --no-duplicate-arns

echo "==> Adding new user to auth-map"
eksctl create iamidentitymapping --cluster eks-cluster --region=us-east-1 \
--arn arn:aws:iam::${AWS_ACCOUNT_ID}:user/console \
--username admin --group eks-full-access-group --no-duplicate-arns

echo "==> Adding new user to auth-map"
eksctl create iamidentitymapping --cluster eks-cluster --region=us-east-1 \
--arn arn:aws:iam::${AWS_ACCOUNT_ID}:role/github-oidc-auth-Role-mVCfrIMPaYfi \
--username admin --group eks-full-access-group --no-duplicate-arns

echo "==> Printing updated auth-map"
eksctl get iamidentitymapping --cluster eks-cluster --region=us-east-1

echo "==> Printing aws-auth"
kubectl get configmap/aws-auth -o yaml -n kube-system 