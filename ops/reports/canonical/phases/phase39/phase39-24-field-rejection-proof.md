# Phase 39 Field-Rejection Proof

**Report ID:** phase39-24-field-rejection-proof  
**Phase:** 39  
**Title:** Rejection-Flatline Proof Method — Before/After Counter Design, Expected Stop Signature, and Tail-End Caveat (Awaiting 2026.08.26 Roll)  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T23:04:00Z  
**Classification:** INTERNAL  
**Status:** PENDING  
**Authoritative:** true  
**Author:** opencode/ox-alpha  
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-24-field-rejection-proof.md`  
**Unblock Condition:** 08.26 becomes the Filebeat write target after 00:00:02Z Aug-26

---

## 1. Purpose

Defines the effectiveness half of the certification: rejection events must STOP once
the daily write target rolls to an index created under the 2000-limit template.
Method and baselines are fixed tonight so tomorrow's "after" numbers are comparable.

## 2. Before-Baseline — MEASURED (frozen 2026-08-25 ~22:50–22:55Z)

Channel: **docker logs of `multi-node-wazuh.master-1`** (Filebeat stdout). The
in-container `ossec.log` channel carries ZERO such lines (`grep -c` → 0, measured);
all before/after counting MUST use docker logs or it will falsely read as flatline.

| Window | Command | Count |
|---|---|---|
| total visible (current rotation window) | `docker logs … \| grep -c "Limit of total fields"` | 9109 |
| last hour | `docker logs --since 60m …` | 8960 |
| last 10 min | `docker logs --since 10m …` | 1503 |

Derived rate: ≈150/min ≈9000/hr. P38's "~147/min ≈14k/day" daily figure does not
reconcile with its own per-minute figure (≈147/min ⇒ ≈212k/day); discrepancy flagged
in phase39-21 §6. Irrelevant to this proof: the gate is ZERO, not a rate value.

Error signature (verbatim tail sample):

```
2026-08-25T22:50:57.468Z	WARN	[elasticsearch]	elasticsearch/client.go:408	Cannot index event
…(status=400): {"type":"illegal_argument_exception","reason":"Limit of total fields [1000] has been exceeded"}
```

## 3. Expected After-Signature

1. Filebeat routes each archive event to the index named for its @timestamp day;
   at roll time the target flips from 08.25 → 08.26 within seconds.
2. 08.26 inherits limit=2000 (setting-level proof phase39-23), and current true field
   demand is ≈1000+ (mapping saturation evidence phase39-26) — comfortably inside the
   new ceiling unless an unusual branch burst lands.
3. Therefore hourly rejection counts should collapse to **0** beginning with the
   00:00–01:00Z bucket on Aug-26.

### Tail-end caveat (expected, not a failure)

Documents already harvested against archives.json but addressed to 08.25 may produce
a SHORT residual of `[1000]` rejections in the minutes bracketing midnight (the
harvester is offset-based; final drain of the 08.25-bound queue happens near the
roll). Residuals lasting more than ~30 minutes after 00:05Z would NOT match this
model and require investigation instead of being waved through.

## 4. Evidence Queries (enumerated, run post-roll)

```
# Q1 hourly buckets across the boundary (run from 01:00Z; adjust --since windows)
for w in "90m" "60m" "30m"; do
  echo -n "--since $w : "; docker logs --since $w multi-node-wazuh.master-1 2>&1 \
    | grep -c "Limit of total fields"; done

# Q2 any residual rejections citing the OLD limit after the roll
docker logs --since 2h multi-node-wazuh.master-1 2>&1 \
  | grep "Limit of total fields" | grep -v "^$" | awk '{print $1}' | cut -c1-16 | sort | uniq -c | tail -10

# Q3 limit cited in any surviving errors (1000 vs 2000 discrimination)
docker logs --since 2h multi-node-wazuh.master-1 2>&1 \
  | grep -o "Limit of total fields \[[0-9]*\]" | sort | uniq -c

# Q4 cross-check that silence = success, not pipeline death (docs must grow)
curl -s -k -u admin:P@ssw0rd@ "https://127.0.0.1:9200/wazuh-archives-4.x-2026.08.26/_count"
```

Q3 is the discriminator for failure modes: continued errors citing **[1000]** against
post-roll timestamps mean the new index did NOT get the setting (template failed →
back to phase39-23 F1/F2). Continued errors citing **[2000]** mean the fix works but
true demand exceeds 2000/day (phase39-27 §6 escalation).

## 5. Success / Failure Criteria

| Verdict | Condition |
|---|---|
| PASS | ≥2 consecutive hourly buckets = 0 rejections AND Q4 count increasing AND no post-00:05Z [1000] residuals beyond drain window |
| FAIL-A | post-roll errors cite [1000] → inheritance failure; execute phase39-27 §5 playbook |
| FAIL-B | post-roll errors cite [2000] sustained >1hr → capacity escalation phase39-27 §6 |
| INCONCLUSIVE | zero errors AND zero doc growth → check Filebeat/queue health first (phase39-25 §3) before crediting the fix |

Known-unrelated noise to exclude from counts: `wazuh-remoted: ERROR: Unable to open
file: 'etc/shared/mac-clients/merged.mg' … (Permission denied)` repeating every 10s
(pre-existing, tracked separately; unrelated to ingest chain).

## 6. Verdict

**PENDING.** Baseline frozen (§2); signature model defined (§3) including the honest
tail-end caveat; discriminators pre-agreed (§4–5). First measurable window:
2026-08-26 00:00–01:00Z; verdict window closes after two clean hours (~02:05Z).
