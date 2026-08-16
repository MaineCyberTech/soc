# GitHub Tag and Release Runbook

Target: mainecybertech/soc
Status: pending (requires push + operator approval)

## Preconditions

1. Push to main succeeded.
2. GitHub Actions verify.yml PASSED on main.
3. Operator approval for tag + release.

## Steps

```bash
cd /opt/mct-security-stack
git tag -a v1.0.0 -m "MCT Security Stack v1.0.0 - Phase 13 baseline"
git push origin v1.0.0
```

- Create GitHub release v1.0.0.
- Attach portable bundle asset:
  /home/user/mct-security-releases/mct-security-stack-release-20260816-014828.tar.gz
- Update RELEASE-NOTES.md with tag + CI status.

## Rules

- No tag without CI pass + operator approval.
- No secrets in release assets (bundle is secret-gated - verified).

## No secrets

No secret values printed.
