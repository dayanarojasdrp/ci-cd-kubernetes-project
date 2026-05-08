
# Troubleshooting Guide

This document contains some of the most common issues encountered during the development and deployment of this project, along with the solutions used to resolve them.

The goal is to document real operational problems that appeared while building the environment locally under constrained connectivity conditions.

---

# Development Environment Constraints

This project was developed in an environment with significant internet connectivity limitations.

During development, several challenges repeatedly affected the workflow:

- unstable internet connectivity
- intermittent access to Docker Hub
- restricted access to some registry endpoints
- unreliable VPN connectivity
- timeout issues during dependency downloads
- failed image pulls from public registries
- occasional GitHub connectivity instability

Because of these conditions, many implementation decisions were adapted to prioritize:

- local reproducibility
- offline-friendly workflows
- minimal dependency on external services
- reuse of locally cached Docker images

Several parts of the project were intentionally redesigned to work reliably even when external connectivity was partially unavailable.

---

# Kubernetes Pod Stuck in ErrImagePull

## Problem

The Kubernetes pod failed to start with:

```text id="e7vcsy"
ErrImagePull
````

or:

```text id="wwmtj5"
ImagePullBackOff
```

---

## Cause

The Docker image existed locally on the host machine but was not available inside the Kind Kubernetes node.

Additionally, because of connectivity restrictions, Kubernetes could not reliably pull images from external registries.

Kind runs Kubernetes nodes as Docker containers, so locally built images are not automatically visible to the cluster.

---

## Solution

Load the image manually into Kind:

```bash id="14ajqs"
kind load docker-image ci-cd-kubernetes-app:local --name ci-cd-cluster
```

Then restart the deployment:

```bash id="5yhv4q"
kubectl rollout restart deployment ci-cd-app -n ci-cd-demo
```

This local-first workflow avoided dependency on external image registries.

---

# npm Package Installation Timeouts

## Problem

Installing dependencies occasionally failed with errors such as:

```text id="9n9p5x"
ERR_SOCKET_TIMEOUT
```

---

## Cause

The environment experienced unstable connectivity to the npm registry.

Some package downloads stalled or timed out before completing successfully.

---

## Solution

Retry installation multiple times when connectivity temporarily improved:

```bash id="91t5j1"
npm install
```

and:

```bash id="04vqz6"
npm install --save-dev jest supertest
```

Once dependencies were downloaded successfully, the local cache reduced the need for repeated downloads.

---

# Docker Compose Build Attempted External Downloads

## Problem

Running:

```bash id="4t7c3k"
docker compose up --build
```

attempted to download BuildKit images and failed with HTTP 403 errors.

---

## Cause

The environment had restricted or inconsistent access to Docker Hub endpoints.

BuildKit attempted to fetch additional images dynamically.

---

## Solution

The workflow was adapted to:

1. build images manually first
2. reuse existing local Docker images
3. avoid unnecessary external downloads

Updated workflow:

```bash id="ydmy91"
docker build -t ci-cd-kubernetes-app:local -f docker/Dockerfile .
docker compose up
```

---

# Kind Cluster Attempted to Pull New Node Image

## Problem

Creating a new Kind cluster failed because Kind attempted to download:

```text id="w8n92k"
kindest/node:v1.35.0
```

which was inaccessible from the environment.

---

## Cause

The required Kind node image was not available locally, and external image pulls were blocked or unstable.

---

## Solution

Reuse an already available local Kind image:

```bash id="i2je8h"
kind create cluster \
  --name ci-cd-cluster \
  --image kindest/node:v1.30.0
```

This avoided downloading new Kubernetes node images from external registries.

---

# NodePort Accessible Internally but Not Through localhost

## Problem

The application worked internally inside Kubernetes but failed through:

```bash id="s9s4sd"
curl http://localhost:30080/health
```

---

## Cause

Kind NodePort traffic is not always automatically mapped to localhost depending on cluster configuration.

---

## Solution

Access the service through the Kind node IP instead.

Retrieve the node IP:

```bash id="3u4t5d"
docker inspect ci-cd-cluster-control-plane \
  --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'
```

Then test:

```bash id="4e5v6s"
curl http://NODE_IP:30080/health
```

---

# Shell Script Failed to Locate Project Files

## Problem

The build script failed with errors such as:

```text id="wm52vd"
COPY app/src ./src: not found
```

---

## Cause

The script was executed from a different working directory, causing Docker build context issues.

---

## Solution

Update scripts to dynamically calculate the project root:

```bash id="9d1f7n"
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
```

This allowed scripts to work consistently regardless of the current execution path.

---

# Temporary Kubernetes Validation Pod Failed

## Problem

Testing with:

```bash id="1n8g0f"
kubectl run curl-test ...
```

failed or stalled indefinitely.

---

## Cause

The helper image was not available locally inside the Kind cluster, and the environment could not reliably download the image from Docker Hub.

---

## Solution

Validate networking using the already running application pod instead:

```bash id="h0ptd8"
kubectl exec -n ci-cd-demo deployment/ci-cd-app -- \
node -e "fetch('http://ci-cd-app-service/health').then(r=>r.text()).then(console.log)"
```

This confirmed Kubernetes internal DNS and service networking functionality without requiring additional external images.

---

# General Operational Challenges

Some development tasks required additional manual adaptation because of the restricted environment.

Examples included:

* manually reusing local Docker images
* avoiding automatic downloads whenever possible
* using local image loading instead of registry pushes
* simplifying Kubernetes networking components
* testing incrementally to avoid long failed operations
* validating builds locally before attempting CI execution

These constraints significantly influenced the final architecture and deployment strategy of the project.

---

# General Debugging Commands

Useful commands repeatedly used during troubleshooting:

Check pods:

```bash id="t3h7b1"
kubectl get pods -n ci-cd-demo
```

Describe pod events:

```bash id="4r0w7d"
kubectl describe pod POD_NAME -n ci-cd-demo
```

Check logs:

```bash id="8g6l0y"
kubectl logs POD_NAME -n ci-cd-demo
```

Check services:

```bash id="c6f8w4"
kubectl get svc -n ci-cd-demo
```

Restart deployment:

```bash id="3s5h8e"
kubectl rollout restart deployment ci-cd-app -n ci-cd-demo
```

Verify Docker images:

```bash id="4k9w2m"
docker images
```

Verify Kind clusters:

```bash id="8q3v9p"
kind get clusters
```


