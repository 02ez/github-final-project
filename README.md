# github-final-project

[![CI](https://github.com/02ez/github-final-project/workflows/CI/badge.svg)](https://github.com/02ez/github-final-project/actions)
[![License: Apache-2.0](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Shell](https://img.shields.io/badge/Shell-Bash-green.svg)](https://www.gnu.org/software/bash/)

Production-ready Bash CLI to compute simple interest. Apache-2.0. Includes CI (lint + tests), pre-commit, Makefile, Docker image, devcontainer, issue/PR templates, SECURITY, Code of Conduct, Dependabot, release automation. Usage: `./simple-interest.sh -p <principal> -r <rate_%> -t <years>`. Pro tip: make lint test. Reproducible, cross-OS.

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

### Repository Cleanup

For repository administrators, a cleanup script is available to perform maintenance tasks:

```bash
make cleanup
# or directly:
./cleanup.sh
```

This script performs the following operations:
- Closes all Dependabot pull requests
- Deletes failing workflow runs for specified workflows
- Disables problematic workflows

**Note:** Requires GitHub CLI (`gh`) to be installed and authenticated.

## Why This is Production-Quality

This repository demonstrates enterprise-grade software development practices:

- **Automated Testing**: Comprehensive BATS test suite with edge cases
- **Continuous Integration**: GitHub Actions workflow with lint and test automation  
- **Code Quality**: Shellcheck integration and pre-commit hooks
- **Security**: Documented security policy and vulnerability reporting process
- **Dependency Management**: Dependabot automation for GitHub Actions updates
- **Reproducibility**: Docker containerization and VS Code devcontainer
- **Documentation**: Complete README, Contributing guidelines, and Code of Conduct
- **Automation**: Makefile targets for common development tasks

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

### Common Development Tasks

Use the Makefile for common development tasks:

```bash
make test     # Run BATS test suite
make lint     # Run shellcheck on all scripts
make clean    # Clean temporary files
make cleanup  # Run repository cleanup (admin only)
make help     # Show all available targets
```

## Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed instructions on how to fork, develop, and submit changes to this project.

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.
