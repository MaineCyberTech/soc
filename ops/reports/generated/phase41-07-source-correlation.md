# Phase 41 Source Correlation

**Report ID:** phase41-07-source-correlation
**Phase:** 41
**Title:** Phase 41 Source Correlation — Every Major Field Family Attributed to Its Producing Agent/Lane
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T04:59:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-07-source-correlation.md`

---

## 1. Method

For each family: exists-filter query on today's archives index with a terms aggregation
on `agent.name.keyword`, giving document counts AND producing agents in one shot. Where
the manager itself ingests (syslog lanes), agent.name=wazuh.master is the collector,
not the origin device; origin attribution then follows from content fields (e.g.,
data.ubiquiti.kick_mac implies UAP source device).

## 2. Attribution Table (MEASURED 04:47–04:49Z)

| Family | Docs (approx) | Producer(s) | Lane |
|---|---|---|---|
| **data.stats** | 166 | **mct-packet-sensor (016) — 100%** | Suricata EVE full-stats events from eve.json localfile |
| data.win | >10k | MCT-WIN11PILOT (012) 15,822; DESKTOP-MI54LFT (014) 1,278 | Windows eventchannel |
| data.ubiquiti | >10k | wazuh.master collecting AP syslogs | syslog → manager decoder |
| data.parameters | 164 | mct-portal-dev (007) | web/app logs |
| data.audit | 7,455 | mct-portal-dev 5,469; docker-host 1,986 | auditd |
| data.osquery | >10k | docker-host 18,429; mct-portal-dev 5,041 | osquery result log |
| data.service | 15 | MCT-WIN11PILOT 10; packet-sensor 3; linux-client01 2 | mixed eventchannel |
| data.capture_kernel_packets (new compact lane) | 43 | **mct-packet-sensor (016) — 100%** | eve-stats-compact.json localfile |

## 3. Key Finding: Sensor 016 Is the Primary Producer of the stats Branch

All 166 full-stats documents on today's index came from agent 016 (`mct-packet-sensor`,
192.168.222.154). Zero other agent contributed a single stats doc. This is the cleanest
possible attribution for containment scope: ONE config file on ONE host owns the
largest field family. It also validates the dual-process discovery's relevance — both
rogue emitters wrote through the same agent lane, so removing the stats type at the
source yaml kills both simultaneously (phase41-10 §4).

## 4. Corroboration Details

- Last full-stats doc: @timestamp **03:53:31.766Z**, agent.name=mct-packet-sensor,
  carrying only `data.stats.uptime=99132` — the tail end of the old world.
- First compact-lane doc: **04:02:43.774Z**, same agent, uptime=404s → sensor clock
  arithmetic puts Suricata start at ≈03:55:59Z, matching `detect_engines.last_reload`
  03:55:58.844937+0000 read directly from a compact doc. Three independent clocks agree.
- Ubiquiti kick-noise class (P40's early burst driver) remains attributed to AP
  infrastructure via manager syslog collection; unchanged this phase, volume-bounded,
  vocabulary-bounded (36 unique leaves) — accepted.

## 6. Per-Family Evidence Snippets

**stats → Suricata EVE (agent 016):**
```
last stats doc: {"@timestamp":"2026-08-26T03:53:31.766Z",
                 "agent":{"name":"mct-packet-sensor"},
                 "data":{"stats":{"uptime":"99132"}}}
```
Content shape (`data.stats.<family>.<counter>`) is verbatim Suricata EVE stats
structure — no decoder renaming in between; agent 016 ships eve.json as localfile json.

**win → Windows eventchannel (agents 012/014):**
Field names under `data.win.system.*` / `data.win.eventdata.*` mirror Event XML
element paths — eventchannel lane signature, not syslog parsing.

**ubiquiti/unifi → AP syslogs via manager collector:**
Producer shows `wazuh.master` because APs syslog INTO the manager; origin attribution
rides content fields (kick_mac, radio/device identifiers). Two families exist
(`ubiquiti` vs `unifi`) from distinct decoders over the same device class — noted,
not merged (out of scope).

**parameters/audit/osquery → portal-dev & docker-host lanes:** counts in §2 match
each host's known log inventory; no cross-lane bleed detected.

## 7. Attribution Confidence Notes

| Family | Confidence | Basis |
|---|---|---|
| data.stats | **certain** | 100% single-agent terms agg + EVE shape + restart-boundary timestamps |
| compact lane | certain | exists-filter docs all agent 016; cadence matches timer |
| win | high | two-agent concentration matches endpoint inventory |
| ubiquiti | high | manager-collector pattern + content fields |
| audit/osquery/parameters | high | per-host totals align with known shipper configs |

## 8. Consequence Recap

Single-producer certainty for the arc's dominant family is what allowed P41 to be a
one-host change with cluster-scale effect — and what keeps rollback equally narrow
(phase41-07 prior §5, phase41-15 §10).

## 9. Rollback Blast Radius (from §5, retained)

Because attribution is single-producer for the contained family, rollback blast radius
is trivially scoped: reverting G41-01..07 affects only agent 016's lanes. No shared
pipelines and no multi-agent decoders depend on the changed files (consumer side proven
independently in phase41-09).
