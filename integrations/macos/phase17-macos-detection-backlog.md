# Phase 17 macOS Detection Backlog

Date: 2026-08-16

| # | Detection | Data source | Priority | Status |
|---|---|---|---|---|
| 1 | TCC permission changes (tccd decoder exists) | unified log tccd | HIGH | decoder ready |
| 2 | Login/lock/unlock events (loginwindow decoder) | syslog loginwindow | MED | decoder ready |
| 3 | sudo usage | syslog sudo | MED | decoder ready |
| 4 | Screensharing (screensharingd) | syslog | MED | decoder ready |
| 5 | Gatekeeper/translocation bypass | unified log | LOW | needs rule |
| 6 | LaunchAgent/Daemon persistence | unified log | LOW | needs rule |

## Status

- Decoders exist in ruleset (0580-macos_decoders.xml): tccd, loginwindow,
  screensharingd + sudo.
- Rules: 0960-macos_rules.xml present (coverage review needed).
- Telemetry: macos localfile restored (P17.13) - unified events flowing.

## Next

- Validate tccd/loginwindow rules fire on real events (7d measure).
- Add high-value rules (TCC changes, persistence).

## No secrets
