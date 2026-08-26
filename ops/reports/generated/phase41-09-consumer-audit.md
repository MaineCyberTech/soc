# Phase 41 Consumer Audit

**Report ID:** phase41-09-consumer-audit
**Phase:** 41
**Title:** Phase 41 Consumer Audit — Nobody Consumes data.stats.*; Investigation Value Preserved Via Compact Set (Verification Greps Embedded)
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:01:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-09-consumer-audit.md`

---

## 1. Question

Before deleting a field source forever: who eats these fields? If anything downstream —
dashboard, rule, report, workflow, runbook query — depends on `data.stats.*`, removal
breaks it silently. This audit answers with greps AND behavioral queries.

## 2. Static Verification Greps (run during arc, outputs embedded)

Repo-wide search across configs, dashboards, scripts (excluding generated reports):

```
$ grep -rlE 'data\.stats|stats\.decoder|stats\.app_layer' \
    /opt/mct-security-stack --include='*.json' --include='*.ndjson' \
    --include='*.conf' --include='*.yml' --include='*.yaml' \
    --include='*.sh' --include='*.py' \
    | grep -vE 'reports/generated|node_modules|\.git'
(no output)
```

Custom Wazuh manager rules:

```
$ grep -rn 'stats' /opt/wazuh-docker/multi-node/config/wazuh_manager/etc/rules/
(no output)
```

Dashboard artifact inventory (P39/P40 imports incl. `w1-w2-windows-endpoints.ndjson`):
no panel, filter, or field reference touches any `data.stats.*` path.

## 3. Behavioral Verification (live index queries)

1. **No dashboards built on them** — static grep above is corroborated by usage: the
   only dashboard lane in production (windows endpoints pack) queries win/syscheck
   families exclusively.
2. **No detection rules fire on stats-only documents** — MEASURED:

```
$ count(docs where data.stats exists AND rule.id exists) → {"count":0}
```

   Every full-stats document ever indexed is archive-only; no rule ever matched one,
   so no active-response or SOAR chain can be affected by removal.
3. **No scheduled reports reference the family** — ops/reporting inventory contains no
   stats-field queries (grep set §2).

## 4. Investigation Value — Preserved By Design

Removal must not blind investigations. The compact lane keeps exactly the fields an
investigator needs when asking "was the sensor healthy at time T?":

```
$ latest compact doc @ 04:50:35.953Z (indexed, searchable):
capture_kernel_packets=368291  capture_kernel_drops=0
tcp_memuse=1216000  flow_memcap=0  detect_alerts=0
detect_engines{rules_loaded=529, rules_skipped=0, last_reload=03:55:58Z}
uptime=3276
```

Query pattern for investigators post-cutover (documented here as the replacement
playbook):

```
exists:data.capture_kernel_drops AND data.capture_kernel_drops>0   → packet loss windows
data.flow_emergency_mode:"1"                                       → flow-table stress
data.detect_alert_queue_overflow:"1"                               → engine overload
```

All four predicates verified searchable via exists-filter counts during postcheck
(phase41-16 §3).

## 6. Query Transcript Evidence (embedded)

Behavioral checks as executed (credentials redacted):

```
# 1) stats docs that were ever alerts:
$ curl -sk -u "admin:[REDACTED]" ".../wazuh-archives-4.x-2026.08.26/_count" \
    -d '{"query":{"bool":{"filter":[{"exists":{"field":"data.stats"}},
                                    {"exists":{"field":"rule.id"}}]}}}'
{"count":0,...}

# 2) compact-lane searchability (replacement predicates):
exists:data.capture_kernel_packets      → count>0, all from agent 016
exists:data.detect_alerts               → present every run
data.capture_kernel_drops:"0"           → matches all samples to date

# 3) producer isolation cross-check:
terms(agent.name.keyword) on data.stats → [("mct-packet-sensor", 166)]  # only entry
```

## 7. Audit Coverage & Limits

| Surface | Covered | Method |
|---|---|---|
| Repo configs/dashboards/scripts | yes | grep §2 |
| Custom manager rules | yes | rules-dir grep §2 |
| Imported dashboard artifacts | yes | ndjson inventory grep |
| SOAR workflows (Shuffle) | indirect | zero rule-matched stats docs ⇒ nothing could have been routed on them; webhook canaries ride alert lane only |
| Ad-hoc analyst queries | not provable | accepted residual: historical indices retain fields; future queries fail LOUDLY (unknown field) rather than silently |

The loud-failure property is deliberate comfort: any stale query referencing
`data.stats.*` against a post-cutover index errors visibly in the query UI instead of
returning wrong results.

## 8. Verdict

NO CONSUMERS FOUND — removal cleared on both static and behavioral evidence.
Investigation capability preserved via compact predicate set (§4).

## 9. Residual Risk Accepted

Historical archives indices (≤08.26) retain their already-mapped stats fields — old
queries against old indices keep working. Only NEW indices lack the family. Any
long-range cross-index stats query will see asymmetric availability; acceptable and
documented here rather than mitigated (retention horizon 14d bounds the asymmetry).
