#!/usr/bin/env bats

# Test suite for simple-interest.sh
# Validates exact output for core functionality

@test "base case: 1000 principal, 5% rate, 2 years" {
    run ./simple-interest.sh -p 1000 -r 5 -t 2
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "Simple interest: 100.00" ]
    [ "${lines[1]}" = "Total amount: 1100.00" ]
}

@test "zero rate case: 1000 principal, 0% rate, 2 years" {
    run ./simple-interest.sh -p 1000 -r 0 -t 2
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "Simple interest: 0" ]
    [ "${lines[1]}" = "Total amount: 1000" ]
}

@test "multi-year case: 1500 principal, 3.5% rate, 4 years" {
    run ./simple-interest.sh -p 1500 -r 3.5 -t 4
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "Simple interest: 210.00" ]
    [ "${lines[1]}" = "Total amount: 1710.00" ]
}

@test "edge case: non-integer rate with percent conversion" {
    run ./simple-interest.sh -p 2000 -r 2.25 -t 3
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "Simple interest: 135.00" ]
    [ "${lines[1]}" = "Total amount: 2135.00" ]
}