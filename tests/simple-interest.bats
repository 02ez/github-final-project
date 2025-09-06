#!/usr/bin/env bats
# 
# Comprehensive test suite for simple-interest.sh
# Tests backward compatibility, new features, edge cases, and error handling
#

setup() {
    # Get script directory
    SCRIPT_DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" && pwd )/.."
    SCRIPT="$SCRIPT_DIR/simple-interest.sh"
    
    # Ensure script is executable
    chmod +x "$SCRIPT"
    
    # Set test environment
    export LC_ALL=C
}

# Backward Compatibility Tests
@test "backward compatibility: original test case -p 1000 -r 5 -t 2" {
    run "$SCRIPT" -p 1000 -r 5 -t 2
    [ "$status" -eq 0 ]
    [[ "$output" == *"Simple interest: 100.00"* ]]
    [[ "$output" == *"Total amount: 1100.00"* ]]
}

@test "backward compatibility: floating point principal" {
    run "$SCRIPT" -p 1000.50 -r 5 -t 2
    [ "$status" -eq 0 ]
    [[ "$output" == *"Simple interest: 100.05"* ]]
}

@test "backward compatibility: floating point rate" {
    run "$SCRIPT" -p 1000 -r 5.5 -t 2
    [ "$status" -eq 0 ]
    [[ "$output" == *"Simple interest: 110.00"* ]]
}

@test "backward compatibility: floating point time" {
    run "$SCRIPT" -p 1000 -r 5 -t 2.5
    [ "$status" -eq 0 ]
    [[ "$output" == *"Simple interest: 125.00"* ]]
}

# Core Functionality Tests
@test "simple interest calculation: basic case" {
    run "$SCRIPT" -p 1000 -r 5 -t 2
    [ "$status" -eq 0 ]
    [[ "$output" == *"Simple interest: 100.00"* ]]
    [[ "$output" == *"Total amount: 1100.00"* ]]
}

@test "simple interest calculation: larger amounts" {
    run "$SCRIPT" -p 50000 -r 3.5 -t 10
    [ "$status" -eq 0 ]
    [[ "$output" == *"Simple interest: 17500.00"* ]]
    [[ "$output" == *"Total amount: 67500.00"* ]]
}

@test "compound interest calculation" {
    run "$SCRIPT" -p 1000 -r 5 -t 2 -c
    [ "$status" -eq 0 ]
    [[ "$output" == *"Compound Interest: \$102.50"* ]]
    [[ "$output" == *"Total Amount: \$1102.50"* ]]
}

# Output Format Tests
@test "JSON output format" {
    run "$SCRIPT" -p 1000 -r 5 -t 2 -f json
    [ "$status" -eq 0 ]
    # Check JSON structure
    [[ "$output" == *'"principal": 1000'* ]]
    [[ "$output" == *'"rate": 5'* ]]
    [[ "$output" == *'"time": 2'* ]]
    [[ "$output" == *'"interest": 100.00'* ]]
    [[ "$output" == *'"total": 1100.00'* ]]
}

@test "CSV output format" {
    run "$SCRIPT" -p 1000 -r 5 -t 2 -f csv
    [ "$status" -eq 0 ]
    # Check CSV headers and data
    [[ "$output" == *"principal,rate,time,currency,mode,interest,total,timestamp"* ]]
    [[ "$output" == *"1000,5,2,USD,Simple Interest,100.00,1100.00"* ]]
}

# Currency Formatting Tests
@test "USD currency formatting" {
    run "$SCRIPT" -p 1000 -r 5 -t 2 -u USD
    [ "$status" -eq 0 ]
    [[ "$output" == *'$1000.00'* ]]
}

@test "EUR currency formatting" {
    run "$SCRIPT" -p 1000 -r 5 -t 2 -u EUR
    [ "$status" -eq 0 ]
    [[ "$output" == *'€1000.00'* ]]
}

# Error Handling Tests
@test "error: missing principal parameter" {
    run "$SCRIPT" -r 5 -t 2
    [ "$status" -eq 1 ]
    [[ "$output" == *"Missing required parameters"* ]]
}

@test "error: negative principal" {
    run "$SCRIPT" -p -1000 -r 5 -t 2
    [ "$status" -eq 1 ]
    [[ "$output" == *"must be positive"* ]]
}

@test "error: zero principal" {
    run "$SCRIPT" -p 0 -r 5 -t 2
    [ "$status" -eq 1 ]
    [[ "$output" == *"must be positive"* ]]
}

@test "error: invalid number format" {
    run "$SCRIPT" -p abc -r 5 -t 2
    [ "$status" -eq 1 ]
    [[ "$output" == *"not a valid number"* ]]
}

# Help and Version Tests
@test "help option displays usage" {
    run "$SCRIPT" -h
    [ "$status" -eq 0 ]
    [[ "$output" == *"Simple Interest Calculator"* ]]
    [[ "$output" == *"USAGE:"* ]]
    [[ "$output" == *"EXAMPLES:"* ]]
}

@test "version option displays version" {
    run "$SCRIPT" --version
    [ "$status" -eq 0 ]
    [[ "$output" == *"simple-interest.sh v"* ]]
    [[ "$output" == *"Copyright"* ]]
    [[ "$output" == *"Apache License"* ]]
}

# Mathematical Accuracy Tests
@test "mathematical accuracy: simple interest formula verification" {
    # Test SI = (P * R * T) / 100 with known values
    run "$SCRIPT" -p 2000 -r 8 -t 3
    [ "$status" -eq 0 ]
    # SI = (2000 * 8 * 3) / 100 = 480
    [[ "$output" == *"Simple interest: 480.00"* ]]
    [[ "$output" == *"Total amount: 2480.00"* ]]
}

# Compatibility Tests
@test "compatibility: POSIX compliance check" {
    # Basic POSIX shell compatibility test
    run bash -n "$SCRIPT"
    [ "$status" -eq 0 ]
}
