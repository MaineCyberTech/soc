# Phase 22 CI Image Policy Enforcement

Date: 2026-08-22

## Change

- `ops/scripts/check-unpinned-docker-images.sh` updated to enforce the Phase 22 classification
  policy:
  - Unclassified unpinned refs = **VIOLATION** -> exit 1 -> CI FAIL.
  - Classified exceptions (F/V/C from `ops/config/unpinned-image-exceptions.txt`) = **warn**,
    exit 0.
- Exceptions moved from prose reports to a machine-readable file
  (`ops/config/unpinned-image-exceptions.txt`) consumed by the checker.
- Covers both compose roots (MCT + wazuh-docker).

## Result

- 0 violations (runtime images pinned by digest - Phase 22.17).
- 21 classified exceptions (warn).
- Local CI: PASS.

## Policy doc

- `docs/CONTAINER-IMAGE-POLICY.md` (categories, enforcement, exceptions process).

## No secrets