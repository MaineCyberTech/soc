# Phase 39 Shuffle Hardening Design Decision — DES-39-01

**Report ID:** phase39-14-shuffle-hardening-design
**Phase:** 39
**Title:** DES-39-01 — Frontend Exposure Control Selection: Options Evaluation and Chosen Minimum Durable Control
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T22:53:00Z
**Classification:** INTERNAL
**Status:** APPROVED-APPLIED
**Record ID:** DES-39-01
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-14-shuffle-hardening-design.md`

---

## 1. Problem Statement

The Shuffle frontend was published as `0.0.0.0:3001:80` — reachable from every
host interface (loopback, docker bridges, LAN). Objective: restrict exposure to
the approved operator path only, using controls that survive container/host
lifecycle events on an **unprivileged LXC guest**.

## 2. Options Evaluated

| # | Option | Feasibility on this host | Verdict |
|---|---|---|---|
| O1 | Host firewall (iptables/nftables/ufw) restricting :3001 to mgmt subnet | **IMPOSSIBLE** — no firewall tooling installed; package install attempt failed; `CAP_NET_ADMIN` absent from operator capability set; LXC cannot load filter tables | REJECTED (structural) |
| O2 | Loopback-only bind + TLS reverse proxy (nginx/caddy on LXC) | Technically sound but **requires deploying a proxy that does not exist today**, plus cert decision (self-signed vs internal CA), renewal procedure, and operator approval | DEFERRED → P40 (design prepped in phase39-16) |
| O3 | VPN / dedicated mgmt subnet segmentation | Out-of-scope infrastructure change (router-level); exceeds phase mandate and touches shared network fabric | OUT OF SCOPE |
| O4 | **Interface-specific docker publish bind** (`192.168.222.149:3001:80`) | Fully supported by docker publish semantics; one-line compose change; survives `up -d`; no extra packages; no elevated caps needed | **CHOSEN** |

## 3. Why O4 Is the Minimum Durable Control

- Kernel enforces the bind: the listening socket is attached to `.149`
  exclusively; connection attempts arriving for other local addresses are
  refused at TCP level (empirically: rc=7 on loopback and docker0).
- Durability lives in version-controlled compose (single-line diff), not in
  runtime state — immune to container recreation, image pulls, or `up -d`.
- Zero new moving parts on a memory-constrained host.
- Compatible with future O2: when a TLS proxy lands in P40, it can bind the
  same way (or take over :443 while the frontend drops to loopback entirely).

## 4. Usability Impact (documented, accepted)

Loopback access is now blocked by design:

- Operators must use `http://192.168.222.149:3001/` (LAN address) instead of
  localhost shortcuts. Bookmarks/scripts referencing `127.0.0.1:3001` break —
  intentionally.
- Backend remains `127.0.0.1:5001`; its consumers (frontend internal network,
  ops scripts on-host) unaffected.
- No workflow/orborus impact: engine components communicate over the docker
  networks, never through the published host port.

## 5. Persistence Model

| Layer | Mechanism | State |
|---|---|---|
| Declarative | compose file line 21 carries the bind — reapplied on every `docker compose ... up -d` | PROVEN across container recreate |
| Container lifecycle | `restart: unless-stopped` keeps service up through daemon restarts | in effect |
| Full host reboot | expected idempotent via same compose invocation; **not yet exercised** — follow-up test defined in phase39-19 | PENDING TEST |

## 6. Healthcheck Plan

- Continuous: existing shuffle healthcheck sidecars observed running
  (`shufflehealthcheck_1-1-0.*` containers Up).
- Operator-level: `ss -tlnp | grep '192.168.222.149:3001'` must show exactly
  one LISTEN line after any compose operation; curl triad (mgmt=200,
  loopback=refused, docker0=refused) re-runs after changes.
- P40 candidate: fold the triad into the repo health script as a named check.

## 7. Residual Risk Register

| Risk | Severity | Disposition |
|---|---|---|
| Entire mgmt VLAN `192.168.222.0/24` can reach :3001 (not just single operator station) | LOW-MED | ACCEPTED — trusted management LAN; host has no per-source filtering capability; subnet granularity would need router ACLs (O3, out of scope) |
| **No TLS — admin bearer + password cross the LAN in plaintext HTTP** | MED | FLAGGED for P40: proxy deployment per phase39-16 design; short-term acceptance recorded here and in SHUFFLE-SEC-39-01 |
| DHCP lease change breaks bind target | LOW-MED | monitor; P40: DHCP reservation or static lease for `.149` |
| Reboot behavior unproven | LOW | scheduled verification (phase39-19 §follow-up) |
| No alerting on auth failures | LOW | noted in certification report backlog |

## 8. Rollback Design

```bash
cd /opt/mct-security-stack
cp compose/docker-compose.shuffle.yml /tmp/ # optional current-state save
cp ops/backups/docker-compose.shuffle.yml.pre-p39-hardening compose/docker-compose.shuffle.yml
docker compose --env-file .env -f compose/docker-compose.shuffle.yml up -d shuffle-frontend
```

Result: line 21 returns to `0.0.0.0:3001:80`, wildcard exposure restored,
downtime ≈ one container recreate (~6s observed). Backup verified to differ
from live file on line 21 only.

## 9. Decision Record

DECIDED 2026-08-25, applied same window (FW-39-01, phase39-15). Owner: MCT SOC.
Rationale chain: O1 impossible → O2 premature without cert/approval decisions →
O3 infra out-of-scope → O4 applied as minimum durable control with explicit
residual-risk acceptance and a funded P40 path to close the TLS gap.
