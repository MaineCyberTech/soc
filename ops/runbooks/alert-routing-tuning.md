# Alert Routing Tuning Runbook

Purpose: reduce alert volume safely without weakening detection. Measure -> propose -> apply -> verify.

## Workflow

1. **Measure**: `alert-volume-by-rule.sh 24`; capture `phase4-noise-before.md`.
2. **Propose**: add to `phase4-routing-changes-proposed.md` with expected reduction + risk.
3. **Apply** (only with approval):
   - Rule level override (e.g. level 0 = archive-only): backup local_rules.xml,
     append override group, `wazuh-logtest` validate (correct location!), restart
     analysisd both nodes (compose restart), verify PID + rule count + no errors.
   - Monitor/workflow route change: update OpenSearch alerting monitor or Shuffle workflow branch.
4. **Verify**: capture `phase4-noise-after.md`, compare in `phase4-noise-before-after-comparison.md`.
5. **Protect Class A**: OpenCanary 1210xx, MISP 1211xx, unknown exporter, lateral movement - never suppressed.

## Suppression patterns

| Pattern | Mechanism | When |
|---|---|---|
| Inventory noise (osquery results) | override rule to level 0 (archive) | expected telemetry, children carry signals |
| Churn/roaming | route to Class C digest (monitor/workflow) | keep alert, reduce response effort |
| Benign app messages | route to D (archive) | proven benign (Sentry init, ACME) |
| Flood/storm detection | keep elevated (B/A) | scan/attack indicators |

## logtest tip

Rule chains with `<location>` filters (e.g. osquery `location osquery$`) only
match when the correct location is passed:

```bash
wazuh-logtest -v -l osquery   # for osquery rules
wazuh-logtest -v -l stdin     # default
```

## Wazuh rule change checklist

- [ ] Backup local_rules.xml (timestamped)
- [ ] Override inside a `<group>` block
- [ ] `wazuh-logtest` validates: suppressed rule level 0; children still fire
- [ ] Copy file to master + worker containers
- [ ] Restart analysisd both nodes; verify PID change
- [ ] Cluster green; Total rules loaded without errors
- [ ] Before/after counts in reports
- [ ] Rollback command documented
