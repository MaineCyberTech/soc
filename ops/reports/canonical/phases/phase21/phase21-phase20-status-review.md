# Phase 21 Phase-20 Status Review

Date: 2026-08-19
Reviewed against: `final-phase20-operator-report-20260819-063619.md` + live data.

## 1. Zeek v2.2 (Phase 20 deployed)

- **Holds**: last 30 min = 0 alerts (all v2.2-window alerts were pre-restart backlog). Residual
  subnet-broadcast noise fully eliminated. Phase 20 assessment confirmed.

## 2. Suricata (Phase 20 proven ingest)

- Held per Phase 20 (symlink/cron stable, ingest proven). No change this preflight; follow-up
  in Phase 21.15.

## 3. Retention (Phase 20 validated)

- Held. archives-14d on new indices, alerts 30d, flow 14d. No drift.

## 4. Windows 014 Sysmon EventID 7 (NEW TOP - Phase 20 identified)

- **Phase 20 finding confirmed and escalated**: flood resumed at 06:00 (573,809/24h). Top
  paths all standard/system - supports targeted-exclude tuning, not full disable. Phase 21
  will create the tuned `sysmon-mct.xml` + operator steps (apply blocked on endpoint access).

## 5. macOS 015 (Phase 20 blocked)

- Unchanged - still offline, fix blocked on Mac access. Handoff docs current.

## 6. NetFlow scope (Phase 20 blocked)

- Unchanged - operator confirmation still pending; alerting unarmed.

## 7. mct-portal Redis (Phase 20 owner-blocked)

- Unchanged ~10K/day, level 3.

## 8. Repo / CI (Phase 20 audit findings)

- **Still open**: 81 uncommitted files; local CI false-PASS; unpinned-image check red + stale;
  hardcoded creds unremediated. These are Phase 21's core workstreams.

## Verdict

Operational signal work held (Zeek clean, Suricata proven, retention valid). The two live
action items are the ongoing 014 Sysmon flood and the repo/credential/CI hygiene backlog.
Phase 21 focus correct.

## No secrets