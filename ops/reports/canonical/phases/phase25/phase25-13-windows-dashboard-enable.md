# Phase 25 Windows W1/W2 Dashboard Enable

Date: 2026-08-22
Status: **GATED ON TUNING** (C9).

## Gate

- W1 (Windows events) / W2 (Sysmon) dashboards enable only after: 013 + 014 EID7 validated
  (< 2K/day, load confirmed) + throttle retired/retiring.

## What is ready

- Saved-search/query definitions exist (integrations/sysmon backlog docs + phase24 dashboard
  JSONs). Dashboard wiring in OpenSearch Dashboards pending.

## What must NOT happen

- Treating throttled absence as health: dashboards must display buffer status + rule-11
  throttle indicators alongside event counts.

## Decision

- **NOT ENABLED** - gate on tuning validation (phase25-08/11).

## No secrets