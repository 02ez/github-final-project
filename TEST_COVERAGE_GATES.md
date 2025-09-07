# Test Coverage and Quality Gates

## Test Execution Commands

```bash
# Run all tests
make test

# Run tests with verbose output
bats -t test/

# Run specific test
bats test/simple-interest.bats

# Run linting
make lint
shellcheck simple-interest.sh

# Run security tests
trivy fs --exit-code 1 --severity HIGH,CRITICAL .
semgrep ci
```

## Coverage Gate Script

```bash
#!/bin/bash
# coverage-gate.sh

set -euo pipefail

COVERAGE_MIN=${COVERAGE_MIN:-80}
TEST_RESULTS_FILE="test-results.xml"
COVERAGE_FILE="coverage.json"

echo "Running test coverage analysis..."

# For shell scripts, calculate test coverage based on functionality coverage
echo "Calculating functional test coverage..."

# Count total functions/features in the script
TOTAL_FUNCTIONS=$(grep -c "getopts\|echo\|bc" simple-interest.sh || echo "3")

# Count tests that cover each function
COVERED_FUNCTIONS=0

# Check if parameter parsing is tested
if bats test/ | grep -q "getopts"; then
    ((COVERED_FUNCTIONS++))
fi

# Check if calculation is tested
if bats test/ | grep -q "Simple interest"; then
    ((COVERED_FUNCTIONS++))
fi

# Check if output format is tested
if bats test/ | grep -q "Total amount"; then
    ((COVERED_FUNCTIONS++))
fi

# Calculate coverage percentage
COVERAGE=$((COVERED_FUNCTIONS * 100 / TOTAL_FUNCTIONS))

echo "Test coverage: $COVERAGE% ($COVERED_FUNCTIONS/$TOTAL_FUNCTIONS functions covered)"

# Check coverage gate
if [ "$COVERAGE" -lt "$COVERAGE_MIN" ]; then
    echo "❌ Coverage $COVERAGE% is below minimum $COVERAGE_MIN%"
    exit 1
fi

echo "✅ Coverage gate passed: $COVERAGE%"

# Generate coverage report
cat > "$COVERAGE_FILE" << EOF
{
  "coverage": $COVERAGE,
  "covered_functions": $COVERED_FUNCTIONS,
  "total_functions": $TOTAL_FUNCTIONS,
  "threshold": $COVERAGE_MIN,
  "status": "passed"
}
EOF

echo "Coverage report written to $COVERAGE_FILE"
```

## Quality Gates

### Code Quality
- Shellcheck must pass with no warnings
- Script must be executable and properly formatted
- All functions must have corresponding tests

### Security Quality
- No HIGH or CRITICAL vulnerabilities in Trivy scan
- No secrets detected by TruffleHog
- Semgrep security rules must pass

### Performance Quality
- Script execution time < 1 second
- Memory usage < 10MB
- Container startup time < 5 seconds

### Documentation Quality
- All public functions documented
- README up to date
- CHANGELOG updated for releases

## Automated Quality Checks

```yaml
# Quality gate configuration for CI/CD
quality_gates:
  code_coverage:
    minimum: 80
    fail_below: true
  
  security:
    max_critical_vulnerabilities: 0
    max_high_vulnerabilities: 0
    fail_on_secrets: true
  
  performance:
    max_execution_time_ms: 1000
    max_memory_mb: 10
  
  documentation:
    require_changelog: true
    require_readme_update: true
```