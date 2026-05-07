#!/bin/bash
set -e

CLUSTER_NAME="ci-cd-cluster"
IMAGE_NAME="ci-cd-kubernetes-app"
IMAGE_TAG="local"

echo "Loading Docker image into Kind cluster..."

kind load docker-image \
  ${IMAGE_NAME}:${IMAGE_TAG} \
  --name ${CLUSTER_NAME}

echo "Docker image loaded into Kind successfully."
