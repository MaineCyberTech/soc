# Greenbone Critical Finding Escalation Runbook

## Trigger

Greenbone finding with severity >= 9.0 (or selected CVEs) on a target.

## Automated path (notify-only)

```text
Greenbone alert -> HTTP POST to Shuffle webhook (greenbone-critical contract)
  -> Shuffle workflow critical-vuln-to-case
  -> IRIS case (critical-vulnerability template)
```

### Greenbone side (create the alert)

On mct-soc-scan VM (192.168.222.154) via gvm-cli or UI:

1. Alerts -> New
2. Condition: severity High (9.0+) 
3. Method: HTTP POST
4. URL: Shuffle webhook URL for greenbone-critical (from Shuffle UI: Webhooks page)
5. Payload: per integrations/shuffle/webhook-contracts/greenbone-critical.json
6. Attach to the monthly recurring scan task

### Shuffle side

- Workflow: `critical-vuln-to-case` (exists)
- Verifies `internet_facing` -> chooses IRIS severity 4 (Class A) vs 2 (Class B)
- Falls back to raw payload in case description if variables fail

### IRIS side

- Template: critical-vulnerability (11 fields)
- Analyst triage: CVE, exposure, exploit availability, asset owner

## Manual path (if Shuffle/webhook fails)

1. Export scan report from Greenbone (CSV/PDF).
2. Create IRIS case manually using critical-vulnerability template.
3. Paste raw finding payload into case description.
4. Tag: `source:greenbone`, `class:A|B`, `manual-escalation`.

## Operational procedure (real critical findings)

1. Confirm CVE + affected asset (Wazuh vuln index cross-check).
2. Determine internet exposure (target group: cloud = internet-facing).
3. Check exploit availability (MISP/NVD).
4. Open IRIS case; notify per client notification criteria in template.
5. Remediation: patch or compensating control (manual approval for isolation).
6. Post-remediation verification scan (profile: post-remediation verification).

## Safety

- Notify-only mode. No automated patch/quarantine/firewall actions.
- Scan credentials never stored in docs.
- Infrastructure devices (gateways, PVE): non-invasive profiles only.
