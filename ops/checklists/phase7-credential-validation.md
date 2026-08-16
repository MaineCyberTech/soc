# Phase 7 Credential Validation Checklist

For each credential:

- [ ] Old value identified in protected secret store only (creds.env / .env, 0600)
- [ ] New value generated/stored securely (never in docs)
- [ ] Dependent services updated
- [ ] Service restarted if required
- [ ] credential-rotation-validation.sh PASS for that credential
- [ ] phase5-credential-postcheck.sh PASS (extended)
- [ ] Old value revoked only after validation + 30 min stability
- [ ] Rotation tracker updated (status only)
- [ ] No secret value written to any report
