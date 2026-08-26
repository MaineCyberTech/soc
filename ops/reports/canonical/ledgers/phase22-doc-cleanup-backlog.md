# Phase 22 Doc Cleanup Backlog

Date: 2026-08-22

## P0 (correctness)
1. Evidence banners: 0/122 applied - correct the v1.0.0 RELEASE-NOTES claim via addendum;
   schedule banner application with evidence-hygiene approval.
2. Client-dir hygiene: move internal artifacts (whitelabel samples, telemetry summaries with
   real endpoint names) to reporting/output/internal/ or scrub; add
   `Classification: CLIENT CONFIDENTIAL` to 33 headerless files in reporting/output/client/.
3. Branding neutralization: replace real brand in brand.example.yml + 12 brandable templates
   with config-driven placeholders; remove hardcoded endpoint names from render-branded-template.py;
   stop --email mode overwriting committed templates.

## P1 (source of truth)
4. STACK-OVERVIEW.md: update header date + agent inventory (011-015) + P22 state (Zeek v2.2,
   ISM retention, secret abstraction, image pinning).
5. ARCHITECTURE.md: add agents 013/014/015 + P18-22 subsystems; bump date.
6. RELEASE-NOTES v1.1.0: add local bundle path; reconcile package-portable-repo.sh OUT path
   with /home/user/mct-security-releases/; restore explicit deployment date in README.

## P2 (consistency)
7. Align phase22-windows014-applied-config.xml <-> sysmon-mct.xml naming; add phase22 operator-steps.
8. REPO-MAP: add docs/ dir.
9. Manifest: IRIS license label GPL-3.0 -> LGPL-3.0; fill misp/greenbone sha256 from VM103.

## No secrets