# github-final-project

Production-ready Bash CLI to compute simple interest. Apache-2.0. Includes CI (lint + tests), pre-commit, Makefile, Docker image, devcontainer, issue/PR templates, SECURITY, Code of Conduct, Dependabot, release automation. Usage: `./simple-interest.sh -p <principal> -r <rate_%> -t <years>`. Pro tip: make lint test. Reproducible, cross-OS.

## Quick Start

### Fork and Clone

Fork this repository using GitHub CLI:

```bash
gh repo fork https://github.com/02ez/github-final-project --clone
cd github-final-project
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

## Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed instructions on how to fork, develop, and submit changes to this project.

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.
