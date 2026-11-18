# Kestrel GitHub App token path

Status: consumer-side implementation and policy contract. The GitHub App,
installation, broker registry entry and broker consumer are **owner-gated** and
must be provisioned by the GitHub organization owner and Kestrel broker owner.
This repository does not create an App, hold an App private key, or contain a
live token.

This path replaces the production `GH_PAT` runtime credential with a short-lived
GitHub App installation token minted by the Kestrel token broker.

## Components

```text
SOC host                         Kestrel CT 303                    GitHub
  scripts/kestrel-github-token.py
    │  kbt_... broker token       POST /v1/tokens/issue
    ├───────────────────────────> kestrel-token-broker
    │                               │ App ID + private key (Vault)
    │                               └────────────────────────────> App installation token
    │  short-lived installation token
    <───────────────────────────────┘
    │
    └─ 0600 cache under /run/soc (five-minute safety margin)
```

The SOC host never receives the GitHub App private key or a PAT. It holds one
dedicated Kestrel broker token in a root-only file.

## Policy and alias contract

The names below are the recommended contract. They are not live until the
owners create and approve them.

| Item | Contract |
| --- | --- |
| GitHub App alias | `soc-release` (example alias; must match the broker policy) |
| Broker consumer | `soc-release` (owned by MCT SOC; one consumer per workload) |
| Broker registry entry | `github/soc-release` (owner/Kestrel controlled) |
| Repository | `MaineCyberTech/soc` only |
| GitHub permissions | `metadata: read`, `contents: write` |
| Installation scope | selected repository `MaineCyberTech/soc` only |
| Broker URL | `http://192.168.222.225:8090` (internal lab network only) |
| Broker token file | `/etc/soc/kestrel-broker-token-github`, `0600 root:root`, regular file |
| Installation token cache | `/run/soc/kestrel-github-token-soc-release.json`, `0600 root:root` |
| Consumer rate limit | 60 requests/minute (raise only with owner approval) |
| Broker token rotation | quarterly Kestrel consumer rotation, 24-hour grace |
| App private key rotation | Kestrel/GitHub owner-gated procedure; SOC has no copy |
| Legacy `GH_PAT` | rollback only until the observation window closes, then revoke |

`contents: write` is what the release API needs to create a release and upload
assets. Do not add `administration`, `members`, `organization_self_hosted_runners`,
`issues`, `pull_requests` or a second repository without a documented need. If a
future job only reads repository metadata, give it a separate read-only alias
rather than widening this one.

The broker policy must downscope the App installation token, for example:

```json
{
  "github": {
    "apps": {
      "soc-release": {
        "entry": "github/soc-release",
        "permissions": {
          "metadata": "read",
          "contents": "write"
        },
        "repositories": ["MaineCyberTech/soc"]
      }
    }
  }
}
```

The App/installation and this policy are owner-gated. A broker alias alone does
not grant access: the consumer policy, registry entry and App installation must
all allow the same alias, repository and permissions.

## Install

Run as root on the SOC host.

1. Confirm the broker is reachable on the internal network:

   ```sh
   curl -fsS http://192.168.222.225:8090/healthz
   ```

2. Install the dedicated broker token delivered by the Kestrel owner. The source
   copy is staged outside the repository by the owner; this example only shows
   the file shape and permissions.

   ```sh
   install -d -m 0700 -o root -g root /etc/soc
   install -m 0600 -o root -g root \
     /root/soc-release.broker-token \
     /etc/soc/kestrel-broker-token-github
   shred -u /root/soc-release.broker-token
   test -f /etc/soc/kestrel-broker-token-github
   test ! -L /etc/soc/kestrel-broker-token-github
   stat -c '%a %U:%G %F' /etc/soc/kestrel-broker-token-github
   ```

   Never put the broker token in Git, a container image, `argv`, a CI log, a
   ticket, a chat transcript or the repository `.env`.

3. Configure the alias and paths in the production environment (see
   `config/profiles/production.env.example`):

   ```sh
   KESTREL_BROKER_URL=http://192.168.222.225:8090
   KESTREL_GITHUB_APP=soc-release
   KESTREL_BROKER_TOKEN_FILE=/etc/soc/kestrel-broker-token-github
   # Optional: KESTREL_GITHUB_TOKEN_CACHE=/run/soc/kestrel-github-token-soc-release.json
   ```

4. Validate without contacting the broker or writing the cache:

   ```sh
   scripts/kestrel-github-token.py --dry-run
   ```

5. Mint once and inspect metadata only. The token is not printed:

   ```sh
   scripts/kestrel-github-token.py --format json
   ```

   Check `app`, `expires_at`, `installation_id`, `cache_hit` and `audit_id`.
   Correlate `audit_id` with the broker audit log if needed.

6. For callers that need a token, use the wrapper or the explicit print mode:

   ```sh
   KESTREL_GITHUB_APP=soc-release scripts/gh-broker.sh release list --repo MaineCyberTech/soc
   ```

   `--print-token` is the only mode that writes the token to stdout. Use it only
   inside a command that needs the credential, never in shell tracing or logs.

## Cutover

1. Owner creates the GitHub App, selects only `MaineCyberTech/soc`, installs it,
   registers `github/soc-release`, and approves the `soc-release` consumer with
   the policy and permissions above.
2. Owner delivers the `kbt_...` broker token file. Verify its mode, owner and
   that it is not a symlink.
3. Run the dry-run and one live metadata issuance as above.
4. Exercise the real caller (for example one release read or a release-page
   operation approved by the owner) and confirm the broker audit records the
   expected consumer, alias and installation.
5. Remove `GH_PAT` from the live production environment and stop loading it.
   Keep the old credential only in the owner-controlled secret store as
   rollback; do not load it into shells or CI.
6. Observe for the owner-defined window (recommended: at least 14 days and one
   successful release cycle). Check the broker for denials, the helper for
   failures, and the cache for correct `0600` permissions.
7. After the window closes with no fallback use, revoke the legacy PAT and mark
   it retired in the rotation checklist.

## Rollback

The old path is retained until the observation window closes. Rollback is a
configuration change, not a helper change:

1. Stop using the Kestrel alias in the affected job.
2. Restore `GH_PAT` from the owner-controlled secret store into the live
   environment only. Do not commit it or put it in this repository.
3. Run the dependent job and confirm GitHub access.
4. Record the rollback reason, time and broker `audit_id` (if any) in the change
   record.
5. Keep the Kestrel consumer disabled until the issue is understood. Re-enable
   only after the policy/alias fix is verified.

If the broker token or a minted token is suspected compromised, disable the
consumer first, then rotate the broker token with zero grace if needed, and
revoke the installation token through the broker. Do not fall back to a PAT as
an incident workaround.

## Rotation

- **Broker token**: rotated quarterly by the Kestrel consumer rotation timer, or
  manually with `consumer rotate soc-release --token-file ... --grace-hours 24
  --apply` on the Kestrel admin host. The helper reads the file on every call,
  so no SOC service restart is needed. Use `--grace-hours 0` for an incident.
- **GitHub App private key**: owner-gated in GitHub and Vault; follow the Kestrel
  App-key rotation runbook. SOC never holds the key.
- **Installation token cache**: no manual rotation. Tokens are short-lived; the
  helper refreshes when the expiry is within five minutes and writes atomically
  with mode `0600`.
- **Legacy PAT**: keep only for rollback until the observation window closes,
  then revoke and record it as retired.

## Helper behavior and failures

`scripts/kestrel-github-token.py` is Python-standard-library only. It:

- reads the broker token from a `0600` regular file, rejects symlinks, wrong
  ownership and group/world-readable files;
- never reads `GH_PAT` or `GITHUB_TOKEN`;
- validates `token`, `expires_at` (must be in the future) and
  `installation_id`; cache entries are refreshed when they enter the five-minute
  safety margin, and a newly issued token with less than five minutes left is
  used but not cached;
- caches the installation token in a `0600` regular file with an atomic
  `os.replace`, fsync and directory fsync;
- prints metadata by default and prints the token only with `--print-token`;
- supports `--dry-run`, `--format text|json`, `--app`, `--broker-url`,
  `--token-file`, `--cache-file` and `--timeout`.

Exit codes: `2` configuration/token-file problem, `3` broker unavailable,
denied or invalid response, `4` cache problem. On `401`, `403`, `429`, `5xx` or
a broker outage, fail the job and alert; do not retry indefinitely and do not
fall back to a PAT.

## Tests

```sh
PYTHONDONTWRITEBYTECODE=1 python3 -m unittest discover -s tests -p 'test_*.py' -v
```

The tests use a fake broker only. They contain no real broker token, GitHub App
key or installation token.

## No secrets

This document contains names, paths and placeholders only. No broker token,
GitHub token, App private key or PAT value belongs in this repository.
