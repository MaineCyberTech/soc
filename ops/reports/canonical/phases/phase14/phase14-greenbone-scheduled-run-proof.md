# Phase 14 Greenbone Scheduled Run Proof

Date: 2026-08-16 06:30 UTC
Status: **PROVEN - SCHEDULED RUN EXECUTED**

## Scheduled run evidence (via gvmd GMP, VM 103)

| Item | Value |
|---|---|
| Task | MCT-lab-weekly-sun-0600 |
| Attached task | MCT-lab-scan-242 (target MCT-lab-vuln-target-242) |
| **Scheduled report id** | **a2020145-41a5-4d89-a6e1-b6b4b4bd65c4** |
| Report name | 2026-08-16T06:00:00Z |
| **Creation time** | **2026-08-16T06:00:00Z** (exact scheduled time - NOT the manual proof) |
| Scan start | 2026-08-16T06:00:05Z |
| Scan status | Done (progress 100%) |
| Hosts | 1 |
| **Vulnerabilities** | **14** (info-level; 0 critical/high) |
| Ports | 3 |
| Closed CVEs | 0 |

## Comparison vs manual proof

- Manual proof (00aa2e0b): 2026-08-16T00:57:55Z, 16 info findings.
- Scheduled run (a2020145): 2026-08-16T06:00:00Z, 14 info findings.
- Findings differ slightly (host state) but consistent - no critical/high.

## Alert behavior

- MCT-Critical-to-Shuffle (severity >= 9.0): correctly NOT fired (no critical
  findings). Consistent with no-alert expectation.

## Conclusion

- Weekly scheduled scanning is PROVEN operational (first automatic run).
- Recurrence: next run 2026-08-23 06:00 UTC (FREQ WEEKLY).

## No secrets

No secret values printed.
