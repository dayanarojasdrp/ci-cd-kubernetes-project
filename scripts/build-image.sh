#!/bin/bash
set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

IMAGE_NAME="ci-cd-kubernetes-app"
IMAGE_TAG="local"

echo "Building Docker image: ${IMAGE_NAME}:${IMAGE_TAG}"

docker build \
  -t ${IMAGE_NAME}:${IMAGE_TAG} \
  -f "${PROJECT_ROOT}/docker/Dockerfile" \
  "${PROJECT_ROOT}"

echo "Docker image built successfully."
