# Phase 38-25 — Field Error / decoder_order_size Claim Verification

**Report ID:** phase38-25-field-claim-verification
**Phase:** 38
**Title:** Phase 38-25 — Field Error / decoder_order_size Claim Verification
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T20:30:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-25-field-claim-verification.md`
**Retention Class:** LONG

**Date:** 2026-08-25 ~20:35 UTC
**Scope:** Verify effective decoder_order_size, error counts/rates, post-restart behavior, manager health, and the attribution of the fix.
**Verifier:** Phase 38 automated verification (commands executed live)

---

## Claims Under Verification

| # | Claim | Status | Evidence |
|---|-------|--------|----------|
| 1 | `analysisd.decoder_order_size=512` staged in local_internal_options.conf | **VERIFIED** | container grep output |
| 2 | ~1281 current field-error log lines | **CONTRADICTED (undercount)** | actual: 8746 lifetime / 4491 in last 30 min |
| 3 | Error rate ~100/min and continuing post-restart | **PARTIAL** — direction VERIFIED, magnitude low | measured ≈150/min over 30 min and 5-min windows |
| 4 | "Too many fields" is the error signature | **CONTRADICTED (wrong string)** | actual: `Limit of total fields [1000] has been exceeded` |
| 5 | decoder_order_size=512 is the relevant knob for these errors | **CONTRADICTED (misattribution)** | errors originate at the indexer mapping layer, not analysisd |
| 6 | Manager healthy otherwise | **VERIFIED** | container Up 24 h; full-stack healthcheck FAIL count 0 |

---

## Evidence Detail

### 1. Staged value
```
$ docker exec multi-node-wazuh.master-1 grep -i decoder /var/ossec/etc/local_internal_options.conf
analysisd.decoder_order_size=512
```
The staged setting exists exactly as claimed. **VERIFIED** as a config fact.

### 2–3. Actual counts and rates
```
$ docker logs multi-node-wazuh.master-1 2>&1 | grep -c "Too many fields"
0

$ docker logs multi-node-wazuh.master-1 2>&1 | grep -c "Limit of total fields"
8746

$ docker logs multi-node-wazuh.master-1 --since 30m ... | grep -c "Limit of total fields"
4491        → ≈ 150/min

$ docker logs multi-node-wazuh.master-1 --since 5m ... | grep -c "Limit of total fields"
749         → ≈ 150/min
```
The claimed "~1281 current logs" matches neither the literal pattern (zero hits) nor the real cumulative volume (8746). The claimed rate (~100/min) understates the measured steady state (~150/min across both the 30-minute and 5-minute windows — consistent, so not bursty). Errors are unambiguously ongoing right now, i.e., post-any-restart continuation holds in spirit. Counts: **CONTRADICTED**; rate: **PARTIAL** (continuation verified, magnitude off by ~50%).

### 4–5. What the error actually is — critical finding
Sample log line (from `docker logs`, WARN `[elasticsearch] filebeat client.go:408`):
```
Cannot index event publisher.Event{... Meta:{"pipeline":"filebeat-7.10.2-wazuh-archives-pipeline"}
... "event":{"dataset":"wazuh.archives"} ...
(status=400): {"type":"illegal_argument_exception",
              "reason":"Limit of total fields [1000] has been exceeded"}
```
Attribution facts established live:
- Emitter: **Filebeat inside wazuh.master**, rejected by the indexer with HTTP 400.
- Pipeline/dataset affected: `wazuh-archives-pipeline` / `wazuh.archives` only (all sampled failures).
- Root cause class: OpenSearch index mapping limit `index.mapping.total_fields.limit` = **1000** exceeded on `wazuh-archives-*` indices.
- Producer driving field explosion: Ubiquiti kick/noise events (`rule 120531/120532`, `data.ubiquiti.kick_*` fields) landing via archives pipeline.

`decoder_order_size` is an **analysisd** memory/allocation knob on the manager's decode stage. It cannot alter indexer-side mapping limits. Setting it to 512 may be defensible for unrelated memory reasons but is **not the mechanism that would stop these errors**, and no amount of analysisd tuning will. The correct levers are: raise `index.mapping.total_fields.limit` (or use flatten/nested-field discipline / discard-mapping for archives), or suppress the Ubiquiti noise at rule/archive level. **Claim 5 CONTRADICTED as stated.**

### Timing note
```
$ docker inspect multi-node-wazuh.master-1 --format '{{.State.StartedAt}}'
2026-08-24T20:20:07Z
$ stat -c '%y' local_internal_options.conf (in container)
2026-08-25 19:01:51 UTC     ← edited AFTER container start
```
The staged file was modified ~23 h into the running container's life. Unless analysisd was restarted after 19:01Z through another path, the running process predates the edit; regardless, this knob would not change indexer behavior even when loaded.

### 6. Manager health
Container `Up 24 hours`; `full-stack-healthcheck.sh` run this session reports `FAIL count: 0`; cluster GREEN (see phase38-26 allocation output). Analysisd continues processing (archives advancing normally). **VERIFIED.**

---

## Verification Commands Used
```bash
docker logs multi-node-wazuh.master-1 2>&1 | grep -c "Too many fields"
docker logs multi-node-wazuh.master-1 2>&1 | grep -ciE "too many fields|decoder_order_size|field_limit"   # all 0
docker logs multi-node-wazuh.master-1 2>&1 | grep -c "Limit of total fields"
docker logs multi-node-wazuh.master-1 --since 30m 2>&1 | grep -c "Limit of total fields"
docker logs multi-node-wazuh.master-1 --since 5m  2>&1 | grep -c "Limit of total fields"
docker logs multi-node-wazuh.master-1 --since 60m 2>&1 | grep "Limit of total fields" | head -1   # full sample line
docker exec multi-node-wazuh.master-1 grep -i decoder /var/ossec/etc/local_internal_options.conf
docker inspect multi-node-wazuh.master-1 --format '{{.State.StartedAt}}'
timeout 60 bash ops/scripts/full-stack-healthcheck.sh
```

## Summary
The problem is real, ongoing, and slightly worse than reported (~150/min vs ~100/min; thousands of occurrences, not ~1281). More importantly, the recorded diagnosis is misattributed: these are **indexer mapping-limit rejections (total_fields=1000) from Filebeat→OpenSearch on wazuh-archives**, not analysisd decoder-order exhaustion. `decoder_order_size=512` is staged but is not the operative fix. Resolution claims based on that knob should be treated as **incorrect until an indexer-side remediation lands**.

## No secrets
