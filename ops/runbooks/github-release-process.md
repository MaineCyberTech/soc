# GitHub Release Process

Target: mainecybertech/soc (git@github.com:mainecybertech/soc.git)

## Preconditions

- Local repo committed on main (current: f14ba1b).
- Push credential configured (SSH key or PAT) - see phase13-github-publish.md.
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
- Update RELEASE-NOTES.md with tag + CI status.

## Rules

- Never push secrets.
- CI must pass before tagging.
- Tag/release requires operator approval.

## No secrets

No secret values printed.
