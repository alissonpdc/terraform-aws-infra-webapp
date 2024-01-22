#!/bin/bash

echo "==> Starting bootstrap script"
echo "=> EKS_ENDPOINT: ${EKS_ENDPOINT}"
echo "=> EKS_CERTIFICATE_AUTHORITY: ${EKS_CERTIFICATE_AUTHORITY}"
echo "=> EKS_CLUSTER_NAME: ${EKS_CLUSTER_NAME}"

# get instance details to feed into bootstrap script`
az=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
instance_type=$(curl -s http://169.254.169.254/latest/meta-data/instance-type)
    
# set region for aws cli
aws configure set region `curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region`
    
# calculate number of max-pods
# https://docs.aws.amazon.com/eks/latest/userguide/cni-custom-network.html
max_if=$(aws ec2 describe-instance-types  --instance-types $${instance_type} --query  InstanceTypes[*].NetworkInfo.MaximumNetworkInterfaces --output text)
max_ips_per_if=$(aws ec2 describe-instance-types  --instance-types $${instance_type} --query  InstanceTypes[*].NetworkInfo.Ipv4AddressesPerInterface --output text)
max_pods=$((($${max_if} -1) * ($${max_ips_per_if} -1 ) + 2))

echo "==> Max PODs: $${max_pods}"
    
/etc/eks/bootstrap.sh  --use-max-pods false --apiserver-endpoint ${EKS_ENDPOINT} --b64-cluster-ca ${EKS_CERTIFICATE_AUTHORITY} \
    --kubelet-extra-args "--node-labels=k8s.amazonaws.com/eniConfig=$${az} --max-pods=$${max_pods}" '${EKS_CLUSTER_NAME}'
    
echo "==> Finishing bootstrap script"