# Phase 17 Zeek DNS/HTTP Expansion Plan

Date: 2026-08-16

## Status: PLAN ONLY - not enabled (avoid data.id collisions)

## Why deferred

- Current ingest: conn.log only via zeek-forward. Adding dns.log/http.log
  increases volume substantially.
- Zeek conn data currently has NO alert coverage - fix alerting first.
- data.id collision risk noted in prior phases - verify decoder field names.

## Plan (when authorized)

1. Add zeek-forward entries for dns.log + http.log (tagged DNS/HTTP).
2. Add decoders (zeek-dns, zeek-http) mirroring zeek-conn pattern.
3. Add rules: DNS anomalies (NXDOMAIN spikes), HTTP to unusual ports.
4. Measure volume before/after; verify no field collisions.

## No secrets
