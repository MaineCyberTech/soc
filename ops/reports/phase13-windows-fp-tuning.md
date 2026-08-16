# Phase 13 Windows False Positive Tuning

Date: 2026-08-16

## Status: SUPPRESSION APPLIED (pilot-only, agent 012)

## Findings (24h measurement, agent 012)

| Rule ID | Description | Count/24h | Assessment |
|---|---|---|---|
| 92153 (lvl 10) | VaultCli.dll load | 69 | FP - loaded by MANY legit Windows processes (backgroundTaskHost 27x, Edge WebView, taskhostw, OneDrive, Widgets, RuntimeBroker, SecurityHealth, SearchHost, MoUsoCoreWorker) |
| 92900 (lvl 12) | Lsass accessed w/ read perms | 14 | FP - Defender (MsMpEng.exe) scans lsass legitimately |
| 92058 (lvl 12) | AppCompat sdbinst | 5 | Benign app compat - monitor |

## Applied changes (manager local_rules.xml, backed up 20260816)

1. **Rule 121105** (level 0, overwrite): suppresses 92153 when image matches
   legitimate system paths (System32|Program Files|WindowsApps|OneDrive|
   RuntimeBroker|SecurityHealth|SearchHost|MoUsoCoreWorker|backgroundTaskHost|
   taskhostw). [NOTE: Wazuh rules cannot filter agent.id - scoped by event content]
2. **Rule 121106** (level 0, overwrite): suppresses 92900 when sourceImage
   matches MsMpEng.exe/Windows Defender.

- Analysisd syntax check: 0 errors.
- Manager restarted 2026-08-16 ~03:56 UTC to load rules.
- Scope: event-content scoped (all Windows agents: pilot 012 + client 013).
- Added 2026-08-16: client 013 (SAMSUNG) deployed via Level.io - protected by same rules.

## Verification

- No new 92153/92900 alerts since restart (agent 012 idle - events sparse).
- Definitive proof: next natural VaultCli/Lsass event from agent 012 will be
  suppressed (check alert absence + rule 121105/121106 firing at level 0).

## Re-measure plan (7 days)

- Query: agent.id=012, rule.level>=9, count by rule.id.
- Target: < 10 level>=9 alerts/day (was 88-100/day).
- If target met: extend suppression review for Windows readiness gate.

## No secrets

No secret values printed.
