# Phase 40 Rejection Before/After — The Flatline Proof

**Report ID:** phase40-08-rejection-before-after
**Phase:** 40
**Title:** Phase 40 Rejection Flatline Proof — ~150/min Stream Ends at 00:00:01.431Z; Every Post-Roll Window Reads ZERO
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T01:58:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Claims:** VERIFIED (MEASURED)
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-08-rejection-before-after.md`

---

## 1. Channel Note (methodology carried from P39)

Counting channel = **docker logs of `multi-node-wazuh.master-1`** (Filebeat stdout).
The in-container `ossec.log` carries zero such lines; any other channel reads as a
false flatline (phase39-24 §2).

## 2. BEFORE — Baselines

| Window | Count | Source |
|---|---|---|
| last 10 min (frozen) | **1503** (~150/min) | phase39-24 §2, frozen Aug-25 22:50–55Z |
| last hour (frozen) | **8960** | phase39-24 §2 |
| visible total (rotation window, frozen) | 9109 | phase39-24 §2 |
| 60m window spanning cutover (00:45–01:00Z take) | **1761** | OPERATOR-STATE verified-results record |
| per-minute histogram, final pre-roll minutes | see §3 | MEASURED |

## 3. THE HISTOGRAM (MEASURED this session, full retained docker logs)

```
$ docker logs multi-node-wazuh.master-1 | grep "Limit of total fields" \
    | awk '{print $1}' | cut -c1-16 | sort | uniq -c | sort -k2 | tail -8
  148 2026-08-25T23:53
  149 2026-08-25T23:54
  151 2026-08-25T23:55
  148 2026-08-25T23:56
  150 2026-08-25T23:57
  152 2026-08-25T23:58
  150 2026-08-25T23:59
    3 2026-08-26T00:00        ← final three, all against the OLD index
```

```
$ docker logs multi-node-wazuh.master-1 | grep "Limit of total fields" | tail -1 | cut -c1-19
2026-08-26T00:00:01.431Z
$ docker logs multi-node-wazuh.master-1 | grep -c "Limit of total fields"
8640                      (retained rotation window; older lines rotated out)
```

Timeline alignment: new index created **00:00:02.420Z**; the LAST rejection fired at
**00:00:01.431Z** — against the saturated `08.25 [1000]` target, i.e., the predicted
short residual drain, ending ~1 second BEFORE the new index existed.

Error signature verbatim (tail sample):

```
2026-08-26T00:00:01.431Z WARN [elasticsearch] elasticsearch/client.go:408 Cannot index event …
(status=400): {"type":"illegal_argument_exception","reason":"Limit of total fields [1000] has been exceeded"}
```

## 4. AFTER — Post-Roll Windows (all MEASURED)

| Window (taken ~01:32–01:44Z) | Command | Count |
|---|---|---|
| last 10 min | `docker logs multi-node-wazuh.master-1 --since 10m \| grep -c "Limit of total fields"` | **0** |
| last 30 min | same with `--since 30m` | **0** |
| last 40 min (incl. post-restart span) | `--since 40m` | **0** |
| last 60 min (starts 00:32Z > last rejection) | `--since 60m` | **0** |
| worker container, 90 min | `docker logs multi-node-wazuh.worker-1 --since 90m \| grep -c …` | **0** |
| retained-log grand total vs P39's 9109 | full `docker logs \| grep -c` | 8640, ALL pre-cutover |

Note: master container was recreated 01:00:05Z (RestartCount=0 → manual redeploy);
docker json-file logs persist across restarts, so pre-midnight evidence remains intact.

## 5. Classification

**FLATLINED for post-template indices.** Zero "Limit of total fields" events exist
anywhere after 00:00:01.431Z on ANY container channel. Residual `[1000]`-citing errors
are impossible going forward except transiently against legacy saturated indices
(08.19–08.25) during their final hours — none observed even there after midnight,
because Filebeat routes by event timestamp and no longer targets them.

## 6. Verdict

**COMPLETE — PASS.** Flip-condition G2 satisfied: zero post-roll buckets, docs growing
(phase40-09), residuals bounded exactly as predicted.
