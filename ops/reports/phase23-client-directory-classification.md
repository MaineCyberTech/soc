# Phase 23 Client Directory Classification

Date: 2026-08-22
Scope: reporting/output/client/*

## Classification

| Class | Definition | Files |
|---|---|---|
| CLIENT-SAFE | deliverable-ready, no internal data | phase22-monthly-scorecard (with header), phase21-monthly-scorecard, phase20-monthly-scorecard (header present) |
| INTERNAL-ONLY | contains internal paths/blockers/workstreams - NOT exportable as-is | phase22/21/20-scorecard-progress, phase19-21 monthly scorecards naming billable endpoints 013/014/015, phase16-whitelabel-sample-scorecard, phase17-branded-client-scorecard (real endpoint names), client-onboarding-summary files, client013-baseline-checkpoint, scorecard-start files |
| TEMPLATE | to render at delivery | reporting/templates/monthly-client-scorecard.md |
| SAMPLE/SYNTHETIC | sample data | phase7/8/9 sample scorecards |
| AUTHORIZATION REQUIRED | scan-related | phase9-first-client-vulnerability-section, client-zero-vulnerability-review |
| HISTORICAL EVIDENCE | past-phase records | all older phaseN-* outputs |

## Findings

- 33/42 files lack `Classification: CLIENT CONFIDENTIAL` header (P22 finding stands).
- Internal-only artifacts (scorecard-progress with blockers, whitelabel samples with real
  endpoint names 013/014/015) sit in an exportable path -> must move to `reporting/output/internal/`
  or be scrubbed before any client delivery.

## Actions (this phase)

- Created `docs/CLIENT-ARTIFACT-GOVERNANCE.md` (classification + rules).
- Moved INTERNAL-ONLY artifacts to `reporting/output/internal/` (below).
- Added missing headers to remaining CLIENT-SAFE files.

## No secrets