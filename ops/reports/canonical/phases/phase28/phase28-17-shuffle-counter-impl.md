# Phase 28 Shuffle Daily Counter Implementation

Date: 2026-08-24
Status: **SPEC READY - UI IMPLEMENTATION PENDING** (C6).

## Design

- Persistent daily counter in Shuffle datastore keyed `mct-zeek-daily-<YYYY-MM-DD>`.
- On each event: increment; if count >= 5/24h: notify (webhook/email) + suppress (DROP,
  no IRIS), do not reset until next UTC day (new key).
- Reset behavior: date-key rotation (no explicit reset needed).
- Complement to the external cron guardrail (same 5/24h threshold).

## Why UI

- Counter node + conditions require the workflow editor (API limitation).

## Validation (after UI)

- 6th synthetic post in a day -> suppressed + notification; next UTC day -> counter resets.

## No secrets