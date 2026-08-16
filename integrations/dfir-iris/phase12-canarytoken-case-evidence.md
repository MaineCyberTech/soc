# Phase 12 Canarytoken Case Evidence (IRIS)

Date: 2026-08-16
Status: NO CASE - T1 not validated (account blocker)

## What exists

- OpenCanary hit evidence in prior phases (rule 121007/121012/121014 firing,
  documented in integrations/opencanary/ and ops/reports).
- Shuffle webhook execution afd4de3c (HTTP 200) - routing path works.

## What is missing

- Hosted token T1 trigger -> canarytokens alert -> Shuffle -> IRIS case chain.
  Blocked on hosted canarytokens.org account (see
  ops/reports/phase12-canarytoken-t1-validation.md).

## On validation (procedure)

1. Trigger T1 (safe lab).
2. Confirm IRIS case auto-created via Shuffle workflow.
3. Save case ID + evidence links here.
4. Document FPs per lifecycle doc.

## No secrets

No secret values printed.
