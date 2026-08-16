# Credential Rotation Verification Checklist

For each credential:

- [ ] Old value identified in protected secret store only
- [ ] New value generated/stored securely
- [ ] Dependent services updated
- [ ] Service restarted if required
- [ ] Healthcheck passed
- [ ] Workflow test passed
- [ ] Old value revoked
- [ ] Rollback note documented
- [ ] No secret value written to report
