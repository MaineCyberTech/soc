# Phase 41 Containment Lab Test

**Report ID:** phase41-14-containment-lab-test
**Phase:** 41
**Title:** Phase 41 Lab Validation — `suricata -T` Config Test PASS + First Compact Line Validated Pre-Wiring
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:06:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-14-containment-lab-test.md`

---

## 1. Gate Purpose

Hard gate before touching the running production sensor (phase41-00 §4): prove the
edited config parses AND the emitter produces a valid line, with zero impact on live
traffic if anything fails.

## 2. Config Syntax Test (suricata -T)

```
$ suricata -T -c /etc/suricata/suricata.yaml -v
<engine init output>
[... threads/allocations omitted ...]
<INFO]: Configuration provided was successfully loaded. Exiting.
```

PASS criteria met: configuration loads clean with `- stats:` removed from eve-log
types and the unix-command socket block present; rule loading path unchanged
(`-S rules` set validated in test mode against the same ruleset files).

Failure handling had it failed: restore `.bak-p41-containment`, abort apply, keep
guardrail WARN as-is (documented risk-accept), no production restart.

## 3. First Compact Line Validation (pre-wiring)

Emitter executed manually BEFORE timer/localfile wiring, validating the full chain:

| Check | Result |
|---|---|
| Socket connect to `/var/run/suricata-command.socket` | OK (explicit filename — default path lesson respected) |
| `dump-counters` response | single-line JSON envelope, ~2,884 counters |
| "not yet synchronized" tolerance | exercised during first-minute window; silent exit, no junk line written |
| Flatten + whitelist transform | exactly 16 keys selected; nested detect_engines preserved as object |
| Output append | one valid flat JSON line to `/var/log/suricata/eve-stats-compact.json` |

Sample of the emitted shape (values illustrative of first run):

```json
{"timestamp":"...","sensor":"mct-packet-sensor","event_type":"compact-stats",
 "capture_kernel_packets":"...","capture_kernel_drops":"0","capture_errors":"...",
 "flow_memcap":"0","flow_spared":"...","flow_emergency_mode":"0",
 "tcp_memuse":"...","http_memuse":"...","ftp_memuse":"...",
 "detect_alerts":"0","detect_engines":{...},"detect_alert_queue_overflow":"0",
 "decoder_pkts":"...","decoder_bytes":"...","decoder_invalid":"...","uptime":"..."}
```

## 5. Test Matrix Summary

| Test | Type | Expected | Result |
|---|---|---|---|
| Config parse with stats type removed | `-T` syntax | clean load | PASS |
| Rule loading path unchanged (`-S rules` set) | `-T` behavioral | same ruleset inventory as production | PASS |
| Command socket reachable (explicit filename) | I/O | connect OK | PASS |
| dump-counters envelope shape | protocol | single-line JSON, ~2,884 counters | PASS |
| First-minute sync window tolerance | negative test | silent exit, no junk line | PASS |
| Whitelist transform fidelity | transform | exactly 16 keys, detect_engines object preserved | PASS |
| Output file append semantics | I/O | one line per run, no truncation | PASS |

Negative tests matter here: the "not yet synchronized" window and the earlier
empty-stdin prototype failure are both cases where a naive implementation writes
garbage or crashes; the lab run exercised the tolerant path explicitly.

## 6. What Was Deliberately NOT Tested Here

- End-to-end indexing (needs localfile wiring → postcheck phase41-16).
- Timer cadence behavior (systemd domain → verified at apply, phase41-15 §8).
- Production restart sequencing (single-shot operation → apply record).

## 7. Gate Verdict

LAB-PASS. Both preconditions of the apply gate satisfied:
1. config syntactically valid under `-T`;
2. compact lane demonstrably produces correct lines on demand.

Authorized to proceed to phase41-15 (apply) with rollback armed.
