# Phase 41 Change Register

**Report ID:** phase41-02-change-register
**Phase:** 41
**Title:** Phase 41 Change Register — Gates G41-01..14 (Field-Growth Containment Arc)
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T04:54:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-02-change-register.md`

---

## 1. Register Convention

Per phase39-02/phase40-02: each gate records **change**, **status**, **rationale**,
**approval basis**, and **rollback**. Statuses: APPLIED / VERIFIED / PENDING / DEFERRED /
PLANNED / N-A. No secret values appear. Sensor = host `mct-packet-sensor`
(192.168.222.154), Wazuh agent 016, Suricata 7.0.10 production SPAN sensor.

## 2. Gate Summary Table

| Gate | Change | Status | Detail |
|---|---|---|---|
| G41-01 | Sensor Suricata config change — remove `stats:` from eve.json types | APPLIED | §3.1 |
| G41-02 | systemd suricata unit MASKED on sensor (duplicate-start prevention) | APPLIED | §3.2 |
| G41-03 | Production Suricata restart with EXACT original args (setsid nohup) | APPLIED | §3.3 |
| G41-04 | Unix-command socket enablement (/var/run/suricata-command.socket) | APPLIED | §3.4 |
| G41-05 | /usr/local/bin/suricata-compact-stats.py installed | APPLIED | §3.5 |
| G41-06 | suricata-compact-stats.timer + .service (OnUnitActiveSec=60) | APPLIED | §3.6 |
| G41-07 | Endpoint localfile add + agent 016 restart | APPLIED | §3.7 |
| G41-08 | Archives lane validation (compact docs indexed/searchable) | VERIFIED | §3.8 |
| G41-09 | Packet imports for proof | NONE this arc | §3.9 |
| G41-10 | Dashboard validation (stats-field dependency check) | VERIFIED-NONE | §3.10 |
| G41-11 | Release custody (config backups + artifact hashing) | APPLIED | §3.11 |
| G41-12 | Rollback armed (suricata.yaml.bak-p41-containment path) | DOCUMENTED | §3.12 |
| G41-13 | Corpus commit/push (phase41 reports + catalog rows) | PENDING sign-off | §3.13 |
| G41-14 | Certification flip condition (08.27 guardrail re-check) | ARMED | §3.14 |

## 3. Gate Details

### G41-01 — EVE types change on sensor (APPLIED)

- **Change:** `/etc/suricata/suricata.yaml` outputs → eve-log types list no longer
  contains `- stats:`. Full-stats events cease at the source; nothing downstream can
  re-map them.
- **Rationale:** `data.stats` was the dominant mapper (441 unique leaves, phase41-06).
  Two YAML-side attempts to shrink the payload (`values:` whitelist under eve-log stats,
  then under top-level stats accumulator) were **silently ignored by Suricata 7.0.10**
  (phase41-10 §2–3). Source elimination is the only guaranteed containment.
- **Approval basis:** field-growth WARN ownership transferred from P40 guardrail report
  (phase40-11) to this arc; AGENTS.md change-control satisfied via this register.
- **Rollback:** restore `/etc/suricata/suricata.yaml.bak-p41-containment`, restart
  production process with original args (G41-12).

### G41-02 — systemd unit mask (APPLIED)

- **Change:** the distro/systemd `suricata.service` unit on the sensor was
  stopped **and masked** (`systemctl mask`). Root discovery: TWO Suricata processes
  were running — PID 71996 (started Aug-25, parent init, args `-i ens19 -S rules …`,
  THE production SPAN sensor) plus a systemd-spawned duplicate on af-packet default
  interface, born from P40-era restarts; its output polluted eve.json. The unit's
  ExecStart does not match the production invocation.
- **Rationale:** masking prevents any future `systemctl start/restart` from silently
  recreating the double-emitter condition that both inflated stats volume and confused
  attribution during this arc's debugging.
- **Approval basis:** required to make G41-01's fix deterministic; dual-process state
  documented with evidence in phase41-10 §4.
- **Rollback:** `systemctl unmask suricata` (only as part of full rollback, G41-12).

### G41-03 — Production restart, exact args (APPLIED)

- **Change:** production instance restarted with EXACT original argument vector via
  `setsid nohup <original cmdline>` so the process survives session loss and is NOT
  adopted by systemd (which would fight the mask).
- **Evidence:** ruleset loaded 2026-08-26T03:55:58.844937+0000 (`detect_engines.last_reload`
  in compact doc); uptime arithmetic consistent across every sampled doc.
- **Rollback:** n/a (restart itself is neutral; config rollback covers behavior).

### G41-04 — Unix-command socket (APPLIED)

- **Change:** enabled command socket in suricata.yaml. First attempt relied on the
  default socket path — file never appeared; explicit filename
  `/var/run/suricata-command.socket` set and verified.
- **Rationale:** read-only control channel for `suricatasc -c dump-counters`.
- **Rollback:** disable in yaml (covered by config restore).

### G41-05 — Compact emitter script (APPLIED)

- **Change:** installed `/usr/local/bin/suricata-compact-stats.py`. Pure-python
  implementation (socket to suricatasc protocol). An earlier shell prototype had a
  pipe-vs-heredoc collision that made python read EMPTY stdin — rewritten to avoid
  stdin entirely.
- **Behavior:** calls `dump-counters` (2,884 counters returned), flattens the nested
  message dict, selects a 16-name whitelist (capture_kernel_packets / drops / errors;
  flow_memcap / spared / emergency_mode; tcp_memuse; http_memuse; ftp_memuse;
  detect_alerts / engines / queue_overflow; decoder_pkts / bytes / invalid; uptime),
  appends ONE flat JSON line per run to `/var/log/suricata/eve-stats-compact.json`.
- **Rollback:** delete script + timer (G41-06) + localfile (G41-07).

### G41-06 — Scheduling (APPLIED)

- **Change:** `crontab` absent on sensor → systemd timer pair
  `suricata-compact-stats.timer` (`OnUnitActiveSec=60`) + `.service`; timer active.
- **Rollback:** `systemctl disable --now suricata-compact-stats.timer`.

### G41-07 — Endpoint collection (APPLIED)

- **Change:** `<localfile>` block for `/var/log/suricata/eve-stats-compact.json`
  added to sensor `/var/ossec/etc/ossec.conf`; agent 016 restarted; agent active.
- **Rollback:** remove localfile block, restart agent.

### G41-08 — Archives lane validation (VERIFIED)

- Compact docs indexed into `wazuh-archives`: count=43 by 04:49Z (~1/min cadence),
  fields searchable incl. `data.capture_kernel_packets` (exists-filter count matches),
  latest doc carries all 16 whitelisted aliases (see phase41-16 §3).

### G41-09 — Packet imports (NONE)

- No pcap imports used for proof this arc; evidence is live-traffic based.

### G41-10 — Dashboard validation (VERIFIED-NONE)

- Repo-wide grep: zero dashboard artifacts reference `data.stats.*` (phase41-09 §3);
  no import or edit required.

### G41-11 — Release custody (APPLIED)

- Pre-change yaml backed up to `/etc/suricata/suricata.yaml.bak-p41-containment`;
  emitter script and unit files are single-purpose artifacts listed in the apply
  record (phase41-15 §5) with paths fixed for release manifest inclusion next commit.

### G41-12 — Rollback armed (DOCUMENTED)

- Sequence: restore yaml backup → restart prod instance exact-args → unmask unit →
  remove localfile + timer/service + script → agent restart. Full procedure:
  phase41-15 §7. Untested-by-design (testing would reintroduce the defect).

### G41-13 — Corpus commit/push (PENDING)

- Last repo commit is Phase 40 (`423c49b`). Phase 41 corpus staged for operator
  sign-off per established convention (matches G40-12 handling).

### G41-14 — Flip condition armed (ARMED)

- First guardrail run on `wazuh-archives-4.x-2026.08.27` adjudicates the
  CONTAINED-PENDING-FULL-CYCLE verdict (phase41-18 §4). Scheduled, not hoped: the
  guardrail runs on its existing schedule; owner checks result before 09:00 UTC.

### CHG-41-AGENTS-01 — AGENTS.md post-P41 repair (phase41-82/-83)

- Change: canon pointer → current-state-20260826-postp41.md; register pointer →
  phase41-02 (G41); resolved list refreshed with P41 closures (source-side
  containment, soak+watchdog, XFO dedup, dual-process fix, custody byte-exact);
  packet-lane blocker refreshed to ROUT-PKT-41 + R-PKT-PLATFORM; three scripting-note
  bullets added (heredoc-via-ssh stdin collision; systemd-unit-vs-invocation
  divergence; execute_python param-injection). Volatile metrics kept OUT.
- Compliance chain: backup `ops/backups/agents/AGENTS.md.bak-20260826-063721` +
  sha256 banked BEFORE edit; python-applied minimal diff with per-edit asserts;
  post-validate greps clean; `p39-agents-ci.sh` re-run RESULT: PASS (0 warnings),
  length 163 ≤ 200.
- sha256 BEFORE: b91b5e2f8cbeb75061794681b25077d4478d4465d1765330438d6dbf55491a00
- sha256 AFTER:  7401ac9b836d91373fd44ba9439f4994615baa4d86908226561c6470fbc123ab
- Status: APPLIED (self-governed edit; no approval gate class triggered — pointers +
  scripting notes only, no exposure/credential/routing posture change).
