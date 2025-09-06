# Makefile for Simple Interest Calculator
# Production-ready build automation following modern practices

SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help
.DELETE_ON_ERROR:
.SUFFIXES:

# Project metadata
PROJECT_NAME := simple-interest
SCRIPT_NAME := simple-interest.sh
VERSION := $(shell grep "SCRIPT_VERSION=" $(SCRIPT_NAME) | cut -d'"' -f2)
BUILD_DATE := $(shell date -u +'%Y-%m-%dT%H:%M:%SZ')
GIT_COMMIT := $(shell git rev-parse --short HEAD 2>/dev/null || echo "unknown")

# Directories
SRC_DIR := .
TEST_DIR := tests
DOCS_DIR := docs
BUILD_DIR := build
DIST_DIR := dist

# Colors for output
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[1;33m
BLUE := \033[0;34m
NC := \033[0m # No Color

# Tools
BATS := bats
SHELLCHECK := shellcheck
SHFMT := shfmt
BC := bc

##@ General

.PHONY: help
help: ## Display this help message
	@echo -e "$(BLUE)Simple Interest Calculator - Makefile Help$(NC)"
	@echo -e "$(BLUE)============================================$(NC)"
	@echo ""
	@echo -e "Project: $(GREEN)$(PROJECT_NAME) v$(VERSION)$(NC)"
	@echo -e "Build:   $(YELLOW)$(BUILD_DATE)$(NC)"
	@echo -e "Commit:  $(YELLOW)$(GIT_COMMIT)$(NC)"
	@echo ""
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make $(GREEN)<target>$(NC)\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  $(GREEN)%-15s$(NC) %s\n", $$1, $$2 } /^##@/ { printf "\n$(BLUE)%s$(NC)\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: info
info: ## Display project information
	@echo -e "$(BLUE)Project Information$(NC)"
	@echo -e "=================="
	@echo -e "Name:       $(GREEN)$(PROJECT_NAME)$(NC)"
	@echo -e "Version:    $(GREEN)$(VERSION)$(NC)"
	@echo -e "Script:     $(GREEN)$(SCRIPT_NAME)$(NC)"
	@echo -e "Build Date: $(YELLOW)$(BUILD_DATE)$(NC)"
	@echo -e "Git Commit: $(YELLOW)$(GIT_COMMIT)$(NC)"

##@ Development

.PHONY: install
install: check-deps ## Install development dependencies and tools
	@echo -e "$(BLUE)Installing development dependencies...$(NC)"
	@if ! command -v $(BATS) >/dev/null 2>&1; then \
		echo -e "$(YELLOW)Installing bats...$(NC)"; \
		if command -v apt-get >/dev/null 2>&1; then \
			sudo apt-get update && sudo apt-get install -y bats; \
		elif command -v brew >/dev/null 2>&1; then \
			brew install bats-core; \
		else \
			echo -e "$(RED)Please install bats manually$(NC)"; \
		fi; \
	fi
	@if ! command -v $(SHELLCHECK) >/dev/null 2>&1; then \
		echo -e "$(YELLOW)Installing shellcheck...$(NC)"; \
		if command -v apt-get >/dev/null 2>&1; then \
			sudo apt-get install -y shellcheck; \
		elif command -v brew >/dev/null 2>&1; then \
			brew install shellcheck; \
		else \
			echo -e "$(RED)Please install shellcheck manually$(NC)"; \
		fi; \
	fi
	@if ! command -v $(SHFMT) >/dev/null 2>&1; then \
		echo -e "$(YELLOW)Installing shfmt...$(NC)"; \
		if command -v go >/dev/null 2>&1; then \
			go install mvdan.cc/sh/v3/cmd/shfmt@latest; \
		else \
			echo -e "$(RED)Please install shfmt manually or install Go$(NC)"; \
		fi; \
	fi
	@echo -e "$(GREEN)Dependencies installed successfully!$(NC)"

.PHONY: check-deps
check-deps: ## Check if required dependencies are installed
	@echo -e "$(BLUE)Checking dependencies...$(NC)"
	@command -v $(BC) >/dev/null 2>&1 || (echo -e "$(RED)bc is required but not installed$(NC)" && exit 1)
	@echo -e "$(GREEN)All required dependencies are available$(NC)"

##@ Quality Assurance

.PHONY: lint
lint: check-deps ## Run linting checks on shell scripts
	@echo -e "$(BLUE)Running linting checks...$(NC)"
	@if command -v $(SHELLCHECK) >/dev/null 2>&1; then \
		echo -e "$(YELLOW)Running shellcheck...$(NC)"; \
		$(SHELLCHECK) -x $(SCRIPT_NAME) || (echo -e "$(RED)Shellcheck failed$(NC)" && exit 1); \
		echo -e "$(GREEN)Shellcheck passed$(NC)"; \
	else \
		echo -e "$(YELLOW)Shellcheck not available, skipping$(NC)"; \
	fi

.PHONY: format
format: ## Format shell scripts using shfmt
	@echo -e "$(BLUE)Formatting shell scripts...$(NC)"
	@if command -v $(SHFMT) >/dev/null 2>&1; then \
		echo -e "$(YELLOW)Running shfmt...$(NC)"; \
		$(SHFMT) -w -i 4 -ci $(SCRIPT_NAME); \
		echo -e "$(GREEN)Formatting completed$(NC)"; \
	else \
		echo -e "$(YELLOW)shfmt not available, skipping$(NC)"; \
	fi

.PHONY: format-check
format-check: ## Check if scripts are properly formatted
	@echo -e "$(BLUE)Checking script formatting...$(NC)"
	@if command -v $(SHFMT) >/dev/null 2>&1; then \
		$(SHFMT) -d -i 4 -ci $(SCRIPT_NAME) || (echo -e "$(RED)Scripts are not properly formatted$(NC)" && exit 1); \
		echo -e "$(GREEN)All scripts are properly formatted$(NC)"; \
	else \
		echo -e "$(YELLOW)shfmt not available, skipping$(NC)"; \
	fi

##@ Testing

.PHONY: test
test: check-deps ## Run all tests
	@echo -e "$(BLUE)Running test suite...$(NC)"
	@if [ -d "$(TEST_DIR)" ] && [ -f "$(TEST_DIR)/$(SCRIPT_NAME:.sh=.bats)" ]; then \
		if command -v $(BATS) >/dev/null 2>&1; then \
			$(BATS) $(TEST_DIR)/$(SCRIPT_NAME:.sh=.bats) || (echo -e "$(RED)Tests failed$(NC)" && exit 1); \
			echo -e "$(GREEN)All tests passed$(NC)"; \
		else \
			echo -e "$(RED)bats is required for testing$(NC)" && exit 1; \
		fi; \
	else \
		echo -e "$(RED)Test files not found$(NC)" && exit 1; \
	fi

.PHONY: test-verbose
test-verbose: check-deps ## Run tests with verbose output
	@echo -e "$(BLUE)Running test suite (verbose)...$(NC)"
	@if [ -d "$(TEST_DIR)" ] && [ -f "$(TEST_DIR)/$(SCRIPT_NAME:.sh=.bats)" ]; then \
		if command -v $(BATS) >/dev/null 2>&1; then \
			$(BATS) --verbose-run $(TEST_DIR)/$(SCRIPT_NAME:.sh=.bats); \
		else \
			echo -e "$(RED)bats is required for testing$(NC)" && exit 1; \
		fi; \
	else \
		echo -e "$(RED)Test files not found$(NC)" && exit 1; \
	fi

.PHONY: test-coverage
test-coverage: ## Generate test coverage report (basic)
	@echo -e "$(BLUE)Generating test coverage report...$(NC)"
	@echo -e "$(YELLOW)Note: This is a basic coverage report for shell scripts$(NC)"
	@chmod +x $(SCRIPT_NAME)
	@echo -e "$(GREEN)Script execution: $(NC)"
	@./$(SCRIPT_NAME) -h >/dev/null && echo -e "  ✓ Help function" || echo -e "  ✗ Help function"
	@./$(SCRIPT_NAME) --version >/dev/null && echo -e "  ✓ Version function" || echo -e "  ✗ Version function"
	@./$(SCRIPT_NAME) -p 1000 -r 5 -t 2 >/dev/null && echo -e "  ✓ Basic calculation" || echo -e "  ✗ Basic calculation"
	@./$(SCRIPT_NAME) -p 1000 -r 5 -t 2 -c >/dev/null && echo -e "  ✓ Compound interest" || echo -e "  ✗ Compound interest"
	@./$(SCRIPT_NAME) -p 1000 -r 5 -t 2 -f json >/dev/null && echo -e "  ✓ JSON output" || echo -e "  ✗ JSON output"

##@ Benchmarking

.PHONY: benchmark
benchmark: check-deps ## Run performance benchmarks
	@echo -e "$(BLUE)Running performance benchmarks...$(NC)"
	@chmod +x $(SCRIPT_NAME)
	@echo -e "$(YELLOW)Simple Interest Calculation (1000 iterations):$(NC)"
	@time for i in {1..1000}; do ./$(SCRIPT_NAME) -p 1000 -r 5 -t 2 >/dev/null; done
	@echo -e "$(YELLOW)Compound Interest Calculation (1000 iterations):$(NC)"
	@time for i in {1..1000}; do ./$(SCRIPT_NAME) -p 1000 -r 5 -t 2 -c >/dev/null; done
	@echo -e "$(YELLOW)JSON Output (1000 iterations):$(NC)"
	@time for i in {1..1000}; do ./$(SCRIPT_NAME) -p 1000 -r 5 -t 2 -f json >/dev/null; done

.PHONY: stress-test
stress-test: check-deps ## Run stress tests with large numbers
	@echo -e "$(BLUE)Running stress tests...$(NC)"
	@chmod +x $(SCRIPT_NAME)
	@echo -e "$(YELLOW)Testing with large numbers...$(NC)"
	@./$(SCRIPT_NAME) -p 999999999 -r 50 -t 30 -v
	@echo -e "$(YELLOW)Testing with small numbers...$(NC)"
	@./$(SCRIPT_NAME) -p 0.01 -r 0.1 -t 0.1 -v
	@echo -e "$(GREEN)Stress tests completed$(NC)"

##@ Build and Package

.PHONY: build
build: lint test ## Build the project (lint + test)
	@echo -e "$(BLUE)Building project...$(NC)"
	@mkdir -p $(BUILD_DIR)
	@cp $(SCRIPT_NAME) $(BUILD_DIR)/
	@chmod +x $(BUILD_DIR)/$(SCRIPT_NAME)
	@echo -e "$(GREEN)Build completed successfully$(NC)"

.PHONY: package
package: build ## Create distribution package
	@echo -e "$(BLUE)Creating distribution package...$(NC)"
	@mkdir -p $(DIST_DIR)
	@tar -czf $(DIST_DIR)/$(PROJECT_NAME)-$(VERSION).tar.gz \
		$(SCRIPT_NAME) README.md LICENSE CONTRIBUTING.md CODE_OF_CONDUCT tests/ docs/ Makefile
	@echo -e "$(GREEN)Package created: $(DIST_DIR)/$(PROJECT_NAME)-$(VERSION).tar.gz$(NC)"

##@ Documentation

.PHONY: docs
docs: ## Generate documentation
	@echo -e "$(BLUE)Generating documentation...$(NC)"
	@mkdir -p $(DOCS_DIR)
	@echo "# API Documentation" > $(DOCS_DIR)/API.md
	@echo "" >> $(DOCS_DIR)/API.md
	@echo "This document describes the API for the Simple Interest Calculator." >> $(DOCS_DIR)/API.md
	@echo "" >> $(DOCS_DIR)/API.md
	@echo "\`\`\`bash" >> $(DOCS_DIR)/API.md
	@./$(SCRIPT_NAME) -h >> $(DOCS_DIR)/API.md 2>/dev/null || true
	@echo "\`\`\`" >> $(DOCS_DIR)/API.md
	@echo -e "$(GREEN)Documentation generated in $(DOCS_DIR)/$(NC)"

##@ Maintenance

.PHONY: clean
clean: ## Clean build artifacts and temporary files
	@echo -e "$(BLUE)Cleaning build artifacts...$(NC)"
	@rm -rf $(BUILD_DIR) $(DIST_DIR)
	@find . -name "*.tmp" -delete 2>/dev/null || true
	@find . -name "*.bak" -delete 2>/dev/null || true
	@echo -e "$(GREEN)Cleanup completed$(NC)"

.PHONY: clean-all
clean-all: clean ## Clean everything including docs
	@echo -e "$(BLUE)Cleaning all generated files...$(NC)"
	@rm -rf $(DOCS_DIR)
	@echo -e "$(GREEN)Deep cleanup completed$(NC)"

##@ CI/CD

.PHONY: ci
ci: lint test benchmark ## Run full CI pipeline
	@echo -e "$(BLUE)Running CI pipeline...$(NC)"
	@echo -e "$(GREEN)CI pipeline completed successfully$(NC)"

.PHONY: validate
validate: format-check lint test ## Validate code quality and functionality
	@echo -e "$(BLUE)Validating code quality...$(NC)"
	@echo -e "$(GREEN)Validation completed successfully$(NC)"

##@ Security

.PHONY: security-scan
security-scan: ## Run basic security checks
	@echo -e "$(BLUE)Running security checks...$(NC)"
	@echo -e "$(YELLOW)Checking for potential security issues...$(NC)"
	@grep -n "eval\|exec\|system\|\$(" $(SCRIPT_NAME) || echo -e "$(GREEN)No obvious security issues found$(NC)"
	@echo -e "$(YELLOW)Checking file permissions...$(NC)"
	@ls -la $(SCRIPT_NAME)
	@echo -e "$(GREEN)Security scan completed$(NC)"

##@ Docker

.PHONY: docker-build
docker-build: ## Build Docker image
	@echo -e "$(BLUE)Building Docker image...$(NC)"
	@docker build -t $(PROJECT_NAME):$(VERSION) .
	@docker build -t $(PROJECT_NAME):latest .
	@echo -e "$(GREEN)Docker image built successfully$(NC)"

.PHONY: docker-build-dev
docker-build-dev: ## Build development Docker image
	@echo -e "$(BLUE)Building development Docker image...$(NC)"
	@docker build --target development -t $(PROJECT_NAME):dev .
	@echo -e "$(GREEN)Development Docker image built successfully$(NC)"

.PHONY: docker-test
docker-test: ## Test Docker image functionality
	@echo -e "$(BLUE)Testing Docker image...$(NC)"
	@docker run --rm $(PROJECT_NAME):latest -p 1000 -r 5 -t 2
	@echo -e "$(GREEN)Docker image test completed$(NC)"

.PHONY: docker-run
docker-run: ## Run Docker container interactively
	@echo -e "$(BLUE)Running Docker container...$(NC)"
	@docker run --rm -it $(PROJECT_NAME):latest

.PHONY: docker-dev
docker-dev: ## Run development Docker container
	@echo -e "$(BLUE)Starting development environment...$(NC)"
	@docker run --rm -it -v "$(PWD)":/workspace $(PROJECT_NAME):dev

.PHONY: docker-clean
docker-clean: ## Remove Docker images
	@echo -e "$(BLUE)Cleaning Docker images...$(NC)"
	@docker rmi $(PROJECT_NAME):$(VERSION) $(PROJECT_NAME):latest $(PROJECT_NAME):dev 2>/dev/null || true
	@echo -e "$(GREEN)Docker cleanup completed$(NC)"

# Development shortcuts
.PHONY: dev
dev: lint test ## Quick development cycle (lint + test)

.PHONY: check
check: format-check lint test ## Check code quality

# Help target should be default
.DEFAULT_GOAL := help