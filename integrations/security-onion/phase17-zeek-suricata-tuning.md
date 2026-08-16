# Phase 17 Zeek/Suricata Tuning

Date: 2026-08-16

## Zeek

- Ingest works (71k docs/24h, decoder zeek-conn).
- **No rules fire** - owlh rules need bro_engine; our decoder sets zeek.*.
- Fix options:
  a) Add bro_engine field to decoder (would fire 66004 on EVERY conn = noise).
  b) Add targeted zeek rules (recommended): new-subnet alert, unusual ports,
     high-volume talkers - using zeek.uid/zeek.ts/conn fields.

## Suricata

- eve.json path broken (timestamped files). Fix: symlink or config path.
- Once read: suricata alerts will flow as JSON - validate rule coverage.

## Decision (this phase)

- No rule changes applied (measurement-first). Backlog created.

## No secrets
