#!/bin/bash

echo "==> Adding EKS cluster to kubecl context"
aws eks update-kubeconfig --region ${EKS_REGION} --name ${EKS_CLUSTER_NAME}

echo "==> Printing current auth-map"
eksctl get iamidentitymapping --cluster ${EKS_CLUSTER_NAME} --region=${EKS_REGION}

echo "==> Applying new RBAC to cluster"
kubectl apply -f ./eks/files/k8s-rbac-resources.yaml
