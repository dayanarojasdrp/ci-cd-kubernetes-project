
# Design Decisions

This document explains some of the main technical and architectural decisions made during the development of this project.

The goal of the project was not only to deploy an application into Kubernetes, but also to build a reproducible and realistic CI/CD workflow that could operate reliably in constrained environments.

---

# Local-First Architecture

One of the earliest design decisions was to prioritize a local-first workflow.

Instead of depending entirely on external cloud services or image registries, the project was designed to work primarily with:

- local Docker builds
- local Kubernetes clusters
- local image loading into Kind

This decision was heavily influenced by unstable external connectivity and limited access to some public registries during development.

As a result, the workflow remains reproducible even when internet access is partially restricted.

---

# Why Kind Was Selected

Kind (Kubernetes in Docker) was selected because it provides a lightweight Kubernetes environment that can run entirely locally.

Advantages of using Kind for this project:

- fast cluster creation
- low resource consumption
- easy reproducibility
- compatibility with standard Kubernetes manifests
- local testing without cloud dependency

A dedicated cluster (`ci-cd-cluster`) was created specifically for this project to avoid mixing workloads with previous Kubernetes experiments.

---

# Separation of Configuration from Application Code

Application configuration was externalized using Kubernetes ConfigMaps.

Instead of hardcoding runtime values inside the Node.js application, variables such as:

- application name
- environment
- version
- port

are injected dynamically by Kubernetes.

This approach improves portability and follows common cloud-native deployment practices.

---

# Why NodePort Was Used

The application is exposed using a Kubernetes NodePort service.

NodePort was selected because:

- it works well in local Kubernetes environments
- it requires minimal additional infrastructure
- it simplifies validation and troubleshooting
- it avoids dependency on ingress controllers during the initial implementation

This also made it easier to validate the deployment through direct HTTP health checks.

---

# Health Endpoints

Dedicated endpoints were intentionally created for operational validation:

```text id="1ghn8n"
/health
/ready
/version
````

These endpoints support:

* Kubernetes liveness probes
* readiness probes
* deployment verification
* CI validation
* troubleshooting

Separating operational endpoints from application logic improves observability and deployment reliability.

---

# Multi-Stage Docker Builds

The Docker image uses a multi-stage build process.

This approach was selected to:

* reduce final image size
* remove unnecessary development dependencies
* improve security
* optimize deployment artifacts

Production containers only include runtime dependencies required by the application.

---

# Non-Root Container Execution

The container runs using the default `node` user instead of the root user.

This decision reduces container privileges and follows basic container security best practices.

Although this is a relatively small project, maintaining secure defaults was considered important from the beginning.

---

# Why npm ci Was Used Instead of npm install

The project uses:

```bash id="f0xqqr"
npm ci
```

instead of:

```bash id="5f7zyv"
npm install
```

because reproducibility is critical in CI/CD workflows.

Using `npm ci` guarantees that dependency versions remain consistent across:

* local environments
* CI pipelines
* Docker builds

---

# Automated Local Scripts

Deployment stages were automated using shell scripts.

The objective was to avoid repetitive manual commands and simulate a real deployment pipeline.

The scripts automate:

```text id="q8m1ij"
cluster creation
image building
image loading
deployment
health verification
cluster cleanup
```

This also improves reproducibility for future testing and documentation.

---

# Why External Registry Push Was Deferred

Pushing images to Docker Hub or cloud registries was intentionally postponed during the first implementation phase.

The main reasons were:

* connectivity instability
* restricted access to some registry endpoints
* focus on validating the CI/CD workflow itself first

The current implementation demonstrates the complete local CI/CD lifecycle before introducing external registry integration.

---

# Documentation as Part of the Project

A significant amount of effort was dedicated to operational documentation and evidence collection.

The repository includes:

* architecture explanations
* troubleshooting notes
* deployment evidence
* validation outputs
* design decisions

The intention was to make the project understandable and reproducible rather than simply functional.

