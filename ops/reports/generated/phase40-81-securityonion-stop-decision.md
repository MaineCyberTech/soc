# Phase 40 SecurityOnion Stop Decision

**Report ID:** phase40-81-securityonion-stop-decision
**Phase:** 40
**Title:** SO-DEC-40-01 — RETIRED Chain Verified, Zero Remaining Dependencies, Evidence Volumes Untouched → APPROVE STOP; EXECUTED `docker stop security-onion` (Exit 0); Rollback = `docker start`
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:50:00Z
**Classification:** INTERNAL
**Status:** COMPLETE (APPROVED + EXECUTED)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-81-securityonion-stop-decision.md`

---

## 1. RETIRED Status Chain — Verified

| Check | Finding |
|---|---|
| Agent-side | Agent 008 `securityonion` Disconnected in `agent_control -l`; last keep-alive epoch 1787597999 = **2026-08-24T18:59:59Z** (no check-in since) | VERIFIED live |
| Compose-side | Service definition COMMENTED OUT in `/opt/wazuh-docker/multi-node/docker-compose.override.yml` under the `#DISABLED-P9:` block ("Forwards all raw Wazuh events… to Security Onion syslog ingest"); only the named volume `security-onion-persist` still declared | VERIFIED file read |
| Ingest config | Mounted `config/security_onion/syslog-ng.conf` carries `DISABLED-P31:` markers — destinations + log paths REMOVED at P31 (SO retired); sources retained "for future re-enable" only | VERIFIED conf read |

## 2. Container Idle Proof

```
$ docker stats --no-stream security-onion   (BEFORE stop)
security-onion   0.00% CPU   17.38–18.01 MiB / 15.19GiB   NetIO 9.84MB / 126B
$ image: balabit/syslog-ng@sha256:8f6fe3… (digest-pinned); PortBindings = {} (no published ports)
$ disk buffer /var/lib/syslog-ng/syslog-ng-00001.rqf: 808,624,686 bytes
  re-sampled after 10 s → delta = 0 bytes (static leftover, not growing)
```

The container runs syslog-ng with zero log paths ⇒ it ingests nothing and forwards
nothing. CPU 0.00%; memory draw ~18 MiB is pure waste.

## 3. Remaining Dependencies — Checked and CLEAN

| Candidate | Method | Finding |
|---|---|---|
| tenzir-node | mounts inspect (only its own cache/data volumes), network inspect (bridge, NOT on multi-node_default), compose refs grep | NO reference to security-onion; consumes elastiflow-side pipeline |
| flow-relay | env/config inspect (`INDEX=elastiflow-flow-ecs-8.0-2.5-*`, relay.py), host-network mode | Consumes ELASTIFLOW index, not security-onion |
| Compose tree | `grep -rn "security-onion" …/compose/*.yml` | ZERO hits in repo compose files; only the disabled override block + volume name |
| Network co-membership | docker network inspect | Co-presence on multi-node_default is adjacency, not consumption; no published ports exist to consume |

## 4. Evidence Preservation Statement

`docker stop` does not touch container filesystems or volumes. Mounts preserved intact:
`multi-node_security-onion-persist` (incl. the 808 MB static .rqf disk-buffer),
read-only master/worker Wazuh-log mounts, read-only syslog-ng.conf. Nothing was removed
(`docker stop`, explicitly NOT `rm`); image retained; rollback restores full prior state.

## 5. Decision

**APPROVE STOP (SO-DEC-40-01).** Basis: retirement chain complete and dated; functional
ingest already disabled since P31 (the running process has been a no-op for its entire
recent uptime); dependency sweep clean on all candidates; non-destructive method;
trivial one-command rollback.

## 6. Execution

```
$ docker stop security-onion → security-onion
$ docker inspect → status=exited exit=0 finishedAt=2026-08-26T02:48:09Z
$ docker ps | grep security-onion → absent from running set
$ docker stats (after) → 0B / 0B (no draw)
Resources freed: ~18 MiB resident memory + container runtime overhead
(CPU was already 0%).
```

## 7. Rollback / Reactivation Prerequisites

- Immediate rollback: `docker start security-onion` (returns to prior idle-running state).
- Functional reactivation additionally requires: un-comment the DISABLED-P9 compose block,
  restore a destination-bearing syslog-ng.conf (`syslog-ng.conf.bak-phase31` lineage),
  and re-enroll an actual Security Onion receiver (agent 008 host is retired hardware) —
  i.e., reactivation is a project, not a flag-flip.
- **Owner note (R-SO):** container restart-policy=always means a HOST REBOOT would
  resurrect the idle container unless the operator sets
  `docker update --restart=no security-onion`. Left as owner action; not changed here
  beyond the approved stop.
