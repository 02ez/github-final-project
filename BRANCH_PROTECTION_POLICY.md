# Branch Protection Policy Configuration

## GitHub CLI Commands to Enable Branch Protection

```bash
# Set up branch protection for main branch
gh api repos/02ez/github-final-project/branches/main/protection -X PUT \
  -f required_status_checks='{"strict":true,"contexts":["build-test-lint","security-scan","supply-chain"]}' \
  -f enforce_admins=true \
  -f required_pull_request_reviews='{"required_approving_review_count":2,"dismiss_stale_reviews":true,"require_code_owner_reviews":true,"restrict_dismissals":true}' \
  -f restrictions=null \
  -f allow_force_pushes=false \
  -f allow_deletions=false

# Enable vulnerability alerts
gh api repos/02ez/github-final-project/vulnerability-alerts -X PUT

# Enable automated security fixes
gh api repos/02ez/github-final-project/automated-security-fixes -X PUT

# Enable dependency graph
gh api repos/02ez/github-final-project -X PATCH -f has_vulnerability_alerts=true

# Configure merge options
gh api repos/02ez/github-final-project -X PATCH \
  -f allow_merge_commit=false \
  -f allow_squash_merge=true \
  -f allow_rebase_merge=false \
  -f delete_branch_on_merge=true
```

## Policy JSON Configuration

```json
{
  "required_status_checks": {
    "strict": true,
    "contexts": [
      "build-test-lint",
      "security-scan",
      "supply-chain"
    ]
  },
  "enforce_admins": true,
  "required_pull_request_reviews": {
    "required_approving_review_count": 2,
    "dismiss_stale_reviews": true,
    "require_code_owner_reviews": true,
    "restrict_dismissals": true,
    "dismissal_restrictions": {
      "users": [],
      "teams": ["security-team"]
    }
  },
  "restrictions": null,
  "allow_force_pushes": false,
  "allow_deletions": false
}
```

## Commit Signing Configuration

```bash
# Configure commit signing globally
git config --global commit.gpgsign true
git config --global tag.gpgSign true
git config --global user.signingkey [GPG_KEY_ID]

# Enable DCO (Developer Certificate of Origin)
git config --global trailer.dco.key "Signed-off-by"
git config --global trailer.dco.ifExists doNothing
git config --global trailer.dco.command 'echo "$(git config user.name) <$(git config user.email)>"'

# Configure automatic DCO signing
git config --global alias.dco-commit 'commit --signoff'
```

## Repository Settings

### Security Settings
- [x] Vulnerability alerts enabled
- [x] Dependabot alerts enabled
- [x] Dependabot security updates enabled
- [x] Dependency graph enabled
- [x] Secret scanning enabled
- [x] Code scanning enabled

### Access Settings
- [x] Restrict pushes to main branch
- [x] Require pull request reviews before merging
- [x] Require status checks to pass before merging
- [x] Require branches to be up to date before merging
- [x] Require conversation resolution before merging
- [x] Include administrators in restrictions

### Merge Settings
- [x] Allow squash merging
- [ ] Allow merge commits
- [ ] Allow rebase merging
- [x] Automatically delete head branches