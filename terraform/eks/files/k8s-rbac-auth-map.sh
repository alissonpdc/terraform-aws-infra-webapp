echo "==> Adding new role to auth-map"
eksctl create iamidentitymapping --cluster ${EKS_CLUSTER_NAME} --region=${EKS_REGION} \
--arn ${AWS_ROLE_ARN} --username ${EKS_RBAC_USERNAME} --group eks-full-access-group --no-duplicate-arns

