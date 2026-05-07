#!/bin/bash
set -e

CLUSTER_NAME="ci-cd-cluster"
KIND_IMAGE="kindest/node:v1.30.0"

if kind get clusters | grep -q "^${CLUSTER_NAME}$"; then
  echo "Kind cluster '${CLUSTER_NAME}' already exists."
else
  echo "Creating Kind cluster '${CLUSTER_NAME}'..."
  kind create cluster --name "${CLUSTER_NAME}" --image "${KIND_IMAGE}"
fi

kubectl config use-context "kind-${CLUSTER_NAME}"

echo "Cluster is ready."
