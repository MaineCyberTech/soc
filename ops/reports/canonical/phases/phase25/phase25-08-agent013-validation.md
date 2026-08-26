# Phase 25 Agent 013 Validation

Date: 2026-08-22
Status: **PENDING APPLY OUTPUT** (in progress).

## Targets (post apply)

| Metric | Target |
|---|---|
| EID7 volume | >= 99% drop endpoint-side (< 2K/day) |
| EID1/10 | unchanged/flowing |
| Buffer | 0 flooded events/24h |
| Suspicious samples | LOLBin load LOGGED; unsigned/non-system module LOGGED; known-good signed system load NOT logged |

## Baseline for comparison

- Peak flood: 58,841 EID7 docs/1h (08-22 05:4x). Quiet phase now: 25 alerts/30m.
- EID1 ~605/h, EID10 ~195/h (healthy, must persist).

## SOC-side re-measurement (after apply confirmed)

- EID7 alerts+archives 1h/24h windows for 013 vs baseline.
- Buffer events (rules 202-205).
- Rule-11 throttle messages (013 not currently throttled).

## Decision

- **PENDING** - will be PASS when: EID7 <= 2K/day, EID1/10 intact, buffer clean, marker
  verified (or volume-proven over one flood cycle).

## No secrets