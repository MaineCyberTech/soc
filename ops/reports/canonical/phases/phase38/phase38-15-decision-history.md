# Phase 38 Decision History

**Report ID:** phase38-15-decision-history
**Phase:** 38
**Title:** Phase 38 Decision History — Catalog of Approvals, Deferrals, Retirements, and Policy Decisions
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T19:56:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode/big-pickle
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-15-decision-history.md`
**Retention Class:** LONG

---

## 1. Scope and Method

Every decision-type statement found in git history (115 commits reviewed in full), final operator reports, and the live state is cataloged with: decision ID, date, decision, source ref, type, and current standing. Types: `APPROVAL`, `DEFERRAL`, `RETIREMENT`, `ROUTING`, `POLICY_CHANGE`, `WORKFLOW`, `CREDENTIAL`, `RETENTION`, `OUT_OF_SCOPE`, `RELEASE`.

Standing values: `EFFECTIVE` (still governing), `SUPERSEDED` (replaced by later decision; successor noted), `PENDING` (approved but not yet executed/verified), `CONTRADICTED`.

---

## 2. Key Decisions (prompt-mandated anchors)

| ID | Date | Decision | Type | Source | Standing |
|---|---|---|---|---|---|
| D-31-01 | 2026-08-24 | **SO packet scanning RETIRED** — SecurityOnion packet-scan path decommissioned; healthcheck forced to 0 FAIL; forward disabled; CI hardened (SHA-pinned checkout + image/exec-mode gates) | RETIREMENT | git `43c4bf1`; final-phase30 series context | EFFECTIVE (agent 008 retired; SO VM down recorded P29/P30) |
| D-31-02 | 2026-08-24 | **Suricata-minimal selected + SPAN-gated production deployment** after benchmark: 31MB / 0 drops < 2GiB ceiling | APPROVAL + POLICY_CHANGE | git `43c4bf1`,`98d5baf` | EFFECTIVE |
| D-34-01 | 2026-08-25 | **Canary SID 2027967 approved + designed** for E2E canary (ET ruleset; offline fire + logtest proven P32) | APPROVAL | git `3d4d072` | EFFECTIVE (E2E proven P35) |
| D-36-01 | 2026-08-25 | **decoder_order_size=512 applied** to wazuh master (analysisd restarted) | POLICY_CHANGE | git `b529e3b`; phase36-32 | **CONTRADICTED as remedy** (insufficient; ~100/min persists); config itself still in place |
| D-36-02 | 2026-08-25 | **Shuffle frontend exposed on 0.0.0.0:3001** (from 127.0.0.1) to enable UI access | POLICY_CHANGE (security posture) | git `b529e3b`,`b7c2f18`; compose line 21 verified | EFFECTIVE but flagged P0 risk (no TLS) |
| D-37-01 | 2026-08-25 | **Workflow exports created** → ops/evidence/p37-workflow-export/ (2 JSONs) | WORKFLOW | git `7bd3b82`; sha256 verified | EFFECTIVE |

---

## 3. Approvals

| ID | Date | Decision | Source | Standing |
|---|---|---|---|---|
| A-18-01 | 2026-08-17 | Client subnet 192.168.111.0/24 added to syslog 15140 allowlist ("operator-approved") | git `0c9ff5e` | EFFECTIVE |
| A-16-02 | 2026-08-16 | ES snapshot cleanup plan approved & executed (43→14 snapshots, −4.3G) | git `de06b28` | SUPERSEDED by later retention automation (es-snapshot-retention-apply.sh) |
| A-22-01 | 2026-08-22 | Zeek Class A routing ENABLED — Wazuh integration rule_id 122001-122003 → Shuffle webhook → IRIS; synthetic tests FINISHED | git `96970c4`,`508b793` | EFFECTIVE (but see D-35-01 deferral on live Shuffle routing) |
| A-24-01 | 2026-08-22 | v1.2.0 release executed + published | git `62d7457`,`637fca0` | EFFECTIVE (superseded as latest by v1.3.0) |
| A-29-01 | 2026-08-24 | v1.3.0 released: tag, GitHub release 375979989, asset sha256 da72bde4… | git `8e37ae9` | EFFECTIVE (latest tag; HEAD 13 commits ahead) |
| A-29-02 | 2026-08-24 | Image pinning APPLIED — 8 mutable refs → digest pins across compose+runtime | git `c726182`,`8e37ae9` | EFFECTIVE |
| A-29-03 | 2026-08-24 | Indexer rotation maintenance window attempted; rolled back cleanly | git `8e37ae9` | CLOSED (rollback decision stands) |
| A-30-01 | 2026-08-24 | PS 4104 review cycle completed through decision gate | phase30-28…31 series (`final-phase30-operator-report`) | EFFECTIVE |

## 4. Deferrals

| ID | Date | Decision | Source | Standing |
|---|---|---|---|---|
| DF-34-01 | 2026-08-25 | Canary E2E deferred at design stage — agent 016 forwarding gap | git `3d4d072` | CLOSED by P34-update forwarding apply (`dca1691`) then P35 proof |
| DF-34-02 | 2026-08-25 | Live pipeline blocked by read-only SPAN (partial E2E only) | git `dca1691` | RESOLVED P35 (real SPAN alert proven) |
| DF-35-01 | 2026-08-25 | **Shuffle routing DEFERRED (UI-gated)** — webhook integration must be configured via Shuffle UI by operator | git `cbcca53`; phase36-17 blocker report | **OPEN — primary routing blocker today** |
| DF-37-01 | 2026-08-25 | Packet workflow implementation DEFERRED to Phase 38 (design complete, isolated pattern) | final-phase37 §3; git `7bd3b82` | OPEN (inherited by this phase) |
| DF-13-01 | 2026-08-16 | FP rules de-scoped (event-content approach) pending validation | git `f67e759` | Historical; later resolved via worker-node root cause fix `762fadf` |

## 5. Retirements

| ID | Date | Decision | Source | Standing |
|---|---|---|---|---|
| R-31-01 | 2026-08-24 | SO packet scanning retired (see D-31-01) | git `43c4bf1` | EFFECTIVE |
| R-26-01 | 2026-08-23 | Agent 015 closed out (endpoint returned/closed) — later reconnected/disconnected again per fleet history | git `cb8ca76` vs live C-15 | CONTRADICTED BY LATER EVENTS (015 back in disconnected-managed state) |
| R-30-01 | 2026-08-26→n/a | Throttle retirement recorded (phase30-26-throttle-retirement) | phase30 series file list | EFFECTIVE (historical hygiene) |

## 6. Routing Decisions

| ID | Date | Decision | Source | Standing |
|---|---|---|---|---|
| RT-17-01 | 2026-08-16 | Shuffle/IRIS packet routing mapped but DISABLED until noise validated | git `2a5aa4c` | SUPERSEDED by A-22-01 enablement for Zeek Class A; packet path still disabled |
| RT-18-02 | 2026-08-17 | zeek 122006 tightened (UDP noise) | git `46a9120` | EFFECTIVE |
| RT-18-03 | 2026-08-17 | Redis loop rule 120537 level 5→3 (noise reduced) | git `c0e203d` | EFFECTIVE |
| RT-36-01 | 2026-08-25 | No production alert-routing workflows created despite UI access (healthcheck-only inventory) | phase36-13/22/23 assessments | EFFECTIVE — explains "796 executions, no real routing" |

## 7. Policy Changes

| ID | Date | Decision | Source | Standing |
|---|---|---|---|---|
| P-30-01 | 2026-08-24 | vm.swappiness 60→10 applied | git `0c24353` | EFFECTIVE |
| P-25-01 | 2026-08-22 | Retention aligned: archives = 14 days for all archive indices | git `508b793` | EFFECTIVE |
| P-26-01 | 2026-08-23 | Zeek hard guardrails: rate-limit + kill switch (tested) | git `cb8ca76` | EFFECTIVE |
| P-24-01 | 2026-08-22 | Sysmon policy schema 4.91 + Signed-field condition; policy file always overwritten from embedded content (kills stale 4.90 copies) | git `1c575e6`,`f773d36` | EFFECTIVE |
| P-36-01 | 2026-08-25 | decoder_order_size=512 (see D-36-01) | git `b529e3b` | CONFIG IN PLACE / REMEDY CONTRADICTED |
| P-36-02 | 2026-08-25 | ISM wazuh-archives-14d attached to all 11 archive indices via change_policy API | git `b529e3b`; phase36-75 §1 | EFFECTIVE; first wave due 08-29 |
| P-18-01 | 2026-08-17 | zeek-forward.log logrotate copytruncate 200M ×3 | git `bfdf95f` | EFFECTIVE |

## 8. Workflow Decisions

| ID | Date | Decision | Source | Standing |
|---|---|---|---|---|
| W-36-01 | 2026-08-25 | Auth resolution: password reset performed; login verified | git `b529e3b`,`b7c2f18` | EFFECTIVE |
| W-37-01 | 2026-08-25 | Export both workflows as evidence (JSON) | git `7bd3b82` | EFFECTIVE |
| W-37-02 | 2026-08-25 | Hardening plan drafted; implementation pending (frontend exposure accepted short-term) | final-phase37 §1; git `7bd3b82` | OPEN |

## 9. Credential Actions

| ID | Date | Action | Source | Standing |
|---|---|---|---|---|
| CR-08-07 | 2026-08-07 | Password rotation backups (pw-rotation-20260807-154039/45) | /opt/wazuh-docker/multi-node/ops/backups listing | HISTORICAL |
| CR-21-01 | 2026-08-19 | Hardcoded-credential cleanup with fail-fast guards; SECRET-HANDLING doc | git `fa3249c`,`1d29232` | EFFECTIVE |
| CR-22-01 | 2026-08-22 | Credential env-abstraction pass | git `fd1cb3e` | EFFECTIVE |
| CR-37-01 | 2026-08-25 | Shuffle admin password rotated (old rejected; new verified; bearer token issued); operator rotation pending | phase37-03-shuffle-password | EFFECTIVE; operator step OPEN |
| CR-38-01 | 2026-08-25 | Bearer token [REDACTED-TOKEN] recorded in live state (plaintext) — flagged for removal from surfaces | phase38-00-master §2 | OPEN (P0 hygiene) |
| CR-38-02 | 2026-08-25 | OpenSearch basic-auth rejected during verification session — possible drift | phase38-13 F-1 | OPEN investigation |

## 10. Retention Decisions

| ID | Date | Decision | Source | Standing |
|---|---|---|---|---|
| RET-16-01 | 2026-08-16 | ES snapshot cleanup 43→14 | git `de06b28` | EXECUTED |
| RET-25-01 | 2026-08-22 | Archives retention aligned to 14d | git `508b793` | EFFECTIVE |
| RET-26-01 | 2026-08-23 | First observed deletes (disk 79.5%) under rolling retention | git `cb8ca76` | OBSERVED |
| RET-36-01 | 2026-08-25 | ISM attachment completing policy enforcement; first deletion expected **2026-08-29**, relief ~7.9GB (indices 08-15..18) | git `b529e3b`; phase36-75 §1 | **PENDING EVENT — next checkpoint** |
| RET-33-01 | 2026-08-25 | Retention wave staged (~08-29) re-affirmed | git `79f6cbe`,`3d4d072`,`cbcca53` | CONSISTENT |

## 11. Out-of-Scope Declarations

| ID | Date | Declaration | Source | Standing |
|---|---|---|---|---|
| OOS-28-01 | 2026-08-24 | Full-cluster restore declared NO-GO capability (architecture documented; not achievable currently) | git `21ba3d1` | EFFECTIVE — deployability PARTIAL persists through P37 |
| OOS-30-01 | 2026-08-24 | SO postmortem blocked — PVE creds unavailable; declared out of reach that session | git `0c24353` | OPEN item inherited (creds never supplied in-corpus) |
| OOS-18-01 | 2026-08-17 | NetFlow exporter attribution out of scope (single collector, 20+ subnets, 1727 IPs) | git `5e96d3e`,`b6d6f63` | EFFECTIVE scoping |
| OOS-13-01 | 2026-08-16 | FP suppression event-content scope correction | git `504c6fe`,`f67e759` | Historical |

---

## 12. Decision-Flow Integrity Checks

| Chain | Status |
|---|---|
| SO retire (R-31-01) → Suricata select (D-31-02) → benchmark PASS (`98d5baf`) → EVE ingest (`91f6789`) → observe (P33/P34) → canary approve (D-34-01) → forwarding apply (`dca1691`) → E2E proof (P35) | COHERENT — no gaps |
| Shuffle expose (D-36-02) → auth resolve (W-36-01) → exports (W-37-01) → hardening plan (W-37-02) | COHERENT but hardening OPEN |
| Retention align (RET-25-01) → attach (P-36-02) → wave pending (RET-36-01) | COHERENT — awaiting 08-29 |
| Decoder fix (P-36-01) → success claim (P36 final) → contradiction (P37 final) | BROKEN CHAIN — supersession recorded here and in ACT ledger |
| Zeek Class A enabled (A-22-01) vs Shuffle real routing zero (RT-36-01) | APPARENT TENSION — explained: synthetic tests FINISHED pre-exposure; live webhook gated on UI config (DF-35-01). Not a contradiction once gating is read. |

---

## 13. Findings

1. All six prompt-mandated key decisions were located in primary sources with exact commit hashes — none are orphaned.
2. Two decisions carry contradictions requiring active management: D-36-01 (remedy ineffective) and R-26-01 (015 closed-out vs later reconnection).
3. The single most consequential open approval chain is DF-35-01: every downstream routing/workflow outcome is gated on an operator UI action.
4. Credential governance shows steady maturation (CR-21→CR-22→CR-37) but two live exceptions remain (bearer token plaintext; OSD auth drift).
5. Release approvals show a clean cadence with no unreleased-critical markers in commit subjects since v1.3.0.

---

## 14. Decision Density Timeline (measured)

Decisions per day from §3–§11 (counted by decision date):

| Date | Decisions | Character |
|---|---|---|
| 2026-08-07 | 1 (CR-08-07) | bootstrap credential rotation |
| 2026-08-16 | 7 | FP scope, snapshot cleanup, allowlist gap found, releases v1.0.0-era |
| 2026-08-17 | 5 | noise policy cluster (zeek/redis/syslog) + OOS scoping |
| 2026-08-19 | 2 | credential cleanup, release v1.1.0 |
| 2026-08-22 | 8 | densest governance day: retention alignment, Class A enablement, sysmon suite, v1.2.0 |
| 2026-08-23 | 2 | guardrails, first observed deletes |
| 2026-08-24 | 9 | peak: pins applied, rotation rollback, v1.3.0, SO retirement, Suricata selection, swappiness, NO-GO declaration |
| 2026-08-25 | 13 | canary approval, forwarding, decoder fix, exposure change, ISM attach, auth resolution, exports, deferrals |

Interpretation: decision mass concentrates on burst days (matching chronology §7); 08-25 holds the record because it mixes one phase's close (P36/P37) with the next phase's gates.

## 15. Open-Decision Queue (standing items awaiting a deciding act)

| Queue item | Waiting since | Decider | Unblock condition |
|---|---|---|---|
| Wazuh→Shuffle webhook config (DF-35-01) | P35 | operator | Shuffle UI session |
| Packet workflow implementation (DF-37-01) | P37 | opencode+operator | webhook above |
| Shuffle hardening execution (W-37-02) | P37 | opencode+operator | maintenance window; bind/TLS choice |
| Operator password rotation (CR-37-01 tail) | P37 | operator | first UI login habit |
| decoder remedy choice: 1024 vs field-minimization | P37 design | opencode+operator | measurement plan pick |
| Full-cluster restore GO path (OOS-28-01) | P28 | opencode | isolated-target runtime proof |
| Bearer token removal from surfaces (CR-38-01) | P38 | opencode | secret-store location decision |
| OSD credential drift disposition (CR-38-02) | P38 session | operator+opencode | cred confirm/rotate |

Queue age leader: full-cluster GO path (carried since 08-24 P28 architecture declaration; effectively since earlier DR work).

---

## No secrets
