#!/bin/bash

echo "==> Starting bootstrap script"
echo "=> EKS_ENDPOINT: ${EKS_ENDPOINT}"
echo "=> EKS_CERTIFICATE_AUTHORITY: ${EKS_CERTIFICATE_AUTHORITY}"
echo "=> EKS_CLUSTER_NAME: ${EKS_CLUSTER_NAME}"
/etc/eks/bootstrap.sh \
    --apiserver-endpoint ${EKS_ENDPOINT} \
    --b64-cluster-ca ${EKS_CERTIFICATE_AUTHORITY} \
    ${EKS_CLUSTER_NAME}
echo "==> Finishing bootstrap script"