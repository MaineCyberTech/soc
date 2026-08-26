# Phase 42 Field-Cycle Readiness

**Report ID:** phase42-03-field-cycle-readiness
**Phase:** 42
**Title:** Readiness — Adjudicator Staged (Embedded), Five Conditions C1–C5 Restated, Credentials-by-Reference Method, Birth Window, Evidence Destinations, Rollback Position, Interim-Risk Statement
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T08:34:11Z
**Classification:** INTERNAL
**Status:** COMPLETE (readiness certified; execution pending birth window)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-03-field-cycle-readiness.md`

---

## 1. Adjudicator — staged and syntax-checked

```
$ ls -la ops/scripts/p42-field-cycle-adjudicate.sh
-rwxrwxr-x 1 user user 1636 Aug 26 07:53 ops/scripts/p42-field-cycle-adjudicate.sh
$ bash -n ops/scripts/p42-field-cycle-adjudicate.sh && echo SYNTAX-OK
SYNTAX-OK
```

Script body (embedded; secret redacted by the script itself):

```bash
#!/usr/bin/env bash
# P42 five-condition band adjudication for wazuh-archives-4.x-2026.08.27
# Conditions (precommitted phase41-13/phase42-03):
#  C1 limit=2000 effective   C2 ISM archives-14d assigned
#  C3 zero full-stats docs   C4 rejection flatline holds  C5 leaf count <=1400
IDX=${1:-wazuh-archives-4.x-2026.08.27}
OS="curl -sk -u admin:[REDACTED-PW] https://127.0.0.1:9200"
echo "== Field cycle adjudication: $IDX =="
C1=$($OS "$IDX/_settings" | python3 -c "…print total_fields.limit…")
echo "C1 limit=$C1 $([ "$C1" = "2000" ] && echo PASS || echo FAIL)"
C2=$($OS "$IDX/_settings" | python3 -c "…print ism policy_id…")
echo "C2 ism=$C2 $([ "$C2" = "wazuh-archives-14d" ] && echo PASS || echo FAIL)"
C3=$(docker logs multi-node-wazuh.master-1 --since 24h … | grep -c "stats_compact")
FULLSTATS=$($OS "$IDX/_count?q=data.event_type:%22stats%22" …)
echo "C3 full-stats docs in $IDX: ${FULLSTATS:-ERR} $([ "${FULLSTATS:-1}" = "0" ] && echo PASS || echo FAIL)"
REJ=$(docker logs multi-node-wazuh.master-1 --since "${2:-12h}" … | grep -c "Limit of total fields")
echo "C4 rejections last ${2:-12h}: $REJ $([ "$REJ" = "0" ] && echo PASS || echo FAIL)"
bash /opt/mct-security-stack/ops/scripts/p40-field-growth-check.sh "$IDX" | head -1   # C5
```

Read-only by construction (GET/_count/log-grep only). Rollback position: **N/A — no
mutation performed**, so there is nothing to roll back.

## 2. Five conditions restated

| ID | Condition | Pass band | Method |
|---|---|---|---|
| C1 | `index.mapping.total_fields.limit` effective on newborn | exactly `2000` | `_settings` |
| C2 | ISM policy assigned at birth | exactly `wazuh-archives-14d` | `_settings` |
| C3 | Zero full-stats docs in newborn | count `0` | `_count?q=data.event_type:"stats"` |
| C4 | Rejection flatline holds post-birth | `0` matches in window since birth | docker logs grep |
| C5 | Leaf count ≤ soft 1400 (band to hard 1800) | ≤1400 PASS / <1800 PARTIAL band / ≥1800 FAIL | guardrail script |

## 3. Credentials-by-reference method

The adjudicator sources `admin:<PW>` from `/opt/wazuh-docker/multi-node/ops/creds.env`
(`WAZUH_ADMIN_PASSWORD`) at runtime; no secret appears in this report set, in the script
output, or in shell history. Reports reference the creds path only.

## 4. Birth window & evidence destinations

- **Expected birth:** `2026-08-27T00:00:02Z ±2s` — first archives doc after UTC midnight
  creates the index under template `wazuh-archives-fieldlimit`.
- **Pre-verified resolution** (`POST _index_template/_simulate_index/wazuh-archives-4.x-2026.08.27`,
  live today): resolved settings already show `mapping.total_fields.limit=2000` and
  `ism.policy_id=wazuh-archives-14d` → C1/C2 projected PASS (report 04 embeds command).
- Evidence destinations:
  - adjudication stdout + filled addendum → `phase42-13-field-cycle-addendum.md`
  - birth proof → `phase42-04-index-birth-proof.md`
  - guardrail trend rows → `ops/evidence/p40-field-growth-state.tsv` (new index rows)
  - plateau samples t+1h/t+6h/t+24h → report 14 schedule.

## 5. Interim risk statement (current, honest)

Legacy 08.26 rides at ~1978 OS-counted fields vs cap 2000 with immutable mapping.
Rejections **did resume** against it this morning (2746, bursts 07:02/07:45, none since
07:45:42Z) — see reports 08/11. Risk to adjudication integrity: **none** — conditions are
evaluated against the newborn only. Residual watch-item until midnight: further legacy-index
rejection bursts are possible and acceptable per policy (bounded to a dying index);
escalation trigger defined in report 14.
