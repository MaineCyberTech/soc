# Phase 20 Retention Policy Validation

Date: 2026-08-19
Status: **VALIDATED** - Phase 19 ISM changes hold.

## 1. wazuh-archives-14d policy exists

- Policy `wazuh-archives-14d`: default_state hot, transition delete at `min_index_age: 14d`.
- Confirmed present (ISM policy endpoint).

## 2. Template priority / assignment for new indices

- Template `wazuh-archives-p19-retention` (index_patterns `wazuh-archives-4.x-*`, priority **310** > wazuh-main 300) sets `policy_id: wazuh-archives-14d`.
- **08-19 archives index settings verified**: `index.plugins.index_state_management.policy_id = wazuh-archives-14d` (new index correctly picked up the 14d policy).
- Note: `_plugins/_ism/explain` may report the pre-reassignment policy for an index until the ISM job re-attaches; the authoritative index `_settings` are correct (verified). Check both in future audits.

## 3. ElastiFlow policy update

- `elastiflow` policy delete condition: `min_index_age: 14d` (was 30d). Rollover (1d/20GB) + force_merge retained.

## 4. Alerts retention remains 30d

- `wazuh-retention` policy (delete at 30d) still attached via `wazuh-main` (pri 300) for `wazuh-alerts-4.x-*`. Verified on alerts indices.

## 5. Rollback procedure + tradeoff

- Rollback: point `wazuh-archives-p19-retention` template `policy_id` back to `wazuh-retention` (30d) OR delete the template; restore elastiflow policy delete to 30d. See `ops/runbooks/index-retention-policy.md`.
- Tradeoff (documented, from P19): archives are the raw-event forensic store; 14d shortens raw retention. Alerts (triage signal) keep 30d; DFIR cases snapshot evidence at creation. Reversible.

## No secrets