
# Architecture Overview

This project was designed as a local-first CI/CD pipeline for Kubernetes environments.  
The goal was to simulate a realistic DevOps workflow while keeping the entire setup reproducible in environments with limited external connectivity.

The application is a small Node.js API containerized with Docker and deployed into a local Kubernetes cluster created with Kind.

The project demonstrates:

- Docker image creation
- Automated testing
- Kubernetes deployments
- Internal Kubernetes networking
- NodePort exposure
- Health validation
- CI workflow automation with GitHub Actions

---

# High-Level Architecture

```text
Developer
   ↓
Node.js Application
   ↓
Docker Build
   ↓
Docker Image
   ↓
Kind Kubernetes Cluster
   ↓
Deployment
   ↓
Pod
   ↓
Kubernetes Service (NodePort)
   ↓
Health Validation
````

---

# Application Layer

The application is a lightweight Express.js API with the following endpoints:

```text
GET /
GET /health
GET /ready
GET /version
```

These endpoints were intentionally created to support:

* Kubernetes liveness probes
* Kubernetes readiness probes
* CI/CD validation
* Health monitoring
* Environment verification

The application reads configuration values from environment variables, allowing the same container image to run across different environments without modifying the source code.

---

# Containerization

The application is packaged using Docker with a multi-stage Dockerfile.

Key implementation decisions:

* Lightweight Alpine Linux base image
* Production-only dependencies
* Non-root container execution
* Optimized image layers
* Reproducible builds using `npm ci`

The Docker image is built locally and loaded directly into the Kind cluster.

This approach avoids dependency on external image registries during the initial implementation phase.

---

# Kubernetes Layer

The Kubernetes environment is deployed using Kind (Kubernetes in Docker).

The cluster contains:

```text
Namespace
 ├── ConfigMap
 ├── Deployment
 ├── ReplicaSet
 ├── Pod
 └── Service
```

## Namespace

A dedicated namespace (`ci-cd-demo`) was created to isolate project resources from the default Kubernetes namespace.

## ConfigMap

The ConfigMap stores runtime configuration such as:

* application name
* version
* environment
* port configuration

This keeps configuration separated from application code.

## Deployment

The Deployment manages the application pod and ensures the desired state is maintained.

The deployment includes:

* container image definition
* environment variable injection
* liveness probes
* readiness probes
* port exposure

## Service

A NodePort service exposes the application externally from the Kubernetes cluster.

Internal service discovery is handled automatically through Kubernetes DNS.

---

# CI/CD Workflow

The CI pipeline is implemented with GitHub Actions.

Current pipeline stages:

```text
Checkout Repository
 ↓
Install Dependencies
 ↓
Run Tests
 ↓
Build Docker Image
```

The deployment stage is intentionally kept local-first to support reproducibility in restricted connectivity environments.

---

# Networking Flow

External validation flow:

```text
Host Machine
   ↓
Kind Node IP
   ↓
NodePort Service
   ↓
Kubernetes Service
   ↓
Application Pod
```

Internal Kubernetes validation flow:

```text
Pod
   ↓
Kubernetes DNS
   ↓
Service
   ↓
Application Pod
```

---

# Health Validation

Health verification is performed through:

```text
/health
```

This endpoint is used by:

* Kubernetes liveness probes
* readiness probes
* deployment verification scripts
* external validation tests

---

# Local-First Design

One of the main design goals of this project was reproducibility in environments with unstable or restricted internet connectivity.

For this reason:

* Docker images are built locally
* Images are loaded directly into Kind
* External registries are optional
* Kubernetes deployments are fully local
* Validation can be performed offline after initial setup

This design keeps the workflow portable and easier to reproduce across constrained environments.

