# github-final-project

Production-ready Bash CLI to compute simple interest. Apache-2.0. Includes CI (lint + tests), pre-commit, Makefile, Docker image, devcontainer, issue/PR templates, SECURITY, Code of Conduct, Dependabot, release automation. Usage: ./simple-interest.sh -p &lt;principal> -r &lt;rate_%> -t &lt;years>. Pro tip: make lint test. Reproducible, cross-OS.

## Getting Started

### Prerequisites

If you're new to Git and GitHub, we recommend starting with an introductory course. You can practice by forking a learning repository:

```bash
gh repo fork https://github.com/ibm-developer-skills-network/jbbmo-Introduction-to-Git-and-GitHub --clone
```

### Usage

Calculate simple interest:

```bash
./simple-interest.sh -p <principal> -r <rate_%> -t <years>
```

Example:
```bash
./simple-interest.sh -p 1000 -r 5 -t 2
# Output:
# Simple interest: 100.00
# Total amount: 1100.00
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed contribution guidelines.
