#!/bin/bash
# Simple Interest Calculator
# Production-ready Bash CLI tool for computing simple and compound interest
# 
# Copyright (c) 2024 github-final-project contributors
# Licensed under the Apache License, Version 2.0
#
# Usage: ./simple-interest.sh -p <principal> -r <rate_%> -t <years> [options]
# Example: ./simple-interest.sh -p 1000 -r 5 -t 2
#
# For more information, see docs/API.md

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Script metadata
readonly SCRIPT_NAME="simple-interest.sh"
readonly SCRIPT_VERSION="1.0.0"
readonly SCRIPT_AUTHOR="github-final-project contributors"

# Default values
P=""
R=""
T=""
COMPOUND_MODE=false
OUTPUT_FORMAT="text"
CURRENCY="USD"
INTERACTIVE_MODE=false
HELP_MODE=false
VERSION_MODE=false
VERBOSE=false

# Color codes for output formatting
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Logging functions
log_info() {
    if [[ "$VERBOSE" == true ]]; then
        echo -e "${BLUE}[INFO]${NC} $*" >&2
    fi
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $*" >&2
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $*" >&2
}

# Help function
show_help() {
    cat << EOF
$SCRIPT_NAME v$SCRIPT_VERSION - Simple Interest Calculator

USAGE:
    $SCRIPT_NAME -p <principal> -r <rate_%> -t <years> [options]

REQUIRED ARGUMENTS:
    -p <principal>    Principal amount (positive number)
    -r <rate_%>       Annual interest rate as percentage (positive number)
    -t <years>        Time period in years (positive number)

OPTIONS:
    -c                Enable compound interest mode
    -f <format>       Output format: text, json, csv (default: text)
    -u <currency>     Currency code for formatting (default: USD)
    -i                Interactive mode with prompts
    -v                Verbose output
    -h                Show this help message
    --version         Show version information

EXAMPLES:
    $SCRIPT_NAME -p 1000 -r 5 -t 2
    $SCRIPT_NAME -p 5000 -r 3.5 -t 10 -c -f json
    $SCRIPT_NAME -i

FINANCIAL FORMULAS:
    Simple Interest:   SI = (P * R * T) / 100
    Compound Interest: CI = P * (1 + R/100)^T - P
    
For detailed documentation, visit: docs/API.md
EOF
}

# Version function
show_version() {
    cat << EOF
$SCRIPT_NAME v$SCRIPT_VERSION
Copyright (c) 2024 $SCRIPT_AUTHOR
Licensed under the Apache License, Version 2.0

Build info:
- Shell: $BASH_VERSION
- Platform: $(uname -s) $(uname -m)
- Date: $(date -u +"%Y-%m-%d %H:%M:%S UTC")
EOF
}

# Input validation functions
validate_positive_number() {
    local value="$1"
    local param_name="$2"
    
    # Check if it's a valid number (including negative numbers for proper error handling)
    if ! [[ "$value" =~ ^-?[0-9]+\.?[0-9]*$ ]] && ! [[ "$value" =~ ^-?[0-9]*\.?[0-9]+$ ]]; then
        log_error "Invalid $param_name: '$value' is not a valid number"
        return 1
    fi
    
    # Check if it's positive
    if (( $(echo "$value <= 0" | bc -l) )); then
        log_error "Invalid $param_name: '$value' must be positive"
        return 1
    fi
    
    return 0
}

# Dependency check
check_dependencies() {
    local missing_deps=()
    
    if ! command -v bc >/dev/null 2>&1; then
        missing_deps+=("bc")
    fi
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        log_error "Missing required dependencies: ${missing_deps[*]}"
        log_error "Please install them using your package manager:"
        log_error "  Ubuntu/Debian: sudo apt-get install bc"
        log_error "  CentOS/RHEL:   sudo yum install bc"
        log_error "  macOS:         brew install bc"
        exit 1
    fi
}

# Currency formatting function
format_currency() {
    local amount="$1"
    local currency="$2"
    
    case "$currency" in
        USD) echo "\$$(printf "%.2f" "$amount")" ;;
        EUR) echo "€$(printf "%.2f" "$amount")" ;;
        GBP) echo "£$(printf "%.2f" "$amount")" ;;
        JPY) echo "¥$(printf "%.0f" "$amount")" ;;
        INR) echo "₹$(printf "%.2f" "$amount")" ;;
        *) echo "$(printf "%.2f" "$amount") $currency" ;;
    esac
}

# Interactive mode function
interactive_mode() {
    echo "=== Simple Interest Calculator - Interactive Mode ==="
    echo
    
    while true; do
        read -p "Enter principal amount: " P
        if validate_positive_number "$P" "principal"; then
            break
        fi
    done
    
    while true; do
        read -p "Enter annual interest rate (%): " R
        if validate_positive_number "$R" "rate"; then
            break
        fi
    done
    
    while true; do
        read -p "Enter time period (years): " T
        if validate_positive_number "$T" "time"; then
            break
        fi
    done
    
    read -p "Use compound interest? (y/N): " compound_choice
    if [[ "$compound_choice" =~ ^[Yy]$ ]]; then
        COMPOUND_MODE=true
    fi
    
    read -p "Currency code (default: USD): " currency_input
    if [[ -n "$currency_input" ]]; then
        CURRENCY="$currency_input"
    fi
    
    echo
}

# Calculation functions
calculate_simple_interest() {
    local principal="$1"
    local rate="$2"
    local time="$3"
    
    echo "scale=2; ($principal * $rate * $time) / 100" | bc
}

calculate_compound_interest() {
    local principal="$1"
    local rate="$2"
    local time="$3"
    
    # CI = P * (1 + R/100)^T - P
    local compound_amount
    compound_amount=$(echo "scale=10; $principal * e($time * l(1 + $rate/100))" | bc -l)
    echo "scale=2; $compound_amount - $principal" | bc
}

# Output formatting functions
output_text() {
    local principal="$1"
    local rate="$2"
    local time="$3"
    local interest="$4"
    local total="$5"
    local mode="$6"
    
    echo "=== Interest Calculation Results ==="
    echo "Principal Amount: $(format_currency "$principal" "$CURRENCY")"
    echo "Interest Rate: $rate% per annum"
    echo "Time Period: $time years"
    echo "Calculation Mode: $mode"
    echo "---"
    echo "$mode: $(format_currency "$interest" "$CURRENCY")"
    echo "Total Amount: $(format_currency "$total" "$CURRENCY")"
}

output_json() {
    local principal="$1"
    local rate="$2"
    local time="$3"
    local interest="$4"
    local total="$5"
    local mode="$6"
    
    cat << EOF
{
  "calculation": {
    "principal": $principal,
    "rate": $rate,
    "time": $time,
    "currency": "$CURRENCY",
    "mode": "$mode"
  },
  "results": {
    "interest": $interest,
    "total": $total
  },
  "metadata": {
    "script_version": "$SCRIPT_VERSION",
    "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
    "formula": "$([ "$COMPOUND_MODE" = true ] && echo "P * (1 + R/100)^T - P" || echo "(P * R * T) / 100")"
  }
}
EOF
}

output_csv() {
    local principal="$1"
    local rate="$2"
    local time="$3"
    local interest="$4"
    local total="$5"
    local mode="$6"
    
    echo "principal,rate,time,currency,mode,interest,total,timestamp"
    echo "$principal,$rate,$time,$CURRENCY,$mode,$interest,$total,$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
}

# Main calculation function
calculate_interest() {
    local principal="$1"
    local rate="$2"
    local time="$3"
    
    log_info "Starting calculation with P=$principal, R=$rate%, T=$time years"
    log_info "Mode: $([ "$COMPOUND_MODE" = true ] && echo "Compound" || echo "Simple") Interest"
    
    local interest total mode
    
    if [[ "$COMPOUND_MODE" == true ]]; then
        interest=$(calculate_compound_interest "$principal" "$rate" "$time")
        mode="Compound Interest"
    else
        interest=$(calculate_simple_interest "$principal" "$rate" "$time")
        mode="Simple Interest"
    fi
    
    total=$(echo "scale=2; $principal + $interest" | bc)
    
    log_info "Calculation completed successfully"
    
    case "$OUTPUT_FORMAT" in
        json) output_json "$principal" "$rate" "$time" "$interest" "$total" "$mode" ;;
        csv) output_csv "$principal" "$rate" "$time" "$interest" "$total" "$mode" ;;
        *) output_text "$principal" "$rate" "$time" "$interest" "$total" "$mode" ;;
    esac
}

# Main function
main() {
    # Check dependencies first
    check_dependencies
    
    # Parse command line arguments
    while getopts "p:r:t:cf:u:ivh-:" opt; do
        case $opt in
            p) P="$OPTARG" ;;
            r) R="$OPTARG" ;;
            t) T="$OPTARG" ;;
            c) COMPOUND_MODE=true ;;
            f) OUTPUT_FORMAT="$OPTARG" ;;
            u) CURRENCY="$OPTARG" ;;
            i) INTERACTIVE_MODE=true ;;
            v) VERBOSE=true ;;
            h) HELP_MODE=true ;;
            -)
                case "${OPTARG}" in
                    version) VERSION_MODE=true ;;
                    *) log_error "Unknown option --${OPTARG}"; exit 1 ;;
                esac
                ;;
            \?) log_error "Invalid option: -$OPTARG"; exit 1 ;;
            :) log_error "Option -$OPTARG requires an argument"; exit 1 ;;
        esac
    done
    
    # Handle special modes
    if [[ "$VERSION_MODE" == true ]]; then
        show_version
        exit 0
    fi
    
    if [[ "$HELP_MODE" == true ]]; then
        show_help
        exit 0
    fi
    
    # Interactive mode
    if [[ "$INTERACTIVE_MODE" == true ]]; then
        interactive_mode
    fi
    
    # Validate required parameters
    if [[ -z "$P" || -z "$R" || -z "$T" ]]; then
        log_error "Missing required parameters. Use -h for help."
        if [[ "$INTERACTIVE_MODE" != true ]]; then
            log_error "Required: -p <principal> -r <rate> -t <time>"
            exit 1
        fi
    fi
    
    # Validate input values
    validate_positive_number "$P" "principal" || exit 1
    validate_positive_number "$R" "rate" || exit 1
    validate_positive_number "$T" "time" || exit 1
    
    # Validate output format
    case "$OUTPUT_FORMAT" in
        text|json|csv) ;;
        *) log_error "Invalid output format: $OUTPUT_FORMAT (must be: text, json, csv)"; exit 1 ;;
    esac
    
    # Perform calculation
    calculate_interest "$P" "$R" "$T"
}

# Backward compatibility: if script is called with old parameters, use simple mode
if [[ $# -eq 6 && "$1" == "-p" && "$3" == "-r" && "$5" == "-t" ]]; then
    log_info "Detected legacy parameter format, using simple interest mode"
    P="$2"
    R="$4"
    T="$6"
    
    # Validate legacy format inputs
    validate_positive_number "$P" "principal" || exit 1
    validate_positive_number "$R" "rate" || exit 1
    validate_positive_number "$T" "time" || exit 1
    
    # Calculate using legacy format for exact compatibility
    SI=$(echo "scale=2; ($P * $R * $T) / 100" | bc)
    TOTAL=$(echo "scale=2; $P + $SI" | bc)
    echo "Simple interest: $SI"
    echo "Total amount: $TOTAL"
    exit 0
fi

# Run main function for all other cases
main "$@"