# Phase 38 Verification Ledger

**Report ID:** phase38-50-generate-verification-ledger
**Phase:** 38
**Title:** Claim Ledger — The ~50 Most Consequential Claims, Adjudicated
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T20:50:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-50-generate-verification-ledger.md`
**Retention Class:** LONG
**Supersedes:** `phase38-13-current-state-claims.md` claim set (retained as draft history)
**Owners:** ["ops-reports-owner"]

---

## 1. Status Vocabulary

`VERIFIED` · `PARTIAL` · `UNVERIFIED` · `CONTRADICTED` (superseded by a verified contrary) · `STALE` (true once, overtaken). Evidence refs point to live verification reports (21–30), scans (31–42), or git anchors. All VERIFIED flags are anchored to 2026-08-25 ~20:00–20:50Z.

## 2. Ledger (Markdown)

| ID | Domain | Claim | Source of claim | Status | Evidence ref |
|---|---|---|---|---|---|
| CLM-38-001 | release | Current release is v1.3.0, tag 790968b8 | git tag; P29 reports | VERIFIED | phase38-21 |
| CLM-38-002 | release | Git HEAD is 7bd3b82 with clean tree | repo state | VERIFIED | phase38-21 |
| CLM-38-003 | release | Release asset sha256 da72bde4… matches byte-exact | in-session fetch | VERIFIED | phase38-21 |
| CLM-38-004 | release | Release asset archived on-box for re-verification | implied by provenance claims | CONTRADICTED | MIS-38-04 |
| CLM-38-005 | release | Image digest pinning applied to 8 refs | P29 approvals commit | VERIFIED | git c726182 |
| CLM-38-006 | health | Disk at 84% (118G/148G, 24G avail) | live df | VERIFIED | phase38-22 |
| CLM-38-007 | health | Memory 75% (11,750/15,553 MB) | live /proc/meminfo | VERIFIED | phase38-22 |
| CLM-38-008 | health | Swap usage 64% | live free | VERIFIED | phase38-22 |
| CLM-38-009 | health | PSI cpu avg10 ≈2.6 (no saturation) | live PSI | VERIFIED | phase38-22 |
| CLM-38-010 | health | swappiness=10 applied and persistent | P30 change | VERIFIED | git 0c24353 |
| CLM-38-011 | opensearch | Cluster GREEN, 3 nodes, 274 shards / 145 primary | `_cluster/health` | VERIFIED | phase38-22 |
| CLM-38-012 | opensearch | admin creds work via https://127.0.0.1:9200 -k | live queries | VERIFIED | phase38-30 |
| CLM-38-013 | opensearch | Auth is uniformly stable (no anomalies) | assumption | PARTIAL | R-18 transient Unauthorized observed once |
| CLM-38-014 | retention | 22 wazuh-alerts-4.x indices span 08-07→08-25 | `_cat/indices` | VERIFIED | phase38-26 |
| CLM-38-015 | retention | 11 wazuh-archives-4.x indices span 08-15→08-25 totaling ~7.5GB (sizes enumerated) | `_cat/indices` | VERIFIED | phase38-26/-79 |
| CLM-38-016 | retention | 4 ISM policies exist; archives-14d→archives, retention→alerts attached | ISM API | VERIFIED | phase38-79 |
| CLM-38-017 | retention | Retention has deleted data as designed ("rolling") | P26/P27 prose | STALE | current-policy deletions = 0 (CON-38-10) |
| CLM-38-018 | retention | First policy-driven expiry ≈2026-08-29 | policy math on earliest archive | VERIFIED | phase38-79 |
| CLM-38-019 | retention | First-wave relief ≈7.9GB; post-wave disk ≈76% | phase36-75:15-16 | CONTRADICTED | computable ≈3.76GB; ceiling ~7.5GB (CON-38-06) |
| CLM-38-020 | retention | A snapshot repository is available cluster-wide | DR narrative assumption | CONTRADICTED | repository_missing_exception (phase38-26:78) |
| CLM-38-021 | field | Error signature is "Too many fields" | corpus-wide inherited string | CONTRADICTED | actual: "Limit of total fields [1000]" (phase38-25) |
| CLM-38-022 | field | decoder_order_size=512 resolves the errors | phase36-32/-75 | CONTRADICTED | knob irrelevant; indexer mapping limit (CON-38-01) |
| CLM-38-023 | field | Errors ELIMINATED post-fix | phase36-34; phase37-43:21 | CONTRADICTED | false-negative grep artifact (CON-38-02) |
| CLM-38-024 | field | Field errors ongoing at high rate post-"fix" | phase37-38 | VERIFIED | ~150/min now; 8,746 lifetime |
| CLM-38-025 | field | Error rate ~100/min | phase37-38 estimate | STALE | measured ≈150/min current window |
| CLM-38-026 | field | Fix path = index template total_fields.limit increase or source reduction | P38 corrected analysis | CANONICAL (UNVERIFIED until applied) | ACT-38-002 |
| CLM-38-027 | shuffle | Frontend listens on 127.0.0.1:3001 | phase36-17 | CONTRADICTED | 0.0.0.0:3001 live (CON-38-03) |
| CLM-38-028 | shuffle | Frontend exposed: no TLS, no firewall on 3001 | listener audit + probe | VERIFIED | phase37-04/-07; ACT-38-001 |
| CLM-38-029 | shuffle | Backend bound to 127.0.0.1:5001 | listener audit | VERIFIED | phase37-04 |
| CLM-38-030 | shuffle | Bearer token [REDACTED-TOKEN] valid for API use | preflight record | PARTIAL | worked this session; now DISCLOSED → rotate (ACT-38-003) |
| CLM-38-031 | shuffle | Exactly 2 workflows exist | API enumeration | VERIFIED | phase38-23 |
| CLM-38-032 | shuffle | "No workflows" existed at P35 final | final-phase35 report:54 | CONTRADICTED | backups since 08-11; CON-38-04 |
| CLM-38-033 | shuffle | All ~796 executions are healthchecks | master.md:62 | CONTRADICTED | 68 FINISHED real-payload runs of high-severity workflow (CON-38-05) |
| CLM-38-034 | shuffle | wazuh-high-severity-to-iris has real OpenCanary L12 activity through today | API execution payloads | VERIFIED | phase38-23 |
| CLM-38-035 | shuffle | Production routing formally deferred/gated | decision chain P33–P35 | VERIFIED | phase37-32..34 |
| CLM-38-036 | packet | SO packet scanning retired; Suricata-minimal selected | P31 commits | VERIFIED | git 43c4bf1 |
| CLM-38-037 | packet | Agent 016 runs v4.14.7 and forwards eve.json | agent status + config | VERIFIED | phase38-24 |
| CLM-38-038 | packet | 433 Suricata alerts indexed from /var/log/suricata/eve*.json | index query | VERIFIED | phase38-24 |
| CLM-38-039 | endpoints | Fleet = 8 ACTIVE (000,006,007,011,012,014,015,016); 013 disconnected; 008 retired | agent-control snapshot | VERIFIED | phase38-27 |
| CLM-38-040 | endpoints | "Active agents: 7" | master.md:116 | STALE | 015 Julians-Air reconnected today (STL-38-04) |
| CLM-38-041 | endpoints | Canary SID 2027967 approved; E2E proven | phase34-08; P35 | VERIFIED | cbcca53 |
| CLM-38-042 | tmp | /tmp at 1.6GB/7.6GB (21%) | df | VERIFIED | phase38-28 |
| CLM-38-043 | tmp | /tmp cleanup cron line exists verbatim | crontab inspection | VERIFIED | phase38-81 |
| CLM-38-044 | deployability | Deployability overall PARTIAL | phase37-78 | VERIFIED (carried) | phase37-78 |
| CLM-38-045 | deployability | Full-cluster restore NO-GO | P28 verdict | VERIFIED (carried) | git 21ba3d1; reinforced by MIS-38-07 |
| CLM-38-046 | deployability | RTO/RPO defined and certified | phase37-78 implication | UNVERIFIED | absent from corpus (MIS-38-08) |
| CLM-38-047 | corpus | Corpus = 1,888 .md files (1,833 original + 55 generated) | census | VERIFIED | phase38-43 |
| CLM-38-048 | corpus | Counts 1831/1833/1877 are one reconcilable series | scans | PARTIAL | reconciled by scope definition (CON-38-07) |
| CLM-38-049 | security | Plaintext credentials present in 3 generated reports | content inspection | VERIFIED | master.md:63; preflight.md:131; 38-73 §Step1 |
| CLM-38-050 | governance | Approval records exist for all major changes | governance narrative | CONTRADICTED | missing for exposure change, SO retirement, deferrals (MIS-38-05) |

Status mix: **30 VERIFIED**, 5 PARTIAL, 2 UNVERIFIED-class, 11 CONTRADICTED/STALE, plus canonical-forward entries.

## 3. Ledger (JSON)

```json
{
  "ledger_id": "CLM-38",
  "generated": "2026-08-25T20:50:00Z",
  "authoritative_ref": "generated/phase38-49-generate-current-state.md",
  "claims": [
    {"id":"CLM-38-001","claim":"Release v1.3.0, tag 790968b8","status":"VERIFIED","evidence":"phase38-21"},
    {"id":"CLM-38-002","claim":"HEAD 7bd3b82 clean","status":"VERIFIED","evidence":"phase38-21"},
    {"id":"CLM-38-003","claim":"Asset sha256 da72bde4... byte-exact match","status":"VERIFIED","evidence":"phase38-21"},
    {"id":"CLM-38-004","claim":"Release asset archived on-box","status":"CONTRADICTED","evidence":"phase38-46 MIS-38-04"},
    {"id":"CLM-38-005","claim":"8 image digest pins applied","status":"VERIFIED","evidence":"git c726182"},
    {"id":"CLM-38-006","claim":"Disk 84% (118G/148G, 24G avail)","status":"VERIFIED","evidence":"phase38-22"},
    {"id":"CLM-38-007","claim":"Mem 75% (11750/15553MB)","status":"VERIFIED","evidence":"phase38-22"},
    {"id":"CLM-38-008","claim":"Swap 64%","status":"VERIFIED","evidence":"phase38-22"},
    {"id":"CLM-38-009","claim":"PSI cpu avg10 ~2.6","status":"VERIFIED","evidence":"phase38-22"},
    {"id":"CLM-38-010","claim":"swappiness=10 applied","status":"VERIFIED","evidence":"git 0c24353"},
    {"id":"CLM-38-011","claim":"OpenSearch GREEN 3n/274shards/145primary","status":"VERIFIED","evidence":"phase38-22"},
    {"id":"CLM-38-012","claim":"admin:[REDACTED-PW] auth functional via 127.0.0.1:9200 -k","status":"VERIFIED","evidence":"phase38-30 (value not restated here)"},
    {"id":"CLM-38-013","claim":"Auth uniformly stable","status":"PARTIAL","evidence":"risk R-18 transient Unauthorized x1"},
    {"id":"CLM-38-014","claim":"22 alerts indices 08-07..08-25","status":"VERIFIED","evidence":"phase38-26"},
    {"id":"CLM-38-015","claim":"11 archives indices 08-15..08-25 ~7.5GB","status":"VERIFIED","evidence":"phase38-26/-79"},
    {"id":"CLM-38-016","claim":"4 ISM policies; correct attachments","status":"VERIFIED","evidence":"phase38-79"},
    {"id":"CLM-38-017","claim":"Retention deleting per design","status":"STALE","evidence":"zero current-policy deletions (CON-38-10)"},
    {"id":"CLM-38-018","claim":"First expiry ~=2026-08-29","status":"VERIFIED","evidence":"phase38-79"},
    {"id":"CLM-38-019","claim":"First-wave relief ~7.9GB / disk 76%","status":"CONTRADICTED","evidence":"computable ~3.76GB, ceiling ~7.5GB (CON-38-06)"},
    {"id":"CLM-38-020","claim":"Snapshot repository available","status":"CONTRADICTED","evidence":"repository_missing_exception (phase38-26:78)"},
    {"id":"CLM-38-021","claim":"Signature 'Too many fields'","status":"CONTRADICTED","evidence":"'Limit of total fields [1000]' (phase38-25)"},
    {"id":"CLM-38-022","claim":"decoder_order_size=512 resolves errors","status":"CONTRADICTED","evidence":"indexer mapping limit (CON-38-01)"},
    {"id":"CLM-38-023","claim":"Errors ELIMINATED post-fix","status":"CONTRADICTED","evidence":"grep false-negative (CON-38-02)"},
    {"id":"CLM-38-024","claim":"Errors ongoing high-rate","status":"VERIFIED","evidence":"~150/min; 8746 lifetime (phase38-25)"},
    {"id":"CLM-38-025","claim":"Rate ~100/min","status":"STALE","evidence":"now ~150/min"},
    {"id":"CLM-38-026","claim":"Fix = template limit increase or source reduction","status":"UNVERIFIED","evidence":"canonical mechanism, pending apply (ACT-38-002)"},
    {"id":"CLM-38-027","claim":"Shuffle frontend on 127.0.0.1:3001","status":"CONTRADICTED","evidence":"0.0.0.0:3001 live (CON-38-03)"},
    {"id":"CLM-38-028","claim":"Frontend exposed, no TLS/firewall","status":"VERIFIED","evidence":"phase37-04/-07"},
    {"id":"CLM-38-029","claim":"Backend 127.0.0.1:5001","status":"VERIFIED","evidence":"phase37-04"},
    {"id":"CLM-38-030","claim":"Bearer token [REDACTED-TOKEN] usable","status":"PARTIAL","evidence":"functional but DISCLOSED -> rotate (ACT-38-003)"},
    {"id":"CLM-38-031","claim":"Exactly 2 workflows","status":"VERIFIED","evidence":"phase38-23"},
    {"id":"CLM-38-032","claim":"No workflows existed at P35 final","status":"CONTRADICTED","evidence":"backups since 2026-08-11 (CON-38-04)"},
    {"id":"CLM-38-033","claim":"All ~796 executions are healthchecks","status":"CONTRADICTED","evidence":"68 FINISHED real-payload (CON-38-05)"},
    {"id":"CLM-38-034","claim":"high-severity workflow has OpenCanary L12 real activity through today","status":"VERIFIED","evidence":"phase38-23"},
    {"id":"CLM-38-035","claim":"Production routing formally deferred","status":"VERIFIED","evidence":"phase37-32..34"},
    {"id":"CLM-38-036","claim":"SO scanning retired; Suricata-minimal selected","status":"VERIFIED","evidence":"git 43c4bf1"},
    {"id":"CLM-38-037","claim":"Agent 016 v4.14.7 forwarding eve.json","status":"VERIFIED","evidence":"phase38-24"},
    {"id":"CLM-38-038","claim":"433 Suricata alerts indexed from eve*.json","status":"VERIFIED","evidence":"phase38-24"},
    {"id":"CLM-38-039","claim":"Fleet 8 ACTIVE; 013 disconnected; 008 retired","status":"VERIFIED","evidence":"phase38-27"},
    {"id":"CLM-38-040","claim":"Active agents: 7","status":"STALE","evidence":"015 reconnected today (STL-38-04)"},
    {"id":"CLM-38-041","claim":"Canary SID 2027967 approved; E2E proven","status":"VERIFIED","evidence":"phase34-08; git cbcca53"},
    {"id":"CLM-38-042","claim":"/tmp 1.6GB/7.6GB (21%)","status":"VERIFIED","evidence":"phase38-28"},
    {"id":"CLM-38-043","claim":"/tmp cleanup cron verbatim present","status":"VERIFIED","evidence":"phase38-81"},
    {"id":"CLM-38-044","claim":"Deployability PARTIAL","status":"VERIFIED","evidence":"phase37-78"},
    {"id":"CLM-38-045","claim":"Full-cluster restore NO-GO","status":"VERIFIED","evidence":"git 21ba3d1; MIS-38-07"},
    {"id":"CLM-38-046","claim":"RTO/RPO defined","status":"UNVERIFIED","evidence":"absent from phase37-78 (MIS-38-08)"},
    {"id":"CLM-38-047","claim":"Corpus 1888 .md (1833+55)","status":"VERIFIED","evidence":"phase38-43"},
    {"id":"CLM-38-048","claim":"Counts 1831/1833/1877 reconcile by scope","status":"PARTIAL","evidence":"CON-38-07"},
    {"id":"CLM-38-049","claim":"Plaintext creds in 3 generated reports","status":"VERIFIED","evidence":"master.md:63; preflight.md:131; 38-73 Step1"},
    {"id":"CLM-38-050","claim":"Approval records exist for all major changes","status":"CONTRADICTED","evidence":"MIS-38-05"}
  ]
}
```

## 4. Maintenance

New claims enter only with an evidence ref and status from the vocabulary above. Any consumer finding a conflict against phase38-49 must open a contradiction record (phase38-44 pattern) rather than editing summaries.
