.PHONY: test lint install clean help

# Default target
help:
	@echo "Available targets:"
	@echo "  test     - Run BATS tests"
	@echo "  lint     - Run shellcheck on scripts"
	@echo "  install  - Install dependencies (bats, shellcheck)"
	@echo "  clean    - Clean temporary files"
	@echo "  help     - Show this help message"

# Run tests using BATS
test:
	@echo "Running BATS tests..."
	@if command -v bats >/dev/null 2>&1; then \
		bats test/; \
	else \
		echo "BATS not found. Run 'make install' to install dependencies."; \
		exit 1; \
	fi

# Lint shell scripts
lint:
	@echo "Running shellcheck..."
	@if command -v shellcheck >/dev/null 2>&1; then \
		shellcheck simple-interest.sh; \
		echo "Linting completed."; \
	else \
		echo "shellcheck not found. Run 'make install' to install dependencies."; \
		exit 1; \
	fi

# Install dependencies (Ubuntu/Debian)
install:
	@echo "Installing dependencies..."
	@if command -v apt-get >/dev/null 2>&1; then \
		sudo apt-get update && sudo apt-get install -y bats shellcheck bc; \
	elif command -v brew >/dev/null 2>&1; then \
		brew install bats-core shellcheck bc; \
	else \
		echo "Package manager not supported. Please install bats, shellcheck, and bc manually."; \
	fi

# Clean temporary files
clean:
	@echo "Cleaning temporary files..."
	@find . -name "*.tmp" -delete 2>/dev/null || true
	@echo "Clean completed."