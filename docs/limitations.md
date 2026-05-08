
# Current Limitations

This document describes some of the current limitations and constraints encountered during the development of this project.

The goal of documenting these limitations is to provide transparency about the implementation decisions and the development environment used throughout the project.

---

# Connectivity Restrictions

One of the biggest challenges during development was working in an environment with unstable or restricted internet connectivity.

Several external services and registry endpoints were intermittently unavailable, including:

- Docker Hub image pulls
- BuildKit image downloads
- external Kubernetes helper images
- some GitHub Actions dependencies

Because of this, the project was intentionally designed using a local-first approach whenever possible.

Examples:

- Docker images were built locally
- images were loaded directly into Kind
- deployment validation was performed locally
- external image registries were treated as optional during the initial implementation phase

---

# External Registry Integration Deferred

The current version of the project does not automatically push images to:

- Docker Hub
- Amazon ECR
- other external registries

This functionality was intentionally postponed in order to prioritize:

- reproducibility
- local validation
- offline-friendly workflows
- stability during development

The CI workflow currently validates:

- dependency installation
- automated tests
- Docker image builds

Future iterations can extend the pipeline with registry integration and automated deployments.

---

# Kind Local Environment

The Kubernetes environment uses Kind running locally inside Docker.

While this setup is very useful for development and learning purposes, it differs from production-grade Kubernetes environments in several ways:

- single-node cluster
- limited networking complexity
- simplified storage behavior
- no external load balancer integration
- no high availability

The project was designed to demonstrate Kubernetes deployment concepts rather than production-scale orchestration.

---

# Limited Ingress and TLS Automation

The current implementation exposes the application through a NodePort service.

An ingress controller and automated TLS management were intentionally not added during the first implementation stage in order to keep the environment simpler and easier to troubleshoot locally.

HTTPS termination and ingress automation can be added in future versions.

---

# Local-Only Deployment Verification

Deployment verification currently depends on local scripts and direct health checks.

Example:

```bash id="zpqyx7"
./scripts/verify.sh
````

This workflow is sufficient for local validation but does not yet include:

* centralized monitoring
* distributed logging
* observability stacks
* alerting systems

---

# GitHub Actions Scope

The GitHub Actions workflow currently performs CI validation only.

Implemented stages:

```text id="3r89m4"
dependency installation
automated tests
Docker image build
```

The pipeline does not yet include:

* automated Kubernetes deployment
* rollback strategies
* image scanning
* artifact signing
* release tagging

These features are intended for future iterations after validating the local-first deployment workflow.

---

# Offline Development Constraints

Some parts of the development process required adapting workflows to environments with intermittent connectivity.

Examples:

* avoiding unnecessary image pulls
* reusing locally cached images
* manually loading images into Kind
* avoiding dependency on cloud-only workflows

These constraints influenced several architectural decisions throughout the project.

---

# Educational and Demonstration Scope

This project was created primarily as:

* a CI/CD learning exercise
* a Kubernetes deployment practice environment
* a reproducible DevOps demonstration project

The focus was placed on:

* automation
* reproducibility
* operational understanding
* deployment workflows

rather than building a production-scale business application.

