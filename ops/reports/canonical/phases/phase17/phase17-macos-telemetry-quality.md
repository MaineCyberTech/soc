# Phase 17 macOS Telemetry Quality and Group Review

Date: 2026-08-16

## Status: TELEMETRY RESTORED - steady-state low volume (idle Mac)

## Agent 015 (Julians-Air)

| Item | Value |
|---|---|
| Group | mac-clients (config synced, hash 9cb1dd7b) |
| Status | Active |
| LocalFile | macos (unified logging, restored) |
| Queue-full | 0 since 08:40 (initial activation burst resolved) |

## Timeline (today)

- 07:44 enroll -> macos localfile activated -> **117k docs/2h catch-up flood**
  (airportd, level, cloudd system noise) -> queue-full alerts (rule 203/204).
- 08:13 fix attempt -> /var/log/system.log localfile -> **0 docs** (file
  absent/idle on modern macOS) + 2 residual queue alerts.
- 08:40 reverted to macos localfile -> config synced, **0 queue alerts**,
  steady-state low volume on idle workstation.

## Assessment

- The flood was a one-time historical catch-up (log stream replays recent
  unified entries). Steady state scales with activity.
- macOS unified logging is inherently verbose; all entries land at rule 1002
  (level 0, archive-only) - storage impact ~117k docs/2h one-time, then low.
- Group config correct (mac-clients); Level.io action should pass
  WAZUH_AGENT_GROUP=mac-clients (done for 015).

## Recommendation

- Monitor 7d: expect low steady volume; if volume spikes recur, add a
  predicate-based log stream command to filter high-value events only.

## Files

- integrations/wazuh/phase17-mac-clients-group-review.md (created)

## No secrets
