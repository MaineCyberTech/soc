# Phase 39 Preflight

**Report ID:** phase39-01-preflight  
**Phase:** 39  
**Title:** Phase 39 Preflight — Live State Freeze for the Credential Remediation Arc  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T22:24:00Z  
**Classification:** INTERNAL  
**Status:** COMPLETE  
**Authoritative:** true  
**Author:** opencode/ox-alpha  
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-01-preflight.md`  

---

## 1. Purpose and Method

Preflight freezes the live state picture at arc start so every later phase39 report can
cite a common baseline. Two evidence classes are used and labeled:

- **MEASURED**: command output captured in this session (reproducible).
- **OPERATOR-STATE**: values verified live during the 2026-08-25 21:58–22:20Z ops window,
  carried into this report as recorded state (not re-executed here where the check is
  stateful, e.g., DB row creation).

## 2. Git / Release Baseline (MEASURED)

```
$ git log --oneline -3
04e689d Phase 38: corpus audit (98 reports), field-error root cause fixed, Shuffle corrections, CI gate
7bd3b82 Phase 37: 82 reports, workflow exports, Shuffle hardening plan, field resolution design
b7c2f18 Phase 36 update: Shuffle auth resolved, frontend exposed, decoder fix applied, agent/ISI state current
```

- HEAD = `04e689d` (Phase 38 committed). Working tree dirty with **14 modified paths**
  (credential remediation changeset — enumerated in phase39-09/11; commit gate G12 pending).
- Release lineage: **v1.3.0** per RELEASE-NOTES.md/release-manifest.json (P38 era);
  no release action this phase (archiving gate G10 planned).

## 3. Host Resources (MEASURED)

```
$ df -h /
/dev/sda1       148G  118G   24G  84% /

$ free -m
               total        used        free      shared  buff/cache   available
Mem:           15553       11481         195          10        4376        4071
```

Reconciliation note: the ops-window record states disk improved to **83%** after P38
retention relief (was 84%); the `df -h /` snapshot above reads **84%** (118G/148G, 24G
free) at 22:21Z. The one-point delta is within intra-hour fluctuation from continued
ingest; both readings are retained here rather than silently normalized. Memory: 15.5G
total, 11.4G used, ~4.1G available — consistent with the P30 memory plan steady state.

## 4. OpenSearch Cluster (OPERATOR-STATE + MEASURED probe)

- Cluster health: **GREEN, 3 nodes** (verified live in ops window).
- Local endpoint probe (MEASURED): `curl -sk https://localhost:9200/ → HTTP 401`
  (service up, auth required as expected).
- Field-limit posture: template **`wazuh-archives-fieldlimit`** EXISTS and verified
  (priority 320, limit 2000). Rejections still flowing **~9k/hr** — expected until the
  first index created under the new template rolls **2026.08.26**. This is a designed
  transition window, not an active fault. Disk relief from rejection-stop is therefore
  also time-gated.

## 5. Shuffle Stack Posture — PRE vs POST ops (both verified live)

| Aspect | Pre-window | Post-window (current) |
|---|---|---|
| Frontend publish | `0.0.0.0:3001->80` (all interfaces) | `192.168.222.149:3001->80` (mgmt only) |
| Backend publish | `127.0.0.1:5001` | unchanged `127.0.0.1:5001` |
| Admin bearer | old token, disclosed in tracked reports | ROTATED; new key mode-600 file + .env |
| Old token validity | valid (in use) | **INVALID (HTTP 401)** post backend restart |
| Workflow auth (outbound→IRIS) | corrupted header JSON on high-severity flow | repaired; proven by 3 FINISHED deliveries |

Current live port map (MEASURED, `docker ps` excerpt):

```
shuffle-frontend    443/tcp, 192.168.222.149:3001->80/tcp
shuffle-backend     127.0.0.1:5001->5001/tcp
shuffle-opensearch  9200/tcp, 9300/tcp, 9600/tcp, 9650/tcp (unpublished)
iriswebapp_nginx    80/tcp, 127.0.0.1:8443->8443/tcp
```

Bind verification probes (MEASURED):

```
$ curl -s -o /dev/null -w "%{http_code}" http://192.168.222.149:3001/   → 200
$ curl http://127.0.0.1:3001/                                           → rc=7 connection refused (000)
```

Loopback BLOCKED confirms the publish-binding fallback works without host firewalling
(host LXC lacks iptables/nft/ufw and NET_ADMIN — see phase39-02 G3 for rationale).

## 6. Agent Fleet

| Agent | State | Note |
|---|---|---|
| 000 | ACTIVE | fleet anchor |
| 006 | ACTIVE | |
| 007 | ACTIVE | |
| 011 | ACTIVE | |
| 012 | ACTIVE | |
| 014 | ACTIVE | sysmon-tuned Windows |
| 016 | ACTIVE | packet-sensor host telemetry |
| 013 | DISCONNECTED | long-standing coverage gap, tracked since P22 |
| 015 | FLAPPING-DISCONNECTED | repair cycle documented P19–P26; closeout pending |
| 008 | RETIRED | retired with SecurityOnion P31 |

7 active / 1 disconnected / 1 flapping / 1 retired. No agent work was scheduled inside
the credential arc; states recorded for baseline continuity only.

## 7. IRIS DNS Root Cause (live-fixed in window; MEASURED confirmation)

Root cause: workflow HTTP app containers execute on swarm overlay
**`shuffle_swarm_executions` (10.224.224.0/24)**; `iriswebapp_nginx` was attached only to
iris_backend/iris_frontend/mct-security bridges, so the name did not resolve from the app
network. Fix: `docker network connect shuffle_swarm_executions iriswebapp_nginx --alias
iriswebapp_nginx` → resolves at **10.224.224.66** from the app network.

Live confirmation (MEASURED):

```
$ docker network inspect shuffle_swarm_executions --format '{{range .Containers}}{{.Name}} {{end}}'
… iriswebapp_nginx …
```

Rollback = `docker network disconnect shuffle_swarm_executions iriswebapp_nginx`.
Delivery proof enabled by this fix: executions 53e2e193 / ab14f34c / 413c137a all
FINISHED with IRIS HTTP 200; IRIS DB shows alerts 37/38/39 created **2026-08-25
22:08:24Z** ("Wazuh flow alert (Class A)") (OPERATOR-STATE).

## 8. AGENTS.md Discovery Result (MEASURED)

```
$ find / -maxdepth 4 -name "AGENTS.md" -not -path "*/.git/*"
(no results)
$ ls docs/AGENTS.md AGENTS.md
ls: cannot access 'docs/AGENTS.md': No such file or directory
ls: cannot access 'AGENTS.md': No such file or directory
```

**Zero AGENTS.md files existed anywhere** in scope at preflight. Creation of a root
AGENTS.md is planned (gate G8); not applied in this arc's live window.

## 9. Blockers Entering the Arc

| ID | Blocker | Class | Unblock |
|---|---|---|---|
| B-39-1 | Field-limit rejections continue until first new index rolls | TIME | 2026-08-26 index roll |
| B-39-2 | Retention delete-wave observation outstanding | TIME | 2026-08-29 |
| B-39-3 | Host lacks firewall capability → exposure hardening must rely on publish-bind fallback | DESIGN | accepted fallback G3; TLS review deferred G4 |
| B-39-4 | Git history contains pre-redaction token values | ACCEPTED-RISK | rotation renders inert; rewrite out-of-scope (phase39-10 §6) |
| B-39-5 | CI secret-gate scope hardcoded to phase38 globs | GOVERNANCE | widen in Phase 40 (phase39-12 §4) |

None of B-39-1..B-39-5 blocks credential rotation/redaction execution; all are carried
forward with owners and dates.

## 10. Verdict

**COMPLETE.** Baseline frozen; measured vs operator-state evidence labeled; blockers
registered with unblock conditions.
