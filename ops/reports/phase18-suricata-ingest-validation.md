# Phase 18 Suricata Ingest Validation

Date: 2026-08-17

## Status: PATH VALIDATED - SURICATA QUIET (no events yet)

## Validation

| Check | Result |
|---|---|
| eve.json path | FIXED (symlink, no logcollector error) |
| File readable | YES (2 lines - Suricata produces little) |
| JSON decoder | WORKS (alert.*, src/dest extracted - logtest) |
| Events to indexer | 0 (no Suricata alerts generated yet) |

## Why no events

- Suricata has minimal rules/traffic on SO - eve file has 2 lines total.
- When Suricata fires (alert event), it will flow: file -> agent -> json
  decoder -> rules.

## Rule backlog

- integrations/security-onion/phase18-suricata-rule-backlog.md (created)

## No secrets
