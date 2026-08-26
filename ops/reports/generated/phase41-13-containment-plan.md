# Phase 41 Containment Plan (Final Selected Spec)

**Report ID:** phase41-13-containment-plan
**Phase:** 41
**Title:** Phase 41 Final Containment Plan Spec — EVE Types Surgery, Command Socket, Compact Emitter Contract, Scheduling and Collection Wiring
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:05:00Z
**Classification:** INTERNAL
**Status:** COMPLETE (as-applied spec)
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-13-containment-plan.md`

---

## 1. Objective

Normative specification of the applied design (O6, phase41-12 §2): remove the
full-stats event source and stand up a bounded compact-stats evidence lane.

## 2. Required Evidence Classes (contract)

The lane MUST publish, per run, values sufficient to answer:

| ID | Class | Aliases |
|---|---|---|
| C1 | Packet/capture health | capture_kernel_packets, capture_kernel_drops, capture_errors |
| C2 | Memory pressure | flow_memcap, flow_spared, flow_emergency_mode, tcp_memuse, http_memuse, ftp_memuse |
| C3 | Detection engine health | detect_alerts, detect_engines, detect_alert_queue_overflow |
| C4 | Throughput basics | decoder_pkts, decoder_bytes, decoder_invalid |
| C5 | Liveness | uptime |
| C6 | Ruleset currency | detect_engines.last_reload (nested inside C3 alias object) |

Whitelist size: **16 top-level aliases** (C6 rides inside detect_engines).

## 3. Component Specifications

### 3.1 suricata.yaml (sensor `/etc/suricata/suricata.yaml`)

```yaml
outputs:
  - eve-log:
      types:            # '- stats:' REMOVED — the entire fix
        - alert:
        - http:
        ...
  # command socket block enabled with EXPLICIT filename:
  # unix_command: enable, filename: /var/run/suricata-command.socket
```

Lesson embedded: relying on the default socket path produced no file; explicit name
required.

### 3.2 Emitter contract (`/usr/local/bin/suricata-compact-stats.py`)

| Aspect | Spec |
|---|---|
| Transport | connects to `/var/run/suricata-command.socket`, speaks suricatasc JSON protocol |
| Command | `dump-counters` (returns ~2,884 counters, SINGLE-LINE JSON envelope) |
| Tolerance | first-minute `"stats not yet synchronized"` → exit 0 silently, retry next tick |
| Transform | flatten nested message dict → select 16 whitelisted keys → flat dict |
| Output | ONE JSON line appended per successful run to `/var/log/suricata/eve-stats-compact.json` |
| Implementation | pure python; NO stdin usage (sh prototype's pipe/heredoc collision lesson) |
| Failure mode | file stops growing (monotonic freshness signal), never emits wrong values |

### 3.3 Scheduling (systemd, sensor)

```
suricata-compact-stats.timer   OnUnitActiveSec=60   → suricata-compact-stats.service
```

Crontab unavailable on sensor (no crontab installed) — systemd timer chosen; active.

### 3.4 Collection (agent 016 ossec.conf)

```xml
<localfile>
  <log_format>json</log_format>
  <location>/var/log/suricata/eve-stats-compact.json</location>
</localfile>
```

Agent restart required and performed; docs land in archives lane as flat
`data.<alias>` fields.

## 4. Expected Field Footprint

| Before | After (steady state, new indices) |
|---|---|
| 441 unique stats leaves (877 raw) | ~16 aliases ≈ 20–22 unique mapped leaves (incl. detect_engines subtree + sensor/event_type metadata) |
| Net vocabulary delta | **≈ −425 leaves/index-lifetime** (headline basis: 441 removed − 16 aliases; measured variant −419..−421 incl. subtree/metadata) |

Projected steady-state guardrail reading on fresh indices: raw ≈900 ±150 (corrected
basis) with conservative mixed-basis upper bound ≈1285 — both < soft 1400
(full derivation phase41-17 §5).

## 5. Verification Requirements (discharged in phase41-16)

1. Zero documents with `data.stats` indexed post-restart.
2. Compact docs present in archives at ~60s cadence with all whitelisted fields.
3. Alert lane volume/signature unchanged through transition window.
4. capture_kernel_drops=0 across samples (containment must not cost packets).
5. Single Suricata instance running (mask holds).

## 6. Rollback Specification

Order matters (un-collect first, restore last):

1. Remove localfile from ossec.conf; restart agent 016.
2. `systemctl disable --now suricata-compact-stats.timer`; remove .timer/.service files.
3. Remove `/usr/local/bin/suricata-compact-stats.py`.
4. `cp /etc/suricata/suricata.yaml.bak-p41-containment /etc/suricata/suricata.yaml`.
5. Restart production instance with EXACT original args (setsid nohup pattern).
6. `systemctl unmask suricata` ONLY if returning to unit-managed operation (not
   recommended while ExecStart mismatch persists — see phase41-10 §4).
