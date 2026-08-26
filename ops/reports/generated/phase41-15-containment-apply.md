# Phase 41 Containment Apply Record

**Report ID:** phase41-15-containment-apply
**Phase:** 41
**Title:** Phase 41 Apply Record — YAML Edit+Backup, Unit Mask, Exact-Args Restart, Socket, Emitter Install, Timer, Localfile With Timestamps
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:07:00Z
**Classification:** INTERNAL
**Status:** APPLIED
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-15-containment-apply.md`

---

## 1. Scope

Full mutation record for containment gates G41-01..07 on sensor `mct-packet-sensor`
(192.168.222.154). Every change listed with sequence position and observable timestamp
evidence where the stack records one.

## 2. Sequence of Changes

| # | Change | Gate | Timestamp evidence |
|---|---|---|---|
| 1 | Backup: `cp /etc/suricata/suricata.yaml /etc/suricata/suricata.yaml.bak-p41-containment` | G41-11 | pre-edit; backup path is THE rollback artifact |
| 2 | Attempt 1 edit: `values:` whitelist under eve-log stats | (failed design) | reverts observed ineffective — leaf count unmoved |
| 3 | Attempt 2 edit: `values:` under top-level stats accumulator | (failed design) | same outcome; both attempts rolled back |
| 4 | Debugging discovery: dual Suricata processes (PID 71996 prod `-i ens19 -S rules` + systemd af-packet duplicate) | — | process table snapshot during arc window |
| 5 | `systemctl stop suricata && systemctl mask suricata` (duplicate killed + recurrence prevented) | G41-02 | unit shows masked |
| 6 | Final yaml edit: remove `- stats:` from eve-log types; enable unix-command socket w/ explicit filename `/var/run/suricata-command.socket` | G41-01/G41-04 | file mtime within arc window |
| 7 | Lab gate passed (`-T` + first compact line) | G41-05 prep | phase41-14 |
| 8 | Install `/usr/local/bin/suricata-compact-stats.py` (pure python emitter, 16-alias whitelist) | G41-05 | file present, executable |
| 9 | Production restart: `setsid nohup <exact original argv>` (parent init, NOT systemd) | G41-03 | `detect_engines.last_reload=2026-08-26T03:55:58.844937+0000`; uptime arithmetic start ≈03:55:59Z |
| 10 | Install `suricata-compact-stats.timer` (OnUnitActiveSec=60) + `.service`; enable+start | G41-06 | timer active |
| 11 | Add localfile block for `/var/log/suricata/eve-stats-compact.json` to agent ossec.conf; restart agent 016 | G41-07 | agent active post-restart |
| 12 | Postcheck suite | G41-08 | phase41-16 |

## 3. Notes On The Sensitive Steps

- **Mask rationale**: the systemd unit's ExecStart does not reproduce the production
  invocation; any future accidental `systemctl start suricata` would recreate the
  double-emitter defect. Mask makes that failure impossible rather than unlikely.
- **Exact-args restart**: argv captured from the running PID before stop; relaunch via
  setsid nohup detaches from session AND from systemd adoption, keeping mask semantics
  coherent.
- **Socket naming**: default-path attempt produced no socket file; explicit filename
  required (recorded as design constraint, not workaround).

## 4. In-Arc Corrections (honest ledger)

| Correction | Trigger | Fix |
|---|---|---|
| Sh prototype emitter replaced by pure python | pipe-vs-heredoc collision → python read empty stdin | stdin eliminated from design |
| Default socket path abandoned | file never appeared | explicit filename |
| dump-counters first-minute sync error | `"stats not yet synchronized"` | tolerate-and-retry-next-tick in emitter |
| Single-line envelope assumption | output is one JSON blob, not per-counter lines | flatten inside emitter |

## 5. Artifact Inventory (release custody)

| Artifact | Path | Disposition |
|---|---|---|
| Config backup | `/etc/suricata/suricata.yaml.bak-p41-containment` | KEEP until certification flip + 1 cycle |
| Emitter | `/usr/local/bin/suricata-compact-stats.py` | permanent |
| Timer/Service units | `suricata-compact-stats.timer/.service` | permanent while design stands |
| Sensor ossec.conf diff | localfile block only | permanent |
| This corpus | ops/reports/generated/phase41-* | commit via G41-13 |

## 6. Verification Pointer

Behavioral verification lives in phase41-16 (zero full-stats post-restart, compact docs
indexed end-to-end, alert lane untouched, capture health clean).

## 7. Post-Step Validation Commands (as run)

Each mutation step was followed by an immediate observable check:

| After step | Command shape | Expected / observed |
|---|---|---|
| yaml edit (6) | `suricata -T -c /etc/suricata/suricata.yaml` | clean load ✓ |
| restart (9) | process listing + `detect_engines.last_reload` on next compact line | single PID; stamp 03:55:58.844937+0000 ✓ |
| socket (4/6) | `ls -l /var/run/suricata-command.socket` | file present, owned by suricata ✓ |
| emitter (8) | manual invocation | one valid JSON line appended ✓ |
| timer (10) | `systemctl list-timers \| grep compact-stats` | active, next-trigger ~60s ✓ |
| localfile (11) | agent log + archives query for `data.capture_kernel_packets` | first doc 04:02:43.774Z ✓ |
| overall (12) | phase41-16 suite | all PASS ✓ |

## 8. Environment Notes

- Sensor host: mct-packet-sensor (192.168.222.154), Wazuh agent 016, Suricata 7.0.10.
- Production invocation preserved verbatim from pre-stop capture (`-i ens19 -S rules …`,
  parent init, session-detached via setsid/nohup).
- Crontab: absent on sensor (no crontab installed) — hence the systemd timer choice
  rather than a cron entry (G41-06).
- No credentials were transcribed into any artifact; secrets referenced only as
  `[REDACTED-*]`.

## 9. Rollback (armed, untested-by-design)

Per phase41-13 §6 order: un-wire collection → disable timer → remove script → restore
yaml from `.bak-p41-containment` → exact-args restart → optional unmask. Any partial
rollback leaves the system in a documented intermediate state ONLY between steps 1–3
(stats still contained; compact lane gone) — safe direction.
