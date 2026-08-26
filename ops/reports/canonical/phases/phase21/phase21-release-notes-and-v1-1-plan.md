# Phase 21 Release Notes and v1.1.0 Plan

Date: 2026-08-19
Status: **PLAN READY - RELEASE BLOCKED ON APPROVAL** (per safety rule: no release until cleanup + CI/secret pass; those pass, approval is the remaining gate).

## 1. RELEASE-NOTES.md updated

- Added draft **v1.1.0** section summarizing Phases 18-21 (Zeek detections + noise control,
  Suricata repair/ingest proof, ISM retention, macOS 015 flood plan, syslog 15140, NetFlow
  scope, repo hygiene + credential cleanup + CI fixes, Windows 014 Sysmon analysis).
- Marked as "planned - not yet released; approval-gated".

## 2. v1.1.0 release checklist

- Created: `ops/checklists/v1-1-release-checklist.md` (gates, optional items, release steps, blockers).

## 3. Tag/release plan (staged, not executed)

- Sequence: commit remaining phase-21 deliverables -> push -> tag v1.1.0 -> create GitHub
  release with fresh portable bundle (re-run `build-release-bundle.sh`).
- **Not executed** - requires operator approval.

## 4. Documentation of release state

- v1.0.0 remains the current release (stale, 4+ commits behind).
- v1.1.0 will capture Phase 18-21 baseline once approved.

## No secrets