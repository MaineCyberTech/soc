# Phase 39 Agent 015 Flap Diagnosis — Probable macOS Sleep Cycle

**Report ID:** phase39-76-agent015-flap
**Phase:** 39
**Title:** FLAP-015-39 — Julians-Air (macOS Sonoma) Disconnect/Reconnect Pattern Correlated With Lid-Close/Sleep; Keepalive Gaps Hourly-Clustered; Plus mac-clients merged.mg Permission-Denied Finding; Status DIAGNOSED-PROBABLE-SLEEP
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T23:42:29Z
**Classification:** INTERNAL
**Status:** DIAGNOSED-PROBABLE-SLEEP (endpoint access unavailable to confirm)
**Author:** opencode/ox-alpha
**Owner:** MCT SOC (automation: opencode/ox-alpha)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-76-agent015-flap.md`

---

## 1. Live API truth

```
id=015 name=Julians-Air status=disconnected version="Wazuh v4.14.7"
lastKeepAlive      = 2026-08-25T23:14:35+00:00
disconnection_time = 2026-08-25T23:25:25+00:00
dateAdd            = 2026-08-16T07:44:31+00:00   ip=192.168.111.108
os                 = macOS 14.8.7 Sonoma (Darwin 23.6.0, x86_64)
group              = mac-clients    group_config_status=synced
```

Context correlation: agent reconnected ~20:11Z Aug-25 and dropped again by query
time — consistent with API's final keepalive 23:14Z / disconnect 23:25Z cycle.

## 2. Timeline reconstruction from telemetry

Manager `ossec.log` retains no lifecycle lines for 015 today (rotated at the
22:15Z restart), so the timeline comes from archive telemetry
(`wazuh-archives-4.x` buckets for agent.id=015):

Aug-24: single-event buckets at :00/:30 through morning (wake-check pattern),
activity clusters 10:00 (33), 13:00 (399), 14:00 (45), 16:30–17:30 (16/485),
19:30 (45), 21:00–22:30 (245/316).
Aug-25: singles at 10:00, then hourly 12:00–18:00, 20:30, 21:00, 23:00.

## 3. Sleep-pattern hypothesis (correlation)

Keepalives arriving in short hourly bursts separated by silent gaps are exactly
what a MacBook produces when **asleep with lid closed and waking briefly**
(Wi-Fi power management + periodic wake). Active-work clusters on Aug-24
daytime match human usage windows. No evidence of crash-style abrupt cutoffs
(keeps re-registering cleanly each wake).

## 4. Additional real finding — group config delivery broken

```
$ docker exec multi-node-wazuh.master-1 tail -5 /var/ossec/logs/ossec.log
2026/08/25 23:34:45 wazuh-remoted: ERROR: Unable to open file:
  'etc/shared/mac-clients/merged.mg' due to [(13)-(Permission denied)].
  … repeating every ~10s
```

The mac-clients shared configuration file cannot be served due to a permission
error inside the manager container. Every 015 reconnect therefore runs against a
broken config channel. This is an actionable stack-side defect independent of the flap.

## 5. Queue stats (real)

```
/var/ossec/var/run/wazuh-remoted.state → queue_size='0', total_queue_size='131072',
tcp_sessions='0', discarded_count='0', dequeued_after_close='0'
```

No queue pressure; drops are not stack-side.

## 6. Remediation options (ranked)

1. **Owner enables wake prevention during work hours** — `caffeinate -dimsu` or
   System Settings → Battery/Energy "Prevent automatic sleeping on power adapter".
2. **Syscheck interval alignment** — align scans to active hours so bursts don't
   land mid-wake (cosmetic but reduces burst noise).
3. **Accept-flap-with-monitoring** — lowest effort; acceptable if owner declines changes.
4. Fix `mac-clients/merged.mg` permissions in the manager volume (stack-side, do first regardless).

## 7. Monitoring suggestion

Alert rule: >2 disconnect events per hour for any single agent id over a rolling
window flags pathological flapping vs sleep-normal (~1/hour observed here).

## 8. Owner contact item

Confirm lid/sleep behavior and approve option 1; without endpoint access this
diagnosis stays PROBABLE, not confirmed.
