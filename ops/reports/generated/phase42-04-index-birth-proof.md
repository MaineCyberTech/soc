# Phase 42 Index-Birth Proof — PENDING-BIRTH

**Report ID:** phase42-04-index-birth-proof
**Phase:** 42
**Title:** Birth Proof Plan for wazuh-archives-4.x-2026.08.27 — Detection Command Ready, Creation-Timestamp Capture, Matched-Template Verification via _simulate_index (Pre-Resolved Today)
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T08:34:11Z
**Classification:** INTERNAL
**Status:** PENDING-BIRTH (all commands staged; execution ~2026-08-27T00:00Z)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-04-index-birth-proof.md`

---

## 1. State

`wazuh-archives-4.x-2026.08.27` does not exist yet (verified `_cat/indices/wazuh-archives-4.x-*`
at 07:55Z — newest is `2026.08.26`, 467,844 docs / 466.8mb). Birth expected
**2026-08-27T00:00:02Z ±2s**.

## 2. Detection command (ready)

```bash
set -a; . /opt/wazuh-docker/multi-node/ops/creds.env; set +a
curl -sk -u "admin:${WAZUH_ADMIN_PASSWORD}" \
  'https://127.0.0.1:9200/_cat/indices/wazuh-archives-4.x-2026.08.27?h=index,docs.count,store.size,creation.string&v'
```

Expected post-birth row: `creation.string = 2026-08-27T00:00:0X.XXXZ` — captured verbatim
into report 13 addendum as the creation-timestamp evidence line.

## 3. Creation-timestamp capture plan

1. At 00:00:30Z run detection command; embed raw output.
2. Cross-check with `GET /wazuh-archives-4.x-2026.08.27/_settings?filter_path=**.creation_date`
   and convert epoch-millis to ISO-8601 Z.
3. Record delta vs expected window (`00:00:02 ±2s`); any delta >5s is noted but does NOT
   affect C1–C5 (window is informational).

## 4. Matched-template verification — pre-resolved TODAY via simulate

Live proof executed 2026-08-26T08:31Z:

```bash
$ curl -sk -u admin:${PW} -X POST \
  'https://127.0.0.1:9200/_index_template/_simulate_index/wazuh-archives-4.x-2026.08.27'
→ resolved settings:
   mapping.total_fields.limit = 2000        # C1 projection PASS
   plugins.index_state_management.policy_id = wazuh-archives-14d   # C2 projection PASS
```

(Note: endpoint requires POST on this OpenSearch build; GET returns 405 — recorded so
tomorrow's operator does not re-trip on it.)

Template landscape matching `wazuh-archives-4.x-*` (from `_cat/templates`): `wazuh`,
`wazuh-archives-fieldlimit`, `wazuh-archives-p19-retention`, `wazuh-main`. The fieldlimit
template carries the two certification-critical settings; simulate proves they win at
birth. Post-birth confirmation compares live `_settings` against this simulate snapshot
byte-for-byte.

## 5. Contrast baseline (why birth proof matters)

Legacy `2026.08.26` ISM explain returns `policy: None` — it predates the fieldlimit
template. The newborn MUST show the policy attached; that single contrast closes the
P41 finding that containment settings only bind at index creation.
