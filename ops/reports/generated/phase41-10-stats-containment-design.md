# Phase 41 Stats Containment Design — The Journey

**Report ID:** phase41-10-stats-containment-design
**Phase:** 41
**Title:** Phase 41 Stats Containment Design — Two Silent YAML Failures, the Dual-Process Discovery, and the Source-Elimination Architecture That Works
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:02:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-10-stats-containment-design.md`

---

## 1. Design Goal

Eliminate `data.stats`'s 441-unique-leaf vocabulary contribution at index birth while
preserving the six required ops-evidence classes (phase41-08 §3), with zero impact on
the alert lane. This report documents how we got there, including every failed attempt,
because the failures carry the operational lessons.

## 2. Attempt 1 — `values:` whitelist under eve-log stats (FAILED SILENTLY)

Suricata 7.0.x documents a `values:` option for stats output intended to select which
counters are emitted. Edit applied to `/etc/suricata/suricata.yaml`:

```yaml
outputs:
  - eve-log:
      types:
        - stats:
            values:            # attempt 1: under eve-log types
              - capture.kernel_packets
              - capture.kernel_drops
              ...
```

Result: config reloaded, traffic flowed, **437 leaves still emitted** (vs 441 baseline;
the −4 delta was ordinary churn, not selection). No error, no warning in suricata.log.
The directive was silently ignored on this build/config context.

## 3. Attempt 2 — values under top-level stats accumulator (ALSO IGNORED)

Second placement per alternate syntax readings:

```yaml
outputs:
  - stats:
      enabled: yes
      values: ...
  - eve-log:
      types: ...
```

Same outcome: full counter set kept flowing into EVE JSON. Two placements, two silent
ignores. Conclusion recorded: **on Suricata 7.0.10 as deployed, YAML-side stats value
selection is not a reliable containment mechanism**, and worse, it fails without
signal — a config that looks contained but isn't is worse than no attempt.

## 4. Root Discovery During Debugging — TWO Suricata Processes

While chasing "why didn't it take", process inspection found the real complication:

| Process | Start | Args | Parent | Role |
|---|---|---|---|---|
| PID **71996** | Aug-25 | `-i ens19 -S rules …` (exact production SPAN invocation) | init | THE production sensor |
| duplicate | P40-era restart window | af-packet DEFAULT interface (no `-i`) | systemd (`suricata.service`) | rogue second emitter |

The systemd unit's ExecStart does NOT match the production invocation; P40-era restart
attempts had spawned the unit copy alongside the manually-launched production process.
Both wrote eve.json → double stats emission, confusing every volume observation during
attempts 1–2.

**Fix applied (G41-02/03):**

```
systemctl stop suricata && systemctl mask suricata     # kill + prevent recurrence
setsid nohup <exact original argv> &                   # relaunch prod, session-proof
```

Verification: single instance thereafter; compact-doc uptime arithmetic consistent from
first sample; ruleset stamp 03:55:58.844937+0000 marks the clean birth.

## 5. Final Design (works, guaranteed by construction)

Instead of trying to make Suricata emit fewer stat fields into EVE, stop emitting the
stats EVENT TYPE entirely and publish a bounded, self-made summary lane:

1. **Remove `- stats:` from eve.json types** (G41-01) — source gone; nothing downstream
   can map what is never written.
2. **Enable unix-command socket** — default path never materialized; explicit filename
   `/var/run/suricata-command.socket` required (lesson recorded).
3. **`/usr/local/bin/suricata-compact-stats.py`** — pure python speaking the suricatasc
   socket protocol: `dump-counters` (returns 2,884 counters), flatten nested message
   dict, select 16 whitelisted aliases, append ONE flat JSON line per run to
   `/var/log/suricata/eve-stats-compact.json`.
   Implementation note: an earlier sh prototype piped into python with a heredoc — the
   pipe and heredoc collided and python read EMPTY stdin. Pure-python rewrite removed
   stdin from the equation entirely.
4. **Scheduling**: crontab absent on sensor → systemd timer `suricata-compact-stats.timer`
   with `OnUnitActiveSec=60` + service wrapper (G41-06). Timer active.
5. **Collection**: localfile block for the compact file in agent 016's ossec.conf +
   agent restart (G41-07).

## 6. Why This Is Guaranteed

- The 441-leaf family cannot appear on any future index because its producer document
  type no longer exists (stronger than filtering, stronger than mapping limits).
- The replacement lane emits a FIXED whitelist — vocabulary growth is bounded by the
  script's alias table (16 names), reviewed in VCS, not by Suricata's counter set.
- Alert lane untouched: alerts remain a separate EVE type flowing exactly as before
  (phase41-16 §4).

## 7. Format Surprises Logged Along the Way

- `dump-counters` answers `"stats not yet synchronized"` for the first ~minute after
  engine start — emitter must tolerate and retry next tick.
- Output is a SINGLE-LINE JSON envelope (not line-per-counter); flattening happens in
  the emitter, not the collector.
