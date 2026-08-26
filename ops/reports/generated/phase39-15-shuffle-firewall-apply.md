# Phase 39 Shuffle Bind-Address Hardening Apply — FW-39-01

**Report ID:** phase39-15-shuffle-firewall-apply
**Phase:** 39
**Title:** FW-39-01 — Apply Record: Honest Reframe from Firewall to Bind-Address Hardening (Interface-Only Publish)
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T22:54:00Z
**Classification:** INTERNAL
**Status:** PASS (applied; fallback mechanism — see §1)
**Record ID:** FW-39-01
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-15-shuffle-firewall-apply.md`

---

## 1. Honest Reframe

This record was planned as a **firewall apply**. It is delivered as a
**bind-address hardening apply** because the firewall path is structurally
impossible on this host:

| Firewall prerequisite | Observed reality |
|---|---|
| `iptables` / `nft` / `ufw` binaries | NOT INSTALLED (`command -v` → NOT FOUND for all four candidates incl. firewalld) |
| Ability to install them via apt | **apt install FAILED** during this phase's attempt |
| `CAP_NET_ADMIN` in operator capability set | ABSENT — LXC guest does not grant packet-filter administration |

Rather than fake a firewall record, the control objective (restrict :3001 to
the approved mgmt path) was met at the socket-bind layer via docker publish
semantics. Security outcome is equivalent for host-interface scoping; design
rationale in phase39-14 (DES-39-01).

## 2. Exact Commands Run

```bash
cd /opt/mct-security-stack

# 1) Backup pre-change compose
cp compose/docker-compose.shuffle.yml \
   ops/backups/docker-compose.shuffle.yml.pre-p39-hardening

# 2) Pin the publish bind to the management interface address
sed -i 's/"0.0.0.0:3001:80"/"192.168.222.149:3001:80"/' \
   compose/docker-compose.shuffle.yml

# 3) Remove stale frontend container — it belonged to an EARLIER compose
#    project (label mismatch: com.docker.compose.project differed), so
#    `compose up` would have errored with conflicting container name.
docker rm -f shuffle-frontend

# 4) Recreate frontend under the current project with the new binding
docker compose --env-file .env -f compose/docker-compose.shuffle.yml \
   up -d shuffle-frontend
```

Step 3 note (kept verbatim in the record because it explains ~6s of downtime):
the running container predated the current compose project naming; rather than
fight label drift, the container was force-removed and recreated declaratively.
No state is held in the frontend container (stateless nginx-style image).

## 3. Diff Proof (backup vs live)

```
$ diff <(grep -n '3001' ops/backups/...pre-p39-hardening) <(grep -n '3001' compose/docker-compose.shuffle.yml)
< 21:      - "0.0.0.0:3001:80"
---
> 21:      - "192.168.222.149:3001:80"
```

Single-line change; everything else byte-identical.

## 4. Verification Outputs (post-apply)

### 4.1 Listener state

```
$ ss -tlnp | grep -E ':(3001|5001)\b'
LISTEN 0      4096         127.0.0.1:5001       0.0.0.0:*
LISTEN 0      4096   192.168.222.149:3001       0.0.0.0:*
```

Exactly one :3001 listener, bound to `.149` only; backend unchanged on loopback.

### 4.2 Reachability triad

```
http://192.168.222.149:3001/  -> HTTP 200        (curl rc=0)  APPROVED PATH OPEN
http://127.0.0.1:3001/        -> rc=7           CONNECTION REFUSED / BLOCKED
http://172.17.0.1:3001/       -> rc=7           CONNECTION REFUSED / BLOCKED
```

### 4.3 Container state

```
$ docker ps --format '{{.Names}}\t{{.Ports}}' | grep shuffle-front
shuffle-frontend    443/tcp, 192.168.222.149:3001->80/tcp
```

Publish mapping shows the interface-scoped form (no wildcard).

## 5. Downtime Accounting

Window: single-digit seconds (~6s) between `docker rm -f` and healthy recreate;
UI confirmed serving 200 immediately after `up -d` returned. No workflow
executions were in flight (checked prior); subsequent real-delivery runs
completed FINISHED (see PERS-39-01).

## 6. Status

**APPLIED** with fallback rationale recorded above and in DES-39-01. The word
"firewall" survives only in this record ID and title for audit-trail honesty:
what shipped is an interface bind, not packet filtering.

## 7. Rollback

Restore backup over live compose, then `up -d shuffle-frontend` (procedure in
phase39-14 §8). Verified one-command reversible within same downtime envelope.
