#!/bin/bash
set -e

NODE_NAME="ci-cd-cluster-control-plane"
NODE_PORT="30080"

NODE_IP=$(docker inspect "${NODE_NAME}" --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}')

echo "Verifying application through NodePort..."
echo "Node IP: ${NODE_IP}"
echo "URL: http://${NODE_IP}:${NODE_PORT}/health"

curl --fail "http://${NODE_IP}:${NODE_PORT}/health"

echo
echo "Application health check passed."
