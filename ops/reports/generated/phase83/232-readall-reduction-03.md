Report ID: P83-readall-reduction-03
Phase: 83
Title: Phase 83: Readall Reduction
Date: 2026-08-31
Timestamp UTC: 2026-08-31T08:29:41Z
Timestamp ET: 2026-08-31T04:29:41 EDT
Classification: INTERNAL
Status: PASS
Source Path: ops/reports/generated/phase83/232-readall-reduction-03.md
Prompt: /home/user/mct-p83/prompts/232-readall-reduction-03.md

## Summary
Outcome: readall was BOTH reduced (mapping scope) AND exception-governed (time-bound exception).

## Reduction
The `readall` role is reserved/static; a PUT to scope its index_patterns away from '*' returns 403, so the wildcard cannot be reduced at the role level. Reduction was therefore applied at the mapping layer: the backend_role catch-all `readall` was removed, so `kibanaro` no longer inherits the readall '*' grant. Only the explicit service user `readall` retains it.

## Exception
The residual readall grant is governed by a time-bound EXCEPTION that EXPIRES 2026-09-30. Review/removal is required on or before that date.

## Evidence
Reference: ops/reports/evidence/phase83/phase83-evidence-rbac.json (wildcard_reduced_or_exception=true; exception_expiry_or_na=2026-09-30).

## Status
PASS - readall reduced and exception-governed with expiry 2026-09-30.
