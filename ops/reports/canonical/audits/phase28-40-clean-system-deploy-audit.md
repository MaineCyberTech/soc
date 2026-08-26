# Phase 28 Clean-System Deploy Audit

Date: 2026-08-24
Tooling: p28-portability-scan.sh (13,408 scan lines) + p28-deployability-inventory.sh.

## Hidden prerequisites / environment assumptions (findings)

| # | Finding | Class | Fix |
|---|---|---|---|
| 1 | Hardcoded `/opt/mct-security-stack`, `/opt/wazuh-docker`, `/opt/mct-cache` paths across scripts/configs/docs | path assumption | parameterize STACK_ROOT (profiles) |
| 2 | Hardcoded LAN IPs (192.168.222.0/24, 192.168.111.0/24, 138.197.105.82) | network assumption | profile-scoped subnet vars |
| 3 | Mutable image tags (shuffle/tenzir/opencanary/syslog-ng/cloudflared `latest`/`main`) | drift | pin image IDs (34) |
| 4 | Wazuh running config (skip-worktree) diverges from repo canonical | runtime drift | documented toggle; reconcile on install |
| 5 | Swarm mode required for Shuffle (overlay networks) | runtime assumption | document + init in golden path |
| 6 | Docker volumes referenced by name (multi-node_*, iris-web_*) | naming coupling | keep (compose-managed) |
| 7 | `localhost`/`127.0.0.1` refs in health/CI scripts | host assumption | use host vars in profiles |
| 8 | S3 DR (nyc3) + DO creds only in production | env dependency | profile-gated (35) |
| 9 | Nested git repo at data/dfir-iris (gitignored) - deployable copy | vendoring | pin upstream version (33/34) |

## Verdict

- Deployable on a fresh target IF: profiles populated, cache populated (42), swarm+compose
  initialized, image IDs pinned. Full clean-target proof not yet run (47).

## No secrets