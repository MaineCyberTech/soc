# Greenbone Remediation & Verification Workflow

## Flow

```text
Critical finding (>= 9.0, internet-facing) -> webhook -> Shuffle -> IRIS Class A
  -> remediation (manual approval) -> post-remediation verification scan
  -> vulnerability-review monthly report
```

## Steps

1. **Triage** (IRIS case, critical-vulnerability template):
   - Confirm CVE + asset; check exploit availability (MISP/NVD).
   - Determine exposure (internet-facing list: mct-portal 138.197.105.82,
     SKK 23.150.201.36, LBM-Dock 23.150.201.165; internal otherwise).
2. **Remediation** (manual approval required for any isolation/block):
   - Patch package/version; apply compensating control; track in case.
3. **Verification scan**:
   - Greenbone task with `post-remediation verification` profile on the target.
   - Run within 5 days of fix.
   - Confirm finding cleared (or documented as still-present with risk accepted).
4. **Reporting**:
   - Export scan report (CSV/PDF) to reporting/output/greenbone-*.
   - Aggregate monthly into vulnerability-review template.

## Critical path to IRIS

- Notify-only mode preserved: no automated patch/block.
- Tested/planned: webhook route documented (d5-critical-test-payload.json);
  Greenbone critical alert ACTIVE (MCT-Critical-to-Shuffle, severity >= 9.0 -> Shuffle webhook) - validated 2026-08-15.
- If Shuffle degraded: manual IRIS case from raw finding payload.

## Safety

- Infrastructure devices: non-invasive only.
- No scan credentials in docs.
- OpenCanary/UniFi FP suppression in place for scanner IP.
