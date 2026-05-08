
# Troubleshooting Guide

This document contains some of the most common issues encountered during the development and deployment of this project, along with the solutions used to resolve them.

The goal is to document real operational problems that appeared while building the environment locally.

---

# Kubernetes Pod Stuck in ErrImagePull

## Problem

The Kubernetes pod failed to start with:

```text id="7k0l74"
ErrImagePull
````

or:

```text id="0q7t0h"
ImagePullBackOff
```

---

## Cause

The Docker image existed locally on the host machine but was not available inside the Kind Kubernetes node.

Kind runs Kubernetes nodes as Docker containers, so locally built images are not automatically visible to the cluster.

---

## Solution

Load the image manually into Kind:

```bash id="wlfd1m"
kind load docker-image ci-cd-kubernetes-app:local --name ci-cd-cluster
```

Then restart the deployment:

```bash id="ahj43k"
kubectl rollout restart deployment ci-cd-app -n ci-cd-demo
```

---

# Namespace Not Found During kubectl apply

## Problem

Applying manifests produced:

```text id="clg5ne"
namespaces "ci-cd-demo" not found
```

---

## Cause

The namespace resource had not finished creating before the remaining manifests were applied.

---

## Solution

Apply the namespace first:

```bash id="0s8mr5"
kubectl apply -f k8s/namespace.yaml
```

Then apply the remaining manifests:

```bash id="t94w50"
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
```

---

# Docker Compose Build Attempted External Download

## Problem

Running:

```bash id="m2zkk0"
docker compose up --build
```

attempted to download BuildKit images and failed with HTTP 403 errors.

---

## Cause

The environment had connectivity restrictions preventing access to some Docker Hub endpoints.

---

## Solution

The workflow was adapted to:

1. build images manually first
2. use local images directly inside Docker Compose

Updated workflow:

```bash id="lbvfp0"
docker build -t ci-cd-kubernetes-app:local -f docker/Dockerfile .
docker compose up
```

---

# Kind Cluster Attempted to Pull New Node Image

## Problem

Creating a new Kind cluster failed because Kind attempted to download:

```text id="tklr83"
kindest/node:v1.35.0
```

---

## Cause

The default Kind version expected a newer node image that was not locally available.

---

## Solution

Reuse the existing local Kind node image:

```bash id="mc5p4m"
kind create cluster \
  --name ci-cd-cluster \
  --image kindest/node:v1.30.0
```

---

# NodePort Accessible Internally but Not Through localhost

## Problem

The application worked internally inside Kubernetes but failed through:

```bash id="rv8t1o"
curl http://localhost:30080/health
```

---

## Cause

Kind NodePort traffic is not always automatically mapped to localhost depending on cluster configuration.

---

## Solution

Access the service through the Kind node IP instead.

Retrieve the node IP:

```bash id="xtw1qh"
docker inspect ci-cd-cluster-control-plane \
  --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'
```

Then test:

```bash id="u9l8p6"
curl http://NODE_IP:30080/health
```

---

# Shell Script Failed to Locate Project Files

## Problem

The build script failed with errors such as:

```text id="zq6cpx"
COPY app/src ./src: not found
```

---

## Cause

The script was executed from a different working directory, causing Docker build context issues.

---

## Solution

Update scripts to dynamically calculate the project root:

```bash id="ypr8fy"
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
```

This allows scripts to run correctly regardless of the current directory.

---

# Temporary Kubernetes Validation Pod Failed

## Problem

Testing with:

```bash id="l08wjl"
kubectl run curl-test ...
```

failed or stalled indefinitely.

---

## Cause

The helper image was not available locally inside the Kind cluster, and the environment could not reliably pull the image externally.

---

## Solution

Validate networking using the already running application pod instead:

```bash id="g30x4w"
kubectl exec -n ci-cd-demo deployment/ci-cd-app -- \
node -e "fetch('http://ci-cd-app-service/health').then(r=>r.text()).then(console.log)"
```

This confirmed Kubernetes internal DNS and service networking functionality without depending on additional external images.

---

# General Debugging Commands

Useful commands used repeatedly during troubleshooting:

Check pods:

```bash id="1gtnpm"
kubectl get pods -n ci-cd-demo
```

Describe pod events:

```bash id="2uwkkr"
kubectl describe pod POD_NAME -n ci-cd-demo
```

Check logs:

```bash id="d9l4t9"
kubectl logs POD_NAME -n ci-cd-demo
```

Check services:

```bash id="7mj0o8"
kubectl get svc -n ci-cd-demo
```

Restart deployment:

```bash id="97g2a2"
kubectl rollout restart deployment ci-cd-app -n ci-cd-demo
```

Verify Docker images:

```bash id="yz9t9y"
docker images
```

Verify Kind clusters:

```bash id="cfj8dx"
kind get clusters
```

