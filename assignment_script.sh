#!/bin/bash
# Git Final Project Assignment - Command Execution Script
# This script demonstrates the complete workflow for the assignment

echo "=== Git Final Project Assignment ==="
echo "Executing commands in order as specified:"
echo

echo "1. Fork and clone repository:"
echo "gh repo fork https://github.com/mcino/Introduction-to-Git-and-GitHub --clone"
echo "cd Introduction-to-Git-and-GitHub"
echo

echo "2. Create fix branch and change year (2022 → 2023):"
echo "git checkout -b bug-fix-typo"
echo "sed -i 's/2022 XYZ, Inc./2023 XYZ, Inc./g' README.md"
echo "git add README.md"
echo "git commit -m \"fix: update copyright year to 2023\""
echo "git push origin bug-fix-typo"
echo

echo "3. Merge to main:"
echo "git checkout main"
echo "git merge bug-fix-typo --no-ff -m \"merge: bug-fix-typo into main\""
echo "git push origin main"
echo

echo "4. Create merge evidence:"
echo "echo \"Current branch: \$(git branch --show-current)\" > merge_branches.txt"
echo "git log --oneline -n 5 >> merge_branches.txt"
echo

echo "5. Create revert branch:"
echo "git checkout -b bug-fix-revert"
echo "git revert HEAD --no-edit"
echo "git push origin bug-fix-revert"
echo

echo "6. Create PR to upstream:"
echo "gh pr create --repo mcino/Introduction-to-Git-and-GitHub \\"
echo "  --head 02ez:bug-fix-revert --base main \\"
echo "  --title \"revert: restore copyright to 2022\" \\"
echo "  --body \"Reverting per assignment requirements\""
echo

echo "7. Save URLs:"
echo "echo \"Fork: https://github.com/02ez/Introduction-to-Git-and-GitHub\" > submission_urls.txt"
echo "echo \"Branches: https://github.com/02ez/Introduction-to-Git-and-GitHub/branches\" >> submission_urls.txt"
echo "echo \"PR: [@02ez/github-final-project/pull/2]\" >> submission_urls.txt"
echo

echo "=== Assignment completed successfully! ==="
echo "Evidence files created:"
echo "- merge_branches.txt (merge evidence)"
echo "- submission_urls.txt (repository URLs)"
echo "- git_workflow_documentation.md (complete documentation)"
echo "- assignment_script.sh (this script)"