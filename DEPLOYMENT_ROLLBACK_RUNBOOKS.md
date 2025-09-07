# Deployment and Rollback Runbooks

## Deployment Runbook

### Pre-Deployment Checklist
- [ ] All CI/CD checks passing
- [ ] Security scans complete with no critical issues
- [ ] Code owners have approved
- [ ] SBOM generated and verified
- [ ] Container images signed
- [ ] Deployment approval obtained
- [ ] Sleep gate requirements met (>6 hours rest)

### Deployment Process

#### Development Environment
```bash
# Automated deployment triggered by push to main
# No manual intervention required
# Monitors: GitHub Actions workflow
```

#### Staging Environment
```bash
# Triggered by tag creation or manual dispatch
# 1. Checkout code
git checkout tags/v1.0.0

# 2. Deploy to staging
kubectl apply -f k8s/staging/

# 3. Verify deployment
kubectl rollout status deployment/simple-interest -n staging

# 4. Run integration tests
./scripts/integration-tests.sh staging

# 5. Monitor for 10 minutes
./scripts/monitor-health.sh staging 600
```

#### Production Environment
```bash
# Requires manual approval in GitHub Actions
# 1. Pre-deployment validation
./scripts/pre-deploy-validation.sh prod

# 2. Canary deployment (10% traffic)
kubectl apply -f k8s/prod/canary.yaml

# 3. Monitor canary metrics (5 minutes)
./scripts/monitor-canary.sh 300

# 4. Full deployment if canary healthy
kubectl apply -f k8s/prod/full.yaml

# 5. Post-deployment verification
./scripts/post-deploy-verification.sh prod
```

### Deployment Verification

```bash
#!/bin/bash
# verify-deployment.sh

ENVIRONMENT=$1
EXPECTED_VERSION=$2

echo "Verifying deployment in $ENVIRONMENT..."

# Check service health
HEALTH_STATUS=$(curl -s "$ENVIRONMENT.example.com/health" | jq -r '.status')
if [ "$HEALTH_STATUS" != "healthy" ]; then
    echo "❌ Health check failed: $HEALTH_STATUS"
    exit 1
fi

# Check version
DEPLOYED_VERSION=$(curl -s "$ENVIRONMENT.example.com/version" | jq -r '.version')
if [ "$DEPLOYED_VERSION" != "$EXPECTED_VERSION" ]; then
    echo "❌ Version mismatch: expected $EXPECTED_VERSION, got $DEPLOYED_VERSION"
    exit 1
fi

# Test core functionality
RESULT=$(curl -s "$ENVIRONMENT.example.com/calculate?p=1000&r=5&t=2")
EXPECTED_SI="100.00"
ACTUAL_SI=$(echo "$RESULT" | jq -r '.simple_interest')

if [ "$ACTUAL_SI" != "$EXPECTED_SI" ]; then
    echo "❌ Functionality test failed: expected $EXPECTED_SI, got $ACTUAL_SI"
    exit 1
fi

echo "✅ Deployment verification passed"
```

## Rollback Runbook

### Immediate Rollback (< 5 minutes)

#### Automated Rollback Triggers
- Error rate > 5%
- Latency p95 > 1000ms
- Health check failures > 3 consecutive
- Critical security vulnerability detected

#### Manual Rollback Process
```bash
# 1. Identify last known good version
LAST_GOOD_VERSION=$(git describe --tags --abbrev=0 HEAD~1)

# 2. Execute rollback
kubectl rollout undo deployment/simple-interest -n prod

# 3. Verify rollback
kubectl rollout status deployment/simple-interest -n prod

# 4. Test functionality
./scripts/verify-deployment.sh prod "$LAST_GOOD_VERSION"

# 5. Update monitoring dashboards
./scripts/update-deployment-status.sh "rolled-back" "$LAST_GOOD_VERSION"
```

### Git-based Rollback
```bash
# If Kubernetes rollback is not sufficient
# 1. Revert commit
git revert HEAD --no-edit

# 2. Push revert
git push origin main

# 3. Wait for CI/CD to deploy reverted version
# 4. Verify deployment
```

### Database Rollback (if applicable)
```bash
# For future database changes
# 1. Stop application traffic
kubectl scale deployment/simple-interest --replicas=0 -n prod

# 2. Restore database backup
pg_restore -d production backup_$(date -d "1 hour ago" +%Y%m%d_%H).sql

# 3. Restart application
kubectl scale deployment/simple-interest --replicas=3 -n prod
```

### Communication Template

#### Incident Alert
```
🚨 PRODUCTION INCIDENT - Simple Interest Calculator

Severity: P1
Status: Investigating/Mitigating/Resolved
Started: [TIME]
Duration: [DURATION]

Issue: [BRIEF DESCRIPTION]
Impact: [USER IMPACT]
Action: [CURRENT ACTION]

Next Update: [TIME]
Incident Commander: [NAME]
```

#### Resolution Notice
```
✅ INCIDENT RESOLVED - Simple Interest Calculator

Duration: [TOTAL DURATION]
Root Cause: [BRIEF DESCRIPTION]
Resolution: [ACTION TAKEN]

Post-Mortem: [LINK TO DOCUMENT]
Follow-up Actions: [PREVENTION MEASURES]
```

### Recovery Time Objectives (RTO)

| Scenario | Target RTO | Process |
|----------|------------|---------|
| Application rollback | 5 minutes | Kubernetes rollout undo |
| Configuration rollback | 3 minutes | Git revert + redeploy |
| Database rollback | 15 minutes | Backup restoration |
| Full disaster recovery | 1 hour | Cross-region failover |

### Post-Incident Checklist
- [ ] Service restored and verified
- [ ] Monitoring alerts acknowledged
- [ ] Incident timeline documented
- [ ] Stakeholders notified of resolution
- [ ] Post-mortem scheduled within 24 hours
- [ ] Root cause analysis initiated
- [ ] Prevention measures identified
- [ ] Runbook updates completed