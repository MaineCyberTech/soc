# Phase 13 Pilot Suppressions (Sysmon / Wazuh)

Date: 2026-08-16
Scope: PILOT ONLY - agent 012 (MCT-WIN11PILOT)

## Applied rules (FINAL: /var/ossec/etc/custom_rules/suppressions.xml on BOTH nodes, 2026-08-16 06:15)

### 121105 - VaultCli FP suppression (rule 92153)

```xml
<rule id="121105" level="0">
  <if_sid>92153</if_sid>
  <field name="win.eventdata.image" type="pcre2">(?i)(System32|Program Files|WindowsApps|OneDrive|RuntimeBroker|SecurityHealth|SearchHost|MoUsoCoreWorker|backgroundTaskHost|taskhostw|Intune|Edge|ImmersiveControlPanel|ShellHost)</field>
  <description>Suppressed: VaultCli FP from legitimate Windows processes</description>
  <options>no_full_log</options>
</rule>
```

### 121106 - Defender-Lsass FP suppression (rule 92900)

```xml
<rule id="121106" level="0">
  <if_sid>92900</if_sid>
  <field name="win.eventdata.sourceImage" type="pcre2">(?i)MsMpEng|Windows Defender</field>
  <description>Suppressed: Lsass access by Defender</description>
  <options>no_full_log</options>
</rule>
```

## Deployment requirements (IMPORTANT - cluster)

- Rules MUST live in a rule_dir loaded AFTER the default ruleset: add
  `<rule_dir>etc/custom_rules</rule_dir>` after `<rule_dir>ruleset/rules</rule_dir>`
  in ossec.conf on EVERY node.
- Applying to the master only does NOT work for agents connected to the worker
  (events are analyzed on the worker node).
- Debugging history (why earlier attempts failed):
  1. local_rules.xml loads BEFORE the ruleset - if_sid children/overwrites there
     never see the parent rule (or get clobbered by the ruleset originals).
  2. agent.id/agent.name fields are invalid in Wazuh rules (syntax error).
  3. Match/field conditions in a rule loaded before the parent do not evaluate.
  4. Root cause of "no suppression": rules were only on the master while agents
     012/013 were connected to the worker. Fixed by deploying to both nodes +
     loading after the ruleset.

## Design rationale

- Image-scoped: only legit system paths/processes suppressed.
- Any NON-system image (e.g. C:\Temp\evil.exe) loading VaultCli still fires 92153.
- Any non-Defender source accessing lsass still fires 92900.

## Re-evaluation

- Review after 7 days of measurement (phase13-windows-fp-tuning.md /
  phase14-windows-fp-remeasure.md).
- Extend to broader deployment only after pilot proof.

## No secrets

No secret values printed.
