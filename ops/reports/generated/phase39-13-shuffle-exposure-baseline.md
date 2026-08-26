# Phase 39 Shuffle Exposure Baseline — EXP-39-01

**Report ID:** phase39-13-shuffle-exposure-baseline
**Phase:** 39
**Title:** EXP-39-01 — Shuffle Frontend Exposure Baseline (Pre/Post Interface-Binding Hardening)
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T22:52:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Record ID:** EXP-39-01
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-13-shuffle-exposure-baseline.md`

---

## 1. Purpose

Freeze the before/after picture of the Shuffle frontend network exposure for the
Phase-39 hardening arc. Baseline covers listener state, docker publish binding,
per-interface reachability, host firewall tooling reality, TLS posture, and
session/auth behavior. This record anchors rollback (compose backup path) and
scopes every downstream Phase-39 exposure claim.

## 2. Host Context

| Item | Value |
|---|---|
| Host type | LXC guest (unprivileged) |
| Primary interface | `ens18`, dynamic DHCP address `192.168.222.149/24` (`scope global dynamic`) |
| Other local interfaces | `lo` 127.0.0.1/8; `docker0` 172.17.0.1/16; multiple `br-*` bridge gateways (172.18–172.23.0.1/16) |
| Approved mgmt source range | Operator LAN `192.168.222.0/24` via `.149` |
| Firewall tooling | **NONE installed** — `iptables`, `nft`, `ufw`, `firewalld`: all `command -v` → NOT FOUND |
| apt install of firewall pkg | FAILED during this phase's attempt |
| NET_ADMIN capability | ABSENT from the operator effective capability set → firewall rules cannot be applied on this host even if a binary existed |

Consequence recorded up front: any design that requires host-level packet
filtering is **structurally impossible here**; control must come from socket
binding (docker publish address), which is what was applied.

## 3. BEFORE / AFTER Table

| Dimension | BEFORE (pre-p39-hardening) | AFTER (current, verified 22:14–22:17Z + re-check 22:46–22:49Z) |
|---|---|---|
| Compose publish (line 21) | `"0.0.0.0:3001:80"` | `"192.168.222.149:3001:80"` |
| Listener (`ss -tlnp`) | `0.0.0.0:3001` (all interfaces) | `LISTEN 0 4096 192.168.222.149:3001 0.0.0.0:*` ONLY |
| Reachable from loopback (127.0.0.1) | YES | **NO — connection refused (curl rc=7)** |
| Reachable from docker0 gateway (172.17.0.1) | YES | **NO — connection refused (curl rc=7)** |
| Reachable from ens18 LAN IP (.149) | YES | YES (approved path, HTTP 200) |
| Reachable from any other host IP | YES (wildcard bind) | NO — kernel binds socket to .149 only; other local addresses refuse |
| Backend port 5001 | loopback-only `127.0.0.1:5001` | unchanged, still loopback-only |
| Host firewall | not possible (no tooling/capability) | not used — control achieved at bind level |
| TLS | absent (plaintext HTTP) | absent — deferred to P40 proxy work |
| Auth surface | Bearer token (rotated earlier this phase) + UI password login | unchanged; rotated token active, old proven invalid (phase39-07) |
| Downtime incurred by change | n/a | ~6s (old container rm + compose recreate) |

## 4. Verbatim Evidence (value-free)

### 4.1 Listener state (post)

```
$ ss -tlnp | grep -E ':(3001|5001)\b'
LISTEN 0      4096         127.0.0.1:5001       0.0.0.0:*
LISTEN 0      4096   192.168.222.149:3001       0.0.0.0:*
```

No `0.0.0.0:3001` entry exists. Exactly one frontend listener, pinned to the
management interface address.

### 4.2 Per-interface reachability probes

| Probe URL | Result | Interpretation |
|---|---|---|
| `http://192.168.222.149:3001/` | HTTP **200**, curl rc=0 | approved mgmt path works |
| `http://127.0.0.1:3001/` | rc=7 (connection refused / BLOCKED) | loopback excluded by bind |
| `http://172.17.0.1:3001/` | rc=7 (BLOCKED) | docker bridge gateway excluded by bind |

### 4.3 Firewall tooling absence

```
$ for t in iptables nft ufw firewalld; do command -v $t || echo "$t: NOT FOUND"; done
iptables: NOT FOUND
nft: NOT FOUND
ufw: NOT FOUND
firewalld: NOT FOUND
```

### 4.4 Interface identity

```
$ ip -4 addr show ens18
2: ens18: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    inet 192.168.222.149/24 metric 100 brd 192.168.222.255 scope global dynamic ens18
       valid_lft 83070sec preferred_lft 83070sec
```

Note `dynamic` flag: address is DHCP-leased. Binding pins to this specific
address; see §7 caveat.

## 5. Session / Auth Behavior (unchanged by binding change)

| Mechanism | Behavior post-change |
|---|---|
| UI login (username/password) | functional over plaintext HTTP on approved path; session cookie scoped to browser |
| API bearer auth | `Authorization: Bearer <token>` against frontend→backend proxy path; GET `/api/v1/workflows` with ROTATED token → **HTTP 200** (re-verified live 22:48Z) |
| Old (pre-rotation) token | rejected 401 post backend restart (proof in phase39-07 INV-39-01) |
| Token storage | `config/shuffle-api-key` mode 600, gitignored; `.env` consumer line gitignored |
| No TLS | credentials traverse LAN in plaintext — flagged residual risk, accepted short-term, P40 |

## 6. Rollback Anchor

| Artifact | Path |
|---|---|
| Pre-hardening compose backup | `/opt/mct-security-stack/ops/backups/docker-compose.shuffle.yml.pre-p39-hardening` (line 21 = `"0.0.0.0:3001:80"`) |
| Live compose | `/opt/mct-security-stack/compose/docker-compose.shuffle.yml` (line 21 = `"192.168.222.149:3001:80"`) |
| Diff proof | backup vs live differ ONLY on line 21 |

Rollback procedure documented in phase39-15 §rollback and phase39-14 §8.

## 7. Known Caveats Carried Forward

1. **DHCP address dependency**: if `.149` ever changes lease, the bind target
   breaks and the frontend stops listening until compose is edited. Follow-up:
   consider DHCP reservation or static mapping at the router (P40).
2. **Host-reboot persistence untested**: container recreate persistence IS
   proven; full LXC reboot test pending (PERS-39-01, phase39-19).
3. **Scope of "blocked"**: refusal is host-interface-level. Public-internet
   reachability could not be probed from inside the LXC (no router/firewall
   access) — claims are scoped accordingly in DENY-39-01.

## 8. Verdict

**BASELINE CAPTURED.** Post-state: single management-interface listener, all
non-mgmt local paths refusing connections, no firewall dependency, backend
still loopback-only, auth intact with rotated credential, TLS absence honestly
recorded as open item.
