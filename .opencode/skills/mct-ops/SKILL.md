---
name: MCT Ops
description: Operating rules for changes across the Maine CyberTech / Kestrel estate (Identity, Access, Osprey, Vault, PBS, Caddy/Cloudflare, Falcon, Harrier, Raven, Level, Huntress, Alga PSA). Use for any MCT infrastructure, integration, runbook, secret or deployment work.
---

# MCT Ops

Use this skill before changing any MCT/Kestrel system. It encodes the safety
rules and the existing patterns so work does not create a second source of
truth or leak a credential.

## Non-negotiables

- **No secret values** in repositories, commits, tickets, chat, logs, command
  output, or screenshots. That includes tokens, API keys, client secrets,
  passwords, private keys, TOTP seeds and Vault values.
- **Least privilege:** create a dedicated service identity and role per
  integration. Never reuse an admin/human key. Prefer the read-only key unless
  writes are required.
- **Root-only custody:** secrets on hosts are `0600 root:root`, under
  `/etc/kestrel/...` or the application's root-only directory, with `umask 077`.
  Vault remains the source of truth where possible.
- **Repo-scoped broker tokens:** use
  `KESTREL_BROKER_TOKEN_FILE=/etc/kestrel-agents/<repo>/broker-token` for Git
  and GitHub. Do not print the token. Do not fall back to the admin token
  except for an explicit one-off administrative action the user requested.
- **No automatic reboots** and no branch-protection changes without explicit
  approval.
- **Validate before claiming success:** run the repository's validation/tests
  and show evidence. `scripts/validate.sh` is the Kestrel baseline.
- **Read the runbook first.** The repo runbook is the operational contract; do
  not improvise around it.

## Repositories and sources of truth

| Repo | Use |
|---|---|
| `MaineCyberTech/kestrel` | Kestrel Identity, Access, token broker, Vault wiring, Caddy/Cloudflare, estate-wide runbooks |
| `MaineCyberTech/osprey` | Service inventory, tiers, timers, topology, health/readiness |
| `MaineCyberTech/albatross` | **All Alga PSA-specific work** (deployment, integrations, runbooks, scripts) |
| `MaineCyberTech/mainecybertech` | MCT portal / Supabase application |
| `MaineCyberTech/falcon`, `harrier`, `raven`, `soc`, `vault` | Monitoring, evidence, telemetry, security, Vault |

When a PSA change is needed, put it in Albatross unless it is Kestrel-side
wiring (Caddy/DNS/certificate/registry) or Osprey-side inventory.

## Existing patterns to reuse

- **Kestrel Access collector:** read-only source in `scripts/access_report.py`,
  importer `services/kestrel-access/kestrel-access-import.sh`, root-only env
  fallback under `/etc/kestrel-access-import/`, source status/detail in the
  Access import.
- **Token broker:** provider aliases, consumer policies, static leases,
  `/v1/tokens/issue`; never build a second secret store. Admin CLI:
  `scripts/kestrel-token-broker-admin`.
- **Service-account registry:**
  `config/kestrel-service-accounts/registry.json`; checks can be `file`,
  `vault_kv`, `http`, `timer`, `systemd`, `systemd_result`, `broker_audit`.
- **Health/alerting:** `storage-health-notify@%n.service` + root-only ntfy
  config; fixed reason codes; no PII in messages.
- **Backups:** logical dump + receipt JSON + PBS snapshot; test restore, not
  just `pg_restore --list`.
- **SSO:** Authentik OIDC app onboarding; issuer, exact callback, PKCE,
  group binding, provider grant types. Keep a break-glass local admin.
- **Access reviews:** read users/roles/permissions and remediate via role APIs;
  do not invent SCIM where the product has none.

## Change checklist

1. Identify the system, owner, current state and rollback.
2. Check the runbook and the service-account registry.
3. Use a dedicated least-privilege identity/key and root-only files.
4. Make the smallest change; prefer additive and reversible.
5. Run the relevant tests/validation and a live read-only smoke test.
6. Verify health/readiness and logs; confirm no secret/PII leakage.
7. Update the runbook and registry.
8. Commit with a clear message and open a PR; do not merge without checks and
   required review.

## Useful verification

```sh
# Kestrel repo validation
scripts/validate.sh

# Osprey inventory
python3 scripts/build_inventory.py

# Alga PSA readiness
curl -fsS https://psa.mainecybertech.us/api/readyz

# Access status/runs
curl -fsS http://192.168.222.225:8080/api/v1/status
```

Use subagents for independent research or parallel tasks, but give them
precise scope and never let them print secrets or touch live systems without
approval.
