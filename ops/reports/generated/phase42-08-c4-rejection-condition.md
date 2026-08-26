# Phase 42 Condition C4 — Rejection Flatline Holds — PENDING-BIRTH (interim: resumed-on-legacy, documented)

**Report ID:** phase42-08-c4-rejection-condition
**Phase:** 42
**Title:** C4 Adjudication Package — Zero Rejections Post-Birth; Interim Live Proof: 2746 Rejections Resumed Against Legacy Index 07:02–07:45Z, Zero Since, Zero on Worker
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T08:34:11Z
**Classification:** INTERNAL
**Status:** PENDING-BIRTH (interim evidence: legacy-window event fully characterized)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-08-c4-rejection-condition.md`

---

## 1. Condition

After birth, the newborn must ingest with **zero** `Limit of total fields` rejections.
C4 is the *true* health signal during this arc (report 12 elevates it formally).

## 2. Exact check (from adjudicator)

```bash
docker logs multi-node-wazuh.master-1 --since <birth> 2>&1 | grep -c "Limit of total fields"
```

Pass band: `0`. Any match post-birth → FAIL (new index hit cap or template miss).

## 3. CURRENT interim status — fresh run embedded (08:05–08:20Z)

**The pre-birth interim risk MATERIALIZED.** The briefing's assumption "no rejections
observed since cutover" was falsified by fresh verification:

```
$ docker logs multi-node-wazuh.master-1 --since 2026-08-26T03:53:00Z | grep -c "Limit of total fields"
2746

per-minute histogram (--timestamps):
1366  2026-08-26T07:02
  14  2026-08-26T07:03
1366  2026-08-26T07:45
0     since 07:45:42Z (verified again at 08:20Z)

worker split: master=2746, worker-1=0
target: all carry fields.index_prefix "wazuh-archives-4.x-" → legacy daily index
```

Sampled payloads: burst 1 = agent **016 mct-packet-sensor** syscollector
`dbsync_packages INSERTED` inventory; burst 2 = vulnerability-detector rule 23502
"CVE solved" notices. Error tail: `(status=400): {"type":"illegal_argument_exception",
"reason":"Limit of total fields [2000] has been exceeded"}`.

### Mechanics (why ~1978 counted fields rejects while guardrail reads 1852)

OpenSearch's internal counter includes object nodes + leaves + multi-field variants:
126 objects + 1852 leaves/multi = **~1978 vs cap 2000**. A new dynamic string leaf costs
2 entries (text+keyword); once headroom < needed, every novel-schema doc in a burst
rejects wholesale while known-schema docs keep indexing (467k docs indexed on the index today).

### Impact statement

Archives-lane-only loss on an index that dies at midnight; alerts lane and worker path
unaffected. No action within policy: emergency limit-raise requires owner approval per
safety rules and is NOT sought — rollover self-heals at 00:00Z.

## 4. Post-birth action

Adjudicator runs the same grep from birth time. Expect 0. Any nonzero → FAIL + immediate
escalation per report 14 cadence.
