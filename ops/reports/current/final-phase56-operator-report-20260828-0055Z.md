# Phase 56 Operator Report — P0 Correctness & Continuity

**Phase:** 56
**Date (UTC):** 2026-08-28T00:55:00Z
**Operator (EDT):** 2026-08-27T20:55:00-0400
**Prepared by:** orchestrator (MCT SOC)
**Classification:** INTERNAL
**Status:** COMPLETE (P0 regression open — Class-A broken; owner authorization required for remediation)

## 0. Supersession
This report corrects Phase 55 chronology and evidence matrices (prompts 005–024) and supersedes the Class-A status claims of earlier phases. It does NOT supersede the Phase 53/54/55 finals on their own subjects. Phase 55 remains the authoritative Phase 55 closeout; this report refines its Class-A/monitoring findings with live evidence.

## 1. Scope
Phase 56 (320 prompts, `/home/user/mct-p56/`) — a P0 correctness-and-continuity phase: freeze nonessential Shuffle lifecycle changes until Class-A is reconciled; remediate packet dedup identity; add governed TTL + a real atomic counter; restore synthetic-case isolation; reconcile Shuffle datastore access; then pursue the signed Wazuh sensor-to-IRIS canary. Executed as **real engineering**: 16 subagents (batches A–P, 20 prompts each) performed read-only live inspection; live mutations (workflow edits, Class-A repair, Wazuh apply, canary, production, restore, disk, dashboard) were stopped (BLOCKED/DEFERRED), not fabricated as PASS.

## 2. Pack Execution
- **320 prompts**, 16 subagents, all completed; reports in `ops/reports/generated/phase56-NNN-name.md`.
- **Verdict tally:**

  | Verdict | Count |
  |---|---|
  | DONE | 133 |
  | PARTIAL | 95 |
  | BLOCKED | 52 |
  | DEFERRED | 23 |
  | ACCEPT | 15 |
  | UNVERIFIED | 1 |
  | NOT_EXECUTED | 1 |
  | **Total** | **320** |

- Subagents do NOT commit; orchestrator commits (this report + 320 reports).

## 3. P0 REGRESSION — Class-A (Wazuh → IRIS) is BROKEN
**This is the dominant finding and must be escalated to the owner as a P0 break.** Confirmed independently across batches C/D/E/F/G/H/I/J/K/L/M/N/O/P:
- **Root cause:** Wazuh `integratord` posts to `webhook_eb937a37…` — but that is the **workflow ID**, while Shuffle keys webhooks by **trigger ID** (`24636c49…`). No webhook is registered for `eb937a37` in Shuffle; `GET /api/v1/triggers` returns exactly **one** webhook (`suricata-eve-in` `736b7410`, running). Class-A workflow `eb937a37` (`wazuh-high-severity-to-iris`) is in **`test`** status with embedded trigger id `24636c49`, which does not match the integratord target.
- **Second defect:** integratord `<group>suricata,</group>` filter causes all alerts to log `Skipping: Group doesn't match` → **0 deliveries** to Shuffle.
- **Auth regression:** most recent Class-A executions return **HTTP 401** to `iriswebapp_nginx:8443/alerts/add` (AUTH_FAILED) — IRIS token/path for the Class-A workflow is not resolving (earlier runs returned 200, creating IRIS alert id 58).
- Effect: the highest-severity Wazuh→IRIS lane is **non-functional**. Earlier phases' "Class-A RUNNING" claims are now contradicted by live evidence. **Remediation requires owner authorization** (Class-A repair plan 047 / approval 048 / reload 057) — gated, not executed in this pack.

## 4. Confirmed Live Defects (workflow `e133a645-95b9-4e01-9454-e270d2a0b599` source)
All VERIFIED in live workflow source this pack:
- **Dedup identity defect (P56-014/122/125/126):** dedup key `p53_dedup_%s_%s_%s_%s` = `(sid, src_ip, dest_ip, dest_port)` **omits `proto` and `agent`** → distinct-protocol / distinct-agent events falsely collapse as DUPLICATE.
- **Counter is a flag, not atomic (P56-016/155/158):** `set_cache_value(key="p53_packet_routed", value="1", …)` stores a static literal `"1"`, not a cumulative increment; not namespaced; set before IRIS delivery; not rolled back on failure.
- **No TTL (P56-015/139):** zero TTL logic; timestamps use `time.time()` (worker-local epoch), no authoritative UTC or synthetic namespace.
- **Synthetic isolation (P56-080–099):** IRIS objects 67/68/60 are tagged `source:suricata,class:A,test:true`, in production customer 1, no case linkage — **label schema exists**, but applying governed labels to production IRIS objects (082–084) was owner-gated (DEFERRED). No new IRIS objects were created this pack.

## 5. OpenSearch Monitoring Gap — ROOT-CAUSED (not total outage)
- `127.0.0.1:9200` from the host is the **Wazuh indexer** (TLS-only; plaintext → HTTP 000 "Empty reply"), a **separate cluster** from the Shuffle datastore.
- Shuffle's datastore is a **separate cluster** `shuffle-cluster` (uuid `rPikaq3w…`, OpenSearch 3.2.0) at `172.20.0.8` on the `mct-security` overlay — reachable from containers (HTTP 200, anonymous) but **not host-published** (ports null). So the Phase 55 "unreachable" gap is a **host-access** limitation, not a datastore failure.
- ISM `shuffle-rollover` confirmed failing cluster-wide (`Missing rollover_alias index setting`) — matches the Phase 53 ACCEPTED OpenSearch 3.2.0 incompatibility.
- Shuffle OpenSearch auth effectively disabled (anonymous root 200); acceptable while network-isolated, but auth must precede any exposure (223/238).

## 6. Owner-Gated BLOCKED (NO-GO without signed approval) — legitimate stops, not defects
- **Workflow code edits:** dedup-fix (122), ttl-write (139), counter-increment (155) — and any live workflow revision.
- **Class-A repair:** 047, 048, 057–061. **Wazuh apply (257) / restarts (258–259).**
- **Canary execution:** 266–288. **Production:** 289–294. **Restore:** 302–305. **Disk (300). Dashboard activation (299).**
- 52 BLOCKED + 23 DEFERRED are intentional gates.

## 7. ACCEPT / UNVERIFIED / NOT_EXECUTED
- **ACCEPT (15):** rollover ratification (295), billing/scorecard exclusion-by-absence (167/168), OS container-probe/canonical (218/241), field/monitor certs (296/297), owner-ledger (298), 13-state certification (211), and others.
- **UNVERIFIED (1):** 033 (Class-A hook record genuinely absent — consistent with the break).
- **NOT_EXECUTED (1):** 163 (no counter-read code path exists).

## 8. Methodology & Safety (all honored)
- **No `GET` on any webhook** (overlay HARD rule) — trigger state read from workflow definition / `GET /api/v1/triggers` only. Empty executions from the Phase 55 GET incident preserved as evidence (067/013).
- **No new IRIS ROUTED objects created.** ROUTED cited from carryover (P54 exec `2ce46d4a`→67; P55 exec `19791f62`→68).
- No secret value read/printed; all references by path/ID. CI gates (`p39-agents-ci.sh`, `p38-report-ci.sh`, `secret-pattern-scan.sh`) PASS.
- **Side finding for owner:** live Wazuh cluster shows `disk.threshold_enabled=true`, whereas AGENTS.md states it is disabled cluster-wide (R-DISKBYPASS) — discrepancy to reconcile.

## 9. Next Steps / Owners (authorization required)
1. **P0 — Repair Class-A** (owner sign-off): fix integratord target to the real trigger id `24636c49` (not workflow id), correct the `<group>` filter, resolve the IRIS 401 (token/path for `eb937a37`), set workflow to `active`, and re-verify the Wazuh→IRIS path end-to-end. This is the blocking item for the entire canary/production track.
2. **Authorize workflow remediation** (reversible Shuffle revisions, like the Phase 53 dead-letter change): add `proto`+`agent`+governed observer identity to the dedup key (122); implement UTC/synthetic-namespaced TTL (139); replace the flag with an atomic, cumulative, namespaced counter (155).
3. **Apply governed labels** to IRIS objects 67/68/60 (082–084) and wire exclusion CI.
4. **Expose/secure Shuffle datastore monitoring** (host-access decision, 233/234) and add ISM auth before any exposure.
5. **Signed Wazuh canary (266–288) and production (289–294)** remain NO-GO until Class-A passes and signed approval exists.

## 10. Artifacts
- `ops/reports/generated/phase56-*.md` (320 reports; verdicts per §2).
- Live evidence: Class-A `eb937a37` `test`/mis-wired; secret `iris-shuffle-env` (mode 0444) service-scoped to `shuffle-tools_1-2-0`; ROUTED carryover objects 67/68.
- AGENTS pointer updated below.
