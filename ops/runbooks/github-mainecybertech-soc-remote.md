# GitHub Remote Runbook - mainecybertech/soc

Target repository:

```text
git@github.com:mainecybertech/soc.git
```

## Rules

- Do not push without operator approval.
- Run local CI first (scripts/ci/run-local-ci.sh).
- Review secret scan reports (ops/scripts/secret-pattern-scan.sh).
- Confirm `.env`, credentials, backups, dumps, keys, PCAPs, and EVTX files are ignored.
- Run pre-push checklist (ops/checklists/github-pre-push-checklist.md) and
  scripts/verify/github-prepush-check.sh before any push.

## Steps (on operator approval only)

```bash
# 1. Set the remote
git -C /opt/mct-security-stack remote add origin git@github.com:mainecybertech/soc.git

# 2. Verify remote
git -C /opt/mct-security-stack remote -v

# 3. Commit baseline (after review)
git -C /opt/mct-security-stack add -A
git -C /opt/mct-security-stack commit -m "Initial commit: MCT Security Stack portable repo"

# 4. Create main branch
git -C /opt/mct-security-stack branch -M main

# 5. Push (operator-approved only)
git -C /opt/mct-security-stack push -u origin main
```

## Notes

- `client.config.yaml` and `shuffle-periodic-repair.log` are gitignored as
  generated/live-secret artifacts.
- No secrets should be committed; if a secret is accidentally committed, rotate
  the affected credential and remove it from history (filter-branch/BFG) before
  the remote is shared.
