# Phase 41 RTO/RPO Decision Sheet — Review-Populated, Recommendations Filled, Signature EMPTY

**Report ID:** phase41-27-rto-rpo-decision-sheet
**Phase:** 41
**Title:** DEC-40-01-R1 — DEC-40-01 Sheet Re-Issued With Fresh Evidence References And ADOPT Recommendation Per Row: s3 Cadence Corrected Basis (86 Snaps, Fixed 5/day), fs ~5–6/day (42 Snaps), Spot-Check Durations (<10s P40), Custody Gate NOW CLOSED Upgrade On Row 11; Signature Line Intentionally Blank — No Signoff Exists
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T04:53:00Z
**Classification:** INTERNAL
**Status:** PENDING (AWAITING-SIGNATURE)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-27-rto-rpo-decision-sheet.md`

---

## 1. What this sheet is

The same decision instrument as phase40-72 §3, refreshed so the owner signs
against **today's** evidence rather than last night's. Every recommendation is
pre-filled; the only human act remaining is mark + sign. Until that happens,
nothing here is binding and the DRAFT-TARGET governance of phase40-72 §4 stays
in force.

## 2. Fresh evidence references used in this refresh [VERIFIED live today]

| Evidence | Fresh value (2026-08-26) |
|----------|---------------------------|
| fs snapshot repo `wazuh-backup` | 42 snapshots; latest **snap-20260826-0330 SUCCESS 03:30:04→07Z, 58 indices** (~5–6/day cadence stands) |
| s3 repo `do-spaces` | 86 snapshots at fixed **5/day** cadence (P40 correction); latest **s3-snap-20260826-0047 SUCCESS 00:47:01→48:15Z, 97 indices** |
| Restore spot-check durations | P39 minutes-class (phase39-73); P40 **<10s with count parity** (phase40-57 §5) |
| Asset custody | **UPGRADED TO CLOSED TODAY**: published-original on-box byte-exact — sha256 `da72bde45db379c5417970224c11caf5305b281e47b302b07e45d823411b589c` matches published identity; stored `ops/releases/v1.3.0/` beside rebuilt-labeled variant (`65f794a7…`) retained as fallback |
| Full-cluster rehearsal | Still never executed; no adequate target provisioned (host re-measured 148G/118G/84% today) |

## 3. Ready-to-sign sheet (recommendations filled, signature EMPTY)

```
=====================================================================
DECISION RECORD DEC-40-01-R1 — RTO/RPO TARGET ADOPTION (review refresh)
Reference proposal : phase40-71-rto-rpo-proposal.md (RTODRF-40-01)
Prior record       : DEC-40-01 (phase40-72)
Evidence base      : §2 above (live 2026-08-26) + RTOEV-40-01 (phase40-70)
Decision date      : ____________        Effective date: ____________
---------------------------------------------------------------------
Mark exactly one per row:  [A] Adopt   [M] Modify (write value)   [R] Reject

 1. Alerts tier        RPO <=1h / RTO <=4h     Rec: A   [ ]A [ ]M:____ [ ]R
    NOTE if adopting <=1h RPO: current fs cadence (~5–6/day ⇒ worst ≈5h gap)
    does NOT meet it; adoption implies funding cadence increase or accepting
    ≈5h honest state.
 2. Archives tier      RPO <=24h / RTO <=8h    Rec: A   [ ]A [ ]M:____ [ ]R
    Basis corrected: s3 measured 5/day ⇒ ≤24h comfortably met today.
 3. Manager/configs    RPO <=24h / RTO <=2h    Rec: A   [ ]A [ ]M:____ [ ]R
 4. Shuffle tier       RPO <=24h / RTO <=2h    Rec: A   [ ]A [ ]M:____ [ ]R
 5. IRIS tier          RPO <=24h / RTO <=2h    Rec: A   [ ]A [ ]M:____ [ ]R
    (load-back never rehearsed — value remains target-only.)
 6. Dashboards         RPO <=24h / RTO <=2h    Rec: A   [ ]A [ ]M:____ [ ]R
 7. Reports corpus     RPO <=24h / RTO <=1h    Rec: A   [ ]A [ ]M:____ [ ]R
 8. Endpoints re-enroll RTO UNDEFINED-until-
    measured (authorize measurement)           Rec: A   [ ]A [ ]M:____ [ ]R
 9. Client ops deliverables RTO <=4h after
    sources restored                            Rec: A   [ ]A [ ]M:____ [ ]R
10. Full-cluster RTO UNDEFINED; aspirational
    <=24h; acknowledge + authorize Stage0
    target provisioning                         Rec: A   [ ]A [ ]M:____ [ ]R
11. Rehearsal input asset = PUBLISHED-ORIGINAL
    v1.3.0-published-original.tar.gz sha256 da72bde4…
    (NOW ON-BOX, byte-exact vs published identity;
    rebuilt variant retained as fallback)       Rec: A   [ ]A [ ]M:____ [ ]R
12. Interim governance stance (DRAFT-TARGET until
    this row executes)                          Rec: A   [ ]A [ ]M:____ [ ]R

Owner signature: ____________________   Date: ____________
Recorded by (automation witness): opencode/ox-alpha, 2026-08-26
Register entry in phase41 successor register required upon return.
=====================================================================
```

## 4. Why the signature line is empty

No owner session has occurred. Fabricating or pre-filling a signature, a date,
or a "verbal approval" is prohibited and would poison every downstream claim.
The sheet ships blank exactly where a human must put ink.

## 5. Non-goals

Adopting nothing; authorizing no rehearsal execution (that is GATE-DR series +
Stage0); changing no cadence by itself — row 1's cadence implication activates
only if adopted.
