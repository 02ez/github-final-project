#!/bin/bash

# Repository Cleanup Script
# This script performs administrative cleanup tasks for the GitHub repository

set -e  # Exit on any error

echo "Starting repository cleanup..."

# 1. Close all Dependabot PRs
echo "Closing all Dependabot PRs..."
if command -v gh >/dev/null 2>&1; then
    dependabot_prs=$(gh pr list --author dependabot --json number -q '.[].number' 2>/dev/null || echo "")
    if [ -n "$dependabot_prs" ] && [ "$dependabot_prs" != "null" ]; then
        echo "$dependabot_prs" | xargs -I {} gh pr close {}
        echo "Closed Dependabot PRs: $dependabot_prs"
    else
        echo "No Dependabot PRs found to close"
    fi
else
    echo "GitHub CLI (gh) not found. Please install it to close Dependabot PRs."
fi

# 2. Delete failing workflow runs for "Running Copilot"
echo "Deleting failing workflow runs for 'Running Copilot'..."
if command -v gh >/dev/null 2>&1; then
    failing_runs=$(gh run list --workflow "Running Copilot" --json databaseId -q '.[].databaseId' 2>/dev/null || echo "")
    if [ -n "$failing_runs" ] && [ "$failing_runs" != "null" ]; then
        echo "$failing_runs" | xargs -I {} gh run delete {}
        echo "Deleted workflow runs: $failing_runs"
    else
        echo "No 'Running Copilot' workflow runs found to delete"
    fi
else
    echo "GitHub CLI (gh) not found. Please install it to delete workflow runs."
fi

# 3. Disable problematic workflows
echo "Disabling problematic workflows..."
if command -v gh >/dev/null 2>&1; then
    for workflow in "Complete enterprise transformation" "Implement Phase 2" "Implement Phase 3"; do
        echo "Attempting to disable workflow: $workflow"
        if gh workflow disable "$workflow" 2>/dev/null; then
            echo "Successfully disabled workflow: $workflow"
        else
            echo "Workflow '$workflow' not found or already disabled"
        fi
    done
else
    echo "GitHub CLI (gh) not found. Please install it to disable workflows."
fi

echo "Repository cleanup completed successfully!"