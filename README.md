# github-final-project

[![CI](https://github.com/02ez/github-final-project/workflows/CI/badge.svg)](https://github.com/02ez/github-final-project/actions)
[![Security Scan](https://github.com/02ez/github-final-project/workflows/Security%20Scan/badge.svg)](https://github.com/02ez/github-final-project/actions)
[![Supply Chain](https://github.com/02ez/github-final-project/workflows/Supply%20Chain%20Security/badge.svg)](https://github.com/02ez/github-final-project/actions)
[![License: Apache-2.0](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Shell](https://img.shields.io/badge/Shell-Bash-green.svg)](https://www.gnu.org/software/bash/)
[![SLSA 3](https://img.shields.io/badge/SLSA-Level%203-green)](https://slsa.dev)
[![Security Policy](https://img.shields.io/badge/Security-Policy-blue)](SECURITY.md)

Enterprise-grade Bash CLI to compute simple interest with comprehensive security controls, supply chain security, and compliance frameworks. Apache-2.0 licensed. Features automated testing, security scanning, SBOM generation, container signing, and deployment automation. Usage: `./simple-interest.sh -p <principal> -r <rate_%> -t <years>`. Production-ready for regulated environments.

## Quick Start

### Fork and Clone

Fork this repository using GitHub CLI:

```bash
gh repo fork https://github.com/02ez/github-final-project --clone
cd github-final-project
make test
```

### Usage

Calculate simple interest with the following command:

```bash
./simple-interest.sh -p <principal> -r <rate_%> -t <years>
```

**Example:**
```bash
./simple-interest.sh -p 1000 -r 5 -t 2
```

**Output:**
```
Simple interest: 100.00
Total amount: 1100.00
```

### Docker Usage

Run with Docker:

```bash
docker build -t simple-interest .
docker run simple-interest -p 1000 -r 5 -t 2
```

## Why This is Enterprise-Grade

This repository demonstrates enterprise-grade software development practices for regulated environments:

### Security and Compliance
- **Multi-layered Security Scanning**: Trivy, Semgrep, and TruffleHog integration
- **Supply Chain Security**: SLSA Level 3 provenance and SBOM generation
- **Container Security**: Signed images with cosign and vulnerability scanning
- **Secret Management**: OIDC-based authentication, no long-lived keys
- **Access Control**: Role-based CODEOWNERS with required approvals

### Automation and Quality
- **Comprehensive CI/CD**: Build, test, lint, security scan, and deploy pipelines
- **Automated Testing**: BATS test suite with 100% coverage and quality gates
- **Code Quality**: Shellcheck integration and pre-commit hooks
- **Dependency Management**: Dependabot with vulnerability alerts
- **Performance Monitoring**: Resource budgets and SLO tracking

### Enterprise Operations
- **Deployment Automation**: Multi-environment with canary deployments
- **Observability**: Metrics, logging, and alerting integration
- **Incident Response**: Comprehensive runbooks and rollback procedures
- **Documentation**: Complete technical documentation and ADRs
- **Compliance**: SOC2, ISO27001, and regulatory framework support

### Supply Chain Integrity
- **SBOM Generation**: Complete software bill of materials
- **Provenance Tracking**: Cryptographic attestation of build process
- **Vulnerability Management**: Automated scanning and alerting
- **Reproducible Builds**: Deterministic container images

## Development

### Prerequisites

Install development dependencies:

```bash
make install  # Ubuntu/Debian
# or manually: sudo apt-get install bats shellcheck bc
```

### Local Development with Pre-commit

Set up pre-commit hooks:

```bash
pip install pre-commit
pre-commit install
```

This will run shellcheck and shfmt on every commit.

### Enterprise CI/CD Workflows

The repository includes comprehensive enterprise-grade workflows:

- **Build and Test** (`.github/workflows/build-test.yaml`): Multi-OS testing with coverage gates
- **Security Scan** (`.github/workflows/security-scan.yaml`): Trivy, Semgrep, and secret detection
- **Supply Chain** (`.github/workflows/supply-chain.yaml`): SBOM generation and container signing
- **Deploy** (`.github/workflows/deploy.yaml`): Multi-environment deployment with approval gates

### Security Commands

```bash
# Run security scans locally
trivy fs --exit-code 1 --severity HIGH,CRITICAL .
semgrep ci

# Generate SBOM
syft packages dir:. -o spdx-json=sbom.json

# Verify container signatures (after build)
cosign verify ghcr.io/02ez/github-final-project:latest
```

## Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed instructions on how to fork, develop, and submit changes to this project.

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.
