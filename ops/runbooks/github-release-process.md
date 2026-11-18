# GitHub Release Process

Target: mainecybertech/soc (git@github.com:mainecybertech/soc.git)

## Preconditions

- Local repo committed on main (current: f14ba1b).
- Push credential configured (SSH key or approved deploy key) - see phase13-github-publish.md.
- GitHub App broker path configured for release operations:
  `KESTREL_GITHUB_APP=soc-release` and
  `KESTREL_BROKER_TOKEN_FILE=/etc/soc/kestrel-broker-token-github`. Do not use
  a PAT. See `docs/kestrel-github-app.md`.
- Pre-push checklist passed (ops/checklists/github-pre-push-checklist.md).

## Initial publish (one-time)

```bash
cd /opt/mct-security-stack
git push -u origin main          # triggers GitHub Actions verify.yml
```

## Post-push verification

1. Watch CI: https://github.com/mainecybertech/soc/actions (verify.yml on main).
2. Confirm checks pass: bash -n, py_compile, layout, stale-refs, secret scan.

## Release tag (approval-gated)

```bash
git tag -a v1.0.0 -m "MCT Security Stack v1.0.0 - Phase 13 baseline"
git push origin v1.0.0
```

- Create GitHub release with portable bundle
  (/home/user/mct-security-releases/mct-security-stack-release-*.tar.gz) as asset.
  Use the broker wrapper (never a PAT):
  `KESTREL_GITHUB_APP=soc-release scripts/gh-broker.sh release create ...`
- Update RELEASE-NOTES.md with tag + CI status.

## Rollback

Until the observation window closes, the old `GH_PAT` path is the rollback for
release publication only. Restore it from the owner-controlled secret store,
run the one gated release action, and record the reason and time. Do not commit
the PAT or load it into normal automation. See `docs/kestrel-github-app.md`.

## Rules

- Never push secrets.
- CI must pass before tagging.
- Tag/release requires operator approval.

## No secrets

No secret values printed.
