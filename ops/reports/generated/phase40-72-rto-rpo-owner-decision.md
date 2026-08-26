# Phase 40 RTO/RPO Owner Decision Record — DEC-40-01

**Report ID:** phase40-72-rto-rpo-owner-decision
**Phase:** 40
**Title:** DEC-40-01 — RTO/RPO Target Adoption Decision Record, Status AWAITING-OWNER: Ready-to-Sign Sheet for Proposal RTODRF-40-01 (phase40-71); Adoption CANNOT Be Recorded Without Explicit Owner Evidence; Interim Governance = DRAFT-TARGETS, Planning Use Only
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:45:00Z
**Classification:** INTERNAL
**Status:** PENDING (AWAITING-OWNER)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-72-rto-rpo-owner-decision.md`

---

## 1. Why this record exists and why it is not "adopted"

The decision pack requires an explicit **adopted / modified / rejected** record
per line item. No interactive owner session has occurred since RTODRF-40-01 was
authored. Fabricating adoption is prohibited; therefore the record below is
opened at **AWAITING-OWNER** and stays there until a signed/affirmed sheet (or
equivalent explicit owner statement recorded in the change register) arrives.

## 2. Transmittal note to owner

> **To:** MCT SOC owner
> **From:** Phase 40 automation (opencode/ox-alpha)
> **Subject:** Decision required — proposed RTO/RPO targets (RTODRF-40-01)
>
> The final proposal table is in `phase40-71-rto-rpo-proposal.md`, grounded in
> the fresh evidence inventory `phase40-70-rto-rpo-evidence.md`. Key points:
>
> - Alerts-tier RPO ≤1h is **not met by current snapshot cadence** (~5–6/day,
>   worst gap ≈5h). Adopting ≤1h implies funding more frequent snapshots or
>   replication; alternatively accept ≈5h as honest current state.
> - Archives tier is stronger than previously believed: s3 repo measured at
>   fixed 5/day cadence.
> - Full-cluster RTO remains UNDEFINED until a rehearsal runs on an adequate
>   isolated target (none provisioned; current host self-disqualified).
> - Until you sign, these numbers are DRAFT-TARGETS: usable for internal
>   planning only.

## 3. Ready-to-sign decision sheet

```
=====================================================================
DECISION RECORD DEC-40-01 — RTO/RPO TARGET ADOPTION
Reference proposal : phase40-71-rto-rpo-proposal.md (RTODRF-40-01)
Evidence base      : phase40-70-rto-rpo-evidence.md (RTOEV-40-01)
Decision date      : ____________        Effective date: ____________
Review date        : Phase 41 (next phase review)
---------------------------------------------------------------------
For each row mark exactly one:  [A] Adopt   [M] Modify (write value)   [R] Reject

1. Alerts tier            RPO <=1h  / RTO <=4h      [ ] A  [ ] M: ______  [ ] R
   (if M on RPO, state funded cadence change or accepted gap): ______________
2. Archives tier          RPO <=24h / RTO <=8h      [ ] A  [ ] M: ______  [ ] R
3. Manager/configs tier   RPO <=24h / RTO <=2h      [ ] A  [ ] M: ______  [ ] R
4. Shuffle tier           RPO <=24h / RTO <=2h      [ ] A  [ ] M: ______  [ ] R
5. IRIS tier              RPO <=24h / RTO <=2h      [ ] A  [ ] M: ______  [ ] R
6. Dashboards             RPO <=24h / RTO <=2h      [ ] A  [ ] M: ______  [ ] R
7. Reports corpus         RPO <=24h / RTO <=1h      [ ] A  [ ] M: ______  [ ] R
8. Endpoints re-enrollment RTO UNDEFINED-until-
   measured (authorize measurement)                 [ ] A  [ ] M: ______  [ ] R
9. Client ops deliverables RPO follows sources /
   RTO <=4h after sources                          [ ] A  [ ] M: ______  [ ] R
10. Full-cluster RTO      UNDEFINED; aspirational <=24h;
    acknowledge undefined + authorize Stage0 target
    provisioning                                    [ ] A  [ ] M: ______  [ ] R
11. Accept rebuilt-labeled release asset
    (v1.3.0-rebuilt-from-tag.tar.gz, sha256 65f794a7…)
    as rehearsal input                              [ ] A  [ ] M: ______  [ ] R
12. Interim governance stance in §4                     [ ] A  [ ] M: ______  [ ] R

Owner signature: ______________________   Date: ____________
Recorded by (automation witness): opencode/ox-alpha, 2026-08-26
Register entry required in phase40-02-change-register.md upon return.
=====================================================================
```

## 4. Interim governance stance (in force until signed)

1. All values in phase40-71 are treated as **DRAFT-TARGETS for internal
   planning only**.
2. They must **never be cited as commitments in client-facing materials**,
   contracts, scorecards, or SLA discussions.
3. Any document needing an RTO/RPO number pre-signature must carry the literal
   qualifier `PROPOSED-BUSINESS-DECISION` next to the number.
4. On sign-off, adopted values supersede drafts; modified values get a delta
   note in this record's successor; rejected items revert to UNDEFINED and are
   re-raised with evidence.

## 5. Non-goals

This record creates no obligation, adopts nothing, and does not authorize the
restore rehearsal (separate gate GATE-DR-40-01, phase40-74). It only makes the
decision mechanism concrete so the next owner session can close it in minutes.
