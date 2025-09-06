# Git Final Project Assignment Documentation

This document outlines the Git workflow commands executed for the final project assignment.

## Commands Executed in Order:

### 1. Fork and clone repository
```bash
gh repo fork https://github.com/mcino/Introduction-to-Git-and-GitHub --clone
cd Introduction-to-Git-and-GitHub
```

### 2. Create fix branch and change year (2022 → 2023)
```bash
git checkout -b bug-fix-typo
sed -i 's/2022 XYZ, Inc./2023 XYZ, Inc./g' README.md
git add README.md
git commit -m "fix: update copyright year to 2023"
git push origin bug-fix-typo
```

### 3. Merge to main
```bash
git checkout main
git merge bug-fix-typo --no-ff -m "merge: bug-fix-typo into main"
git push origin main
```

### 4. Create merge evidence
```bash
echo "Current branch: $(git branch --show-current)" > merge_branches.txt
git log --oneline -n 5 >> merge_branches.txt
```

### 5. Create revert branch
```bash
git checkout -b bug-fix-revert
git revert HEAD --no-edit
git push origin bug-fix-revert
```

### 6. Create PR to upstream
```bash
gh pr create --repo mcino/Introduction-to-Git-and-GitHub \
  --head 02ez:bug-fix-revert --base main \
  --title "revert: restore copyright to 2022" \
  --body "Reverting per assignment requirements"
```

### 7. Save URLs
```bash
echo "Fork: https://github.com/02ez/Introduction-to-Git-and-GitHub" > submission_urls.txt
echo "Branches: https://github.com/02ez/Introduction-to-Git-and-GitHub/branches" >> submission_urls.txt
echo "PR: [@02ez/github-final-project/pull/2]" >> submission_urls.txt
```

## Key Changes Made:
- Changed copyright year from 2022 to 2023 in README.md
- Created bug-fix-typo branch for the change
- Merged changes to main using --no-ff flag
- Created revert branch to undo the changes
- Created PR to upstream repository
- Generated evidence files documenting the workflow

## Files Created:
- `merge_branches.txt` - Contains branch information and commit history
- `submission_urls.txt` - Contains URLs for fork, branches, and PR
- `git_workflow_documentation.md` - This documentation file