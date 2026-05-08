
# CI/CD Pipeline Flow

This project implements a local-first CI/CD workflow designed to automate the build, validation, and Kubernetes deployment process for a containerized Node.js application.

The pipeline was intentionally designed to work reliably in environments with limited or unstable internet connectivity while still following modern DevOps practices.

---

# Pipeline Overview

```text
Source Code
   ↓
Dependency Installation
   ↓
Automated Tests
   ↓
Docker Image Build
   ↓
Load Image into Kind
   ↓
Kubernetes Deployment
   ↓
Health Verification
````

---

# Stage 1 — Source Code

The workflow begins with the application source code stored in GitHub.

The application is a small Express.js API that exposes:

```text
GET /
GET /health
GET /ready
GET /version
```

The repository also contains:

* Docker configuration
* Kubernetes manifests
* deployment scripts
* CI workflow definitions
* operational documentation

---

# Stage 2 — Dependency Installation

Dependencies are installed using:

```bash
npm ci
```

instead of:

```bash
npm install
```

This decision was made to guarantee reproducible builds based on the existing `package-lock.json`.

Using `npm ci` also improves consistency between:

* local development
* CI runners
* container builds

---

# Stage 3 — Automated Testing

The pipeline executes automated tests using Jest and Supertest.

Current tests validate:

* `/health` endpoint availability
* `/version` endpoint response structure

Example:

```text
GET /health → HTTP 200
GET /version → returns version metadata
```

This stage ensures that application behavior is validated before creating deployment artifacts.

---

# Stage 4 — Docker Image Build

After tests pass successfully, the application is packaged into a Docker image.

The build process uses:

* multi-stage Docker builds
* lightweight Alpine Linux images
* production-only dependencies
* non-root execution

Example build command:

```bash
docker build -t ci-cd-kubernetes-app:local -f docker/Dockerfile .
```

The resulting image becomes the deployment artifact for Kubernetes.

---

# Stage 5 — Load Image into Kind

Instead of pushing the image to an external registry, the image is loaded directly into the local Kind cluster.

Example:

```bash
kind load docker-image ci-cd-kubernetes-app:local --name ci-cd-cluster
```

This local-first workflow was selected to keep the project reproducible in restricted connectivity environments.

---

# Stage 6 — Kubernetes Deployment

The deployment process applies Kubernetes manifests in the following order:

```text
Namespace
 ↓
ConfigMap
 ↓
Deployment
 ↓
Service
```

The Deployment creates and manages the application pod.

The Service exposes the application using NodePort.

The ConfigMap injects runtime configuration into the container environment.

---

# Stage 7 — Health Verification

After deployment, the application is validated through Kubernetes networking using the `/health` endpoint.

Validation flow:

```text
Host Machine
   ↓
NodePort
   ↓
Kubernetes Service
   ↓
Application Pod
```

Example verification command:

```bash
curl http://NODE_IP:30080/health
```

Expected response:

```json
{"status":"ok"}
```

Additional internal validation was also performed using Kubernetes service discovery and DNS resolution inside the cluster.

---

# Local Automation Scripts

To simplify reproducibility, the project includes automation scripts for each deployment stage.

Available scripts:

```text
create-cluster.sh
build-image.sh
load-image-kind.sh
deploy-local.sh
verify.sh
destroy-cluster.sh
```

These scripts automate the complete local deployment workflow.

---

# GitHub Actions CI Workflow

The CI workflow is implemented using GitHub Actions.

Current CI stages:

```text
Checkout Repository
 ↓
Set Up Node.js
 ↓
Install Dependencies
 ↓
Run Tests
 ↓
Build Docker Image
```

At the current stage of the project, deployment remains local-first and intentionally avoids mandatory dependency on external registries.

---

# Design Philosophy

The pipeline prioritizes:

* reproducibility
* simplicity
* portability
* local validation
* automation
* Kubernetes-native deployment practices

The goal of the project was not only to deploy an application, but also to demonstrate understanding of the full CI/CD lifecycle in constrained environments.


