# Phase 41 SecurityOnion Retired Validation — VAL-SO-41-01

**Report ID:** phase41-80-securityonion-retired-validation
**Phase:** 41
**Title:** VALIDATION-VAL-SO-41-01 — SecurityOnion Container Retirement Validated Live: Exited(0) With restart=no Confirmed Via docker inspect, Persist Volume Intact Untouched (886M Read-Only Mount Inspection), Agent 008 Retired-Disconnected Per Wazuh API, Zero CPU/Mem Draw In docker stats, Reactivation Prerequisites And Evidence Preservation Documented
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T06:00:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-80-securityonion-retired-validation.md`

---

## 1. Purpose

Live validation that the SecurityOnion syslog-ng container remains safely
retired since its P40 shutdown (~02:48Z), with volumes intact, agent 008
persistently retired-disconnected, and zero resource draw — plus documented
reactivation prerequisites.

## 2. Container state — VERIFIED (docker inspect, live this cycle)

```
$ docker inspect security-onion -f '{{.State.Status}} exit={{.State.ExitCode}} ...'
status=exited exit=0 restart=no
started=2026-08-24T22:53:09Z
finished=2026-08-26T02:48:09Z
```

- Exit code 0: clean shutdown, not a crash.
- `restart=no`: **will not auto-start** on daemon restart or host reboot —
  retirement is sticky by policy, exactly as set in P40.
- `docker ps -a`: single row `security-onion (balabit/syslog-ng) — Exited (0)`.

## 3. Resource draw — VERIFIED (docker stats, live)

```
$ docker stats --no-stream security-onion
security-onion   cpu=0.00%   mem=0B / 0B
```

Zero CPU, zero memory: an exited container draws nothing. No compute tax from
the retirement.

## 4. Volumes intact — VERIFIED (read-only mount inspection)

Host volume path `/var/lib/docker/volumes/**` is root-only on this box, so
inspection ran through a read-only bind mount into a throwaway container:

```
$ docker run --rm -v multi-node_security-onion-persist:/data:ro nginx:stable sh -c 'ls -la /data && du -sh /data'
python-venv/                       (Aug  8)
syslog-ng-00001.rqf    808,624,686 B (mtime Aug 24 22:53 — last write at container stop window)
syslog-ng-disk-buffer.dirlock          0 B
syslog-ng.ctl                          (socket, mtime Aug 24 22:53)
syslog-ng.persist                  16,384 B
total 886M
```

Volume contents UNTOUCHED since the stop (dir mtime 2026-08-26 02:48 matches
container finish time; buffer file mtime matches last run start). No writes,
no truncation, no pruning. Mount config of record also includes read-only
binds of master/worker wazuh log volumes into the retired container — those
source volumes are governed by their own services and unaffected.

**Evidence preservation statement:** the persist volume (886M, including the
disk-buffer `.rqf`) is preserved byte-for-byte as retirement-time evidence.
No retention job, script, or agent touches it while the container is exited.

## 5. Agent 008 — VERIFIED (Wazuh API, live)

```
GET /agents?agents_list=008 →
  name: securityonion        status: disconnected   status_code: 3
  ip: 192.168.222.116        group: [default]       manager: worker01
  version: Wazuh v4.14.7     OS: Oracle Linux Server 9.8
  lastKeepAlive:     2026-08-24T18:59:59Z
  disconnection_time: 2026-08-24T19:00:17Z
```

Agent 008 remains **retired-disconnected**: disconnected since P40 eve
(19:00:17Z on 2026-08-24), never reconnecting, still registered (registration
preserved deliberately for audit history). Consistent with the canonical
current-state line: "RETIRED: 008 securityonion" (phase40-16/-23 lineage).

## 6. Reactivation prerequisites (documented, not executed)

Reactivating SO telemetry later requires ALL of:

1. **Container start:** `docker start security-onion` (restart policy stays
   `no`; reactivation is a deliberate act, not boot-driven).
2. **Compose profile check:** confirm the service's compose definition/profile
   in `/opt/wazuh-docker/multi-node` still matches desired posture before
   start (config drift check first).
3. **Agent 008 re-enrollment decision:** either re-enable the existing
   registration (manager-side reactivation of agent 008) or formally
   deregister — do not leave a half-connected state.
4. **Buffer drain expectation:** the 808MB disk-buffer will replay on start;
   verify downstream ingest headroom and dedup expectations before starting.
5. **Post-start validation:** keepalive fresh, logs flowing, resource draw
   returns to expected envelope.

## 7. Verdict

**VAL-SO-41-01: PASS.** Retirement posture is exactly as designed: stopped
cleanly, non-resurrecting, costless, volumes preserved untouched, agent state
consistent, and a complete documented path back if the owner ever wants it.
