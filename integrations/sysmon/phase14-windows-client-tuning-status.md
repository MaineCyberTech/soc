# Phase 14 Windows Client Tuning Status

Date: 2026-08-16

## Suppressions (final, 05:40 UTC)

| Rule | Suppresses | Match condition | Scope |
|---|---|---|---|
| 121105 | 92153 (VaultCli) | Image: C:\Windows\(System32|SystemApps|ImmersiveControlPanel|UUS) \| Image: C:\Program Files \| OneDrive | all Windows agents |
| 121106 | 92900 (Lsass/Defender) | MsMpEng | all Windows agents |

## Debugging history (what failed)

1. `<field>` in if_sid child -> rule never fired (field conditions not matched).
2. `overwrite="yes"` on 92153/92900 in local_rules -> CLOBBERED (ruleset loads
   after etc/rules and re-defines originals).
3. `agent.id`/`agent.name` fields -> invalid syntax in rules.
4. WORKING: `<match>` + `<if_sid>` + level 0 (Wazuh's own suppression pattern).

## Measurement status

- Pre-suppression baseline: 92153 ~60-100/24h per Windows agent.
- Post-suppression (05:40): pending real-event validation (both Windows hosts
  idle). Target: < 10 level>=9/day.
- Malicious-variant test: C:\Windows\Temp or unknown-path VaultCli loads STILL
  alert (not in match list) - verify on next event or via logtest in later cycle.

## Readiness gate (external Windows monitoring expansion)

- [ ] 7-day re-measure: < 10 level>=9/day sustained
- [ ] Non-system VaultCli variant still alerts (proven)
- [ ] Dashboards W1/W2 built (P14.08)
- [ ] PS ScriptBlockLogging measurement (deferred)

## No secrets
