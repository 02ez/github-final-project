#!/usr/bin/env bats

# Test suite for cleanup.sh script
# Validates the cleanup script functionality

@test "cleanup script exists and is executable" {
    [ -f ./cleanup.sh ]
    [ -x ./cleanup.sh ]
}

@test "cleanup script runs without errors" {
    run ./cleanup.sh
    [ "$status" -eq 0 ]
    [[ "$output" == *"Starting repository cleanup"* ]]
    [[ "$output" == *"Repository cleanup completed successfully"* ]]
}

@test "cleanup script can be run via Makefile" {
    run make cleanup
    [ "$status" -eq 0 ]
    [[ "$output" == *"Running repository cleanup"* ]]
    [[ "$output" == *"Repository cleanup completed successfully"* ]]
}

@test "cleanup script contains all required functionality" {
    # Check that the script contains the expected commands
    run grep -q "dependabot" ./cleanup.sh
    [ "$status" -eq 0 ]
    run grep -q "Running Copilot" ./cleanup.sh
    [ "$status" -eq 0 ]
    run grep -q "Complete enterprise transformation" ./cleanup.sh
    [ "$status" -eq 0 ]
}