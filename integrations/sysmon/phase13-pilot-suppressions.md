# Phase 13 Pilot Suppressions (Sysmon / Wazuh)

Date: 2026-08-16
Scope: PILOT ONLY - agent 012 (MCT-WIN11PILOT)

## Applied rules (manager local_rules.xml, backed up 20260816)

### 121105 - VaultCli FP suppression (rule 92153)

```xml
<rule id="121105" level="0" overwrite="yes">
  <if_sid>92153</if_sid>
  <field name="agent.id">^012$</field>
  <field name="win.eventdata.image" type="pcre2">(?i)(System32|Program Files|WindowsApps|OneDrive|RuntimeBroker|SecurityHealth|SearchHost|MoUsoCoreWorker|backgroundTaskHost|taskhostw)</field>
  <description>Suppressed: VaultCli FP from legitimate Windows processes (pilot agent 012)</description>
  <options>no_full_log</options>
</rule>
```

### 121106 - Defender-Lsass FP suppression (rule 92900)

```xml
<rule id="121106" level="0" overwrite="yes">
  <if_sid>92900</if_sid>
  <field name="agent.id">^012$</field>
  <field name="win.eventdata.sourceImage" type="pcre2">(?i)MsMpEng\.exe|Windows Defender</field>
  <description>Suppressed: Lsass access by Defender (pilot agent 012)</description>
  <options>no_full_log</options>
</rule>
```

## Design rationale

- Agent-scoped (^012$): no impact on other agents/clients.
- Image-scoped: only legit system paths/processes suppressed.
- Any NON-system image (e.g. C:\Temp\evil.exe) loading VaultCli still fires 92153.
- Any non-Defender source accessing lsass still fires 92900.

## Re-evaluation

- Review after 7 days of measurement (phase13-windows-fp-tuning.md).
- Extend to broader deployment only after pilot proof.

## No secrets

No secret values printed.
