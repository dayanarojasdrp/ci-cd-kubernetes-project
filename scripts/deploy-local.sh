#!/bin/bash
set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
NAMESPACE="ci-cd-demo"

echo "Applying Kubernetes manifests..."

kubectl apply -f "${PROJECT_ROOT}/k8s/namespace.yaml"
kubectl apply -f "${PROJECT_ROOT}/k8s/configmap.yaml"
kubectl apply -f "${PROJECT_ROOT}/k8s/deployment.yaml"
kubectl apply -f "${PROJECT_ROOT}/k8s/service.yaml"

echo "Waiting for deployment rollout..."

kubectl rollout status deployment/ci-cd-app -n "${NAMESPACE}"

echo "Deployment completed successfully."
