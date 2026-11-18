# MCT Security Stack Scripts

## bootstrap/
- check-prereqs.sh - verify required tooling (docker, curl, python3, sshpass, jq, ...)
- create-directories.sh - ensure portable repo dirs exist (idempotent)
- render-env-summary.sh - print env var presence (names/lengths only, no values)

## verify/
- verify-stack-layout.sh - check required repo paths exist
- verify-current-architecture.sh - verify live facts (15140, agent 008/011/012, indexer, schedule)
- verify-no-stale-phase-refs.sh - scan current docs for phase/pack language
- verify-portable-repo.sh - verify portable state (files, secrets perms, evidence, scripts)

## endpoint-deploy/
- Linux/macOS/Windows agent install/verify/uninstall kits (see endpoint-deploy/README.md)

## GitHub App broker
- `kestrel-github-token.py` - mint and cache a short-lived Kestrel GitHub App token; metadata only unless `--print-token`
- `gh-broker.sh` - run `gh` with the helper's short-lived token (`KESTREL_GITHUB_APP` required)
- See `docs/kestrel-github-app.md` for the owner-gated alias/policy contract and rollback.

## Usage
All shell scripts: `bash <path>/<script>.sh`. Idempotent; never print secrets.
