
# CI/CD Kubernetes Project

A local-first CI/CD pipeline project designed to demonstrate containerized application delivery into Kubernetes using Docker, Kind, GitHub Actions, and automated deployment scripts.

The project was intentionally built to remain reproducible in environments with unstable or restricted internet connectivity while still following modern DevOps and cloud-native practices.

---

# Project Goals

This repository was created to demonstrate practical experience with:

- Docker containerization
- Kubernetes deployments
- CI automation with GitHub Actions
- local-first DevOps workflows
- deployment scripting
- health validation
- Kubernetes networking
- reproducible development environments

The objective was not only to deploy an application, but also to automate the complete local delivery workflow.

---

# Technologies Used

- Node.js
- Express.js
- Docker
- Docker Compose
- Kubernetes
- Kind
- GitHub Actions
- Jest
- Supertest
- Bash scripting

---

# Application Overview

The application is a lightweight Express.js API exposing the following endpoints:

```text id="1s31jg"
GET /
GET /health
GET /ready
GET /version
````

These endpoints support:

* Kubernetes health validation
* readiness verification
* deployment testing
* CI/CD validation workflows

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
NodePort Service
   ↓
Health Validation
```

---

# Repository Structure

```text
ci-cd-kubernetes-project/
├── app/
│   ├── src/
│   ├── tests/
│   ├── package.json
│   └── package-lock.json
│
├── docker/
│   └── Dockerfile
│
├── k8s/
│   ├── namespace.yaml
│   ├── deployment.yaml
│   ├── service.yaml
│   └── configmap.yaml
│
├── scripts/
│   ├── create-cluster.sh
│   ├── build-image.sh
│   ├── load-image-kind.sh
│   ├── deploy-local.sh
│   ├── verify.sh
│   └── destroy-cluster.sh
│
├── .github/
│   └── workflows/
│       └── ci.yaml
│
├── docs/
│   ├── architecture.md
│   ├── pipeline-flow.md
│   ├── decisions.md
│   ├── limitations.md
│   ├── troubleshooting.md
│   └── evidence/
│
├── docker-compose.yml
├── README.md
└── .gitignore
```

---

# CI/CD Workflow

The CI pipeline currently performs:

```text id="rd4l4f"
Checkout Repository
 ↓
Install Dependencies
 ↓
Run Tests
 ↓
Build Docker Image
```

The deployment stage remains local-first and uses Kind for Kubernetes validation.

---

# Local Deployment Workflow

The complete deployment process is automated through shell scripts.

Deployment flow:

```text id="0hzbko"
Create Cluster
 ↓
Build Docker Image
 ↓
Load Image into Kind
 ↓
Deploy Kubernetes Resources
 ↓
Verify Health Endpoint
```

---

# Running the Project Locally

## 1. Create the Kind cluster

```bash id="g7ye1d"
./scripts/create-cluster.sh
```

---

## 2. Build the Docker image

```bash id="yzh47t"
./scripts/build-image.sh
```

---

## 3. Load the image into Kind

```bash id="u80cdh"
./scripts/load-image-kind.sh
```

---

## 4. Deploy to Kubernetes

```bash id="b8cl4x"
./scripts/deploy-local.sh
```

---

## 5. Verify the deployment

```bash id="t1qjpd"
./scripts/verify.sh
```

---

# Docker Compose Validation

The application can also be tested locally with Docker Compose.

Start the environment:

```bash id="52j3s9"
docker compose up --build
```

Health validation:

```bash id="9x39xh"
curl http://localhost:3000/health
```

---

# Kubernetes Components

The deployment includes:

* dedicated namespace
* ConfigMap-based configuration
* Deployment resource
* NodePort service
* internal Kubernetes DNS validation

The project also validates:

* pod communication
* service discovery
* internal Kubernetes networking
* external NodePort access

---

# Automated Testing

Tests are implemented using Jest and Supertest.

Current validations include:

* `/health` endpoint availability
* `/version` endpoint structure

Run tests manually:

```bash id="9nn4ho"
cd app
npm test
```

---

# Evidence and Validation

The repository includes real deployment evidence under:

```text id="f4x1xq"
docs/evidence/
```

Examples:

* Docker build logs
* Kubernetes pod validation
* Kubernetes service validation
* health check verification
* local test execution

The goal was to keep the project operationally transparent and reproducible.

---

# Design Philosophy

This project intentionally prioritizes:

* reproducibility
* automation
* portability
* local validation
* simplified Kubernetes operations
* offline-friendly workflows

Several design decisions were influenced by working under unstable or restricted internet connectivity conditions.

As a result, the project avoids unnecessary dependency on external registries during the initial implementation phase.

---

# Current Limitations

Current limitations include:

* local Kind cluster only
* no production ingress controller
* no external load balancer
* no centralized observability stack
* no automatic registry push yet
* no automated Kubernetes deployment from CI

These limitations are documented intentionally as part of the learning and iteration process.

---

# Future Improvements

Potential future enhancements include:

* Docker Hub or Amazon ECR integration
* automated Kubernetes deployment from GitHub Actions
* ingress controller integration
* TLS automation
* Helm packaging
* image scanning
* rollout and rollback strategies
* monitoring and logging stack integration

---

# Documentation

Additional technical documentation is available in:

```text id="c1u5pw"
docs/
```

Including:

* architecture overview
* CI/CD pipeline flow
* troubleshooting notes
* design decisions
* deployment limitations

---

# Final Notes

This project was built as a practical DevOps and Kubernetes learning environment focused on understanding the complete application delivery lifecycle.

The main objective was to create a workflow that is:

* reproducible
* automated
* operationally understandable
* easy to validate locally
* adaptable to constrained environments

rather than simply deploying an application using default cloud tooling.
