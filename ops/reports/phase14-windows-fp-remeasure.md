# Phase 14 Windows FP Re-measure (preliminary)

Date: 2026-08-16

## Status: IN PROGRESS - suppression mechanism fixed, final validation pending

## What happened

P13 suppressions (field-based child rules + overwrite rules) did NOT work:
- VaultCli (92153) kept firing on 013 at 04:50/05:05/05:27-05:37 with legit images.
- Root causes found:
  1. `<field>` conditions in if_sid child rules did not match (rule 121105 never fired).
  2. `overwrite="yes"` on 92153/92900 in local_rules.xml is CLOBBERED - the
     ruleset/ rules load AFTER etc/rules and re-define the originals.
  3. `agent.id`/`agent.name` fields are not valid in Wazuh rules (syntax error).

## Working mechanism (proven)

- Simplified child rule (level 0 + if_sid + no conditions) suppressed real
  events at 05:24 (agent 013 vaultcli load -> no alert).
- Wazuh's own suppression rules (0015-ossec_rules.xml 511/515) use
  `<match>` + `<if_sid>` + level 0 - same pattern now applied.

## Current rules (05:40)

- 121105: suppress 92153 when message matches legit system paths
  (System32|SystemApps|ImmersiveControlPanel|UUS|Program Files|OneDrive).
- 121106: suppress 92900 when message contains MsMpEng.
- Loaded: 0 errors. Backed up: local_rules.xml.bak-20260816-final.

## Pending validation

- Client 013 + pilot 012 idle (no events since ~05:26) - final proof requires
  next real VaultCli/Lsass event (verify: no 92153/92900 alerts for legit images;
  C:\Windows\Temp or unknown-path variants STILL alert).
- Re-measure over next 7 days: target < 10 level>=9/day.

## No secrets

## UPDATE (06:20 UTC) - root cause found + fixed

- Agent 013 + 012 events were analyzed on WORKER01, not the master.
- Suppressions were only on the master -> never applied to the analyzed events.
- FIX: custom_rules/suppressions.xml deployed to BOTH master + worker, with
  `<rule_dir>etc/custom_rules</rule_dir>` added AFTER ruleset/rules in both
  ossec.conf files. Field-scoped rules (121105/121106) loaded correctly.
- Both nodes restarted 06:15; both Windows agents idle since - final alert-level
  proof pending next real events. Re-measure continues over 7 days.
