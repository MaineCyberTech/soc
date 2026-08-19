# Index Retention Policy Runbook

Applies to: MCT Wazuh/OpenSearch cluster (OpenSearch ISM, not Elasticsearch ILM).
Owner: SOC operator. Last review: Phase 20 (2026-08-19).

## Current policies

| Policy | Index patterns | Hot | Delete | Applied via |
|---|---|---|---|---|
| wazuh-retention | wazuh-alerts-4.x-* | - | 30d | wazuh-main template (pri 300) |
| wazuh-archives-14d | wazuh-archives-4.x-* | - | 14d | wazuh-archives-p19-retention template (pri 310) |
| elastiflow | elastiflow-* | rollover 1d/20GB + force_merge | 14d | elastiflow template |
| wazuh-states-retention | wazuh-states-* | - | (states) | - |

## Verify

```bash
# policy list
curl -sku admin:${WAZUH_ADMIN_PASSWORD} https://127.0.0.1:9200/_plugins/_ism/policies
# effective policy on an index (authoritative = _settings)
curl -sku admin:${WAZUH_ADMIN_PASSWORD} https://127.0.0.1:9200/wazuh-archives-4.x-<date>/_settings?filter_path=*.settings.index.plugins
# ism managed state
curl -sku admin:${WAZUH_ADMIN_PASSWORD} https://127.0.0.1:9200/_plugins/_ism/explain/wazuh-archives-4.x-<date>
```

Note: `_settings` is authoritative for the assigned policy_id; `_plugins/_ism/explain` may
show the previously-assigned policy until the ISM job re-attaches. Check both.

## Change retention window (e.g. archives 14d -> 30d)

1. Create/update the policy with the new `min_index_age` in the hot->delete transition.
2. Update template `wazuh-archives-p19-retention` `policy_id` if policy renamed.
3. Existing indices keep their assigned policy until re-created (conservative; new indices get new policy).
4. Optionally `POST _plugins/_ism/add` or restart ISM job to re-evaluate (check version docs).

## Rollback (restore 30d everywhere)

1. `PUT _plugins/_ism/policies/wazuh-archives-14d` -> set delete `min_index_age: 30d` (or point
   template to wazuh-retention).
2. `PUT _plugins/_ism/policies/elastiflow` -> delete `min_index_age: 30d`.
3. Verify new indices get the 30d policy.

## Tradeoff

Archives = raw-event forensic store; 14d shortens raw retention. Alerts keep 30d. DFIR cases
snapshot evidence at creation. Reversible via this runbook.

## No secrets