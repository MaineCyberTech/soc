# First Scan Export

## Export procedure (after scan completes)

1. Greenbone UI/CLI -> Reports -> select the completed scan.
2. Export CSV (all findings) + PDF (summary) per report type.
3. Save to: reporting/output/greenbone-first-scan-<date>.csv / .pdf
4. Import CSV summary into phase5-vulnerability-review.md.

## Report contents

- Critical/high findings with CVSS + affected asset
- Confirm OpenCanary ports marked FP (canary, not real services)
- Remediation owner + due date per finding
- Post-remediation verification scan (within 5 days of fix)

## Monthly cadence (after first scan)

- Monthly scan runs -> export -> review -> vulnerability-review report.
- Critical >= 9.0 internet-facing -> IRIS (D5 webhook path).
