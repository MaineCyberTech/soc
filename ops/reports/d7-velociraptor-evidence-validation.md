# Drill D7: Velociraptor Evidence Validation

Date: 2026-08-11
Status: **PARTIAL - workflow documented; end-to-end hunt pending enrolled client**

## Path

```text
IRIS case opened -> analyst launches Velociraptor hunt -> collection completes
  -> download zip -> attach to IRIS case evidence -> record hash
```

## Validated components

| Component | Status | Evidence |
|---|---|---|
| Velociraptor server | OK | service active, GUI bound 127.0.0.1:8889 |
| Evidence workflow doc | EXISTS | integrations/velociraptor/dfir-iris-evidence-workflow.md |
| Wazuh alert -> hunt map | EXISTS | integrations/velociraptor/wazuh-alert-to-hunt-map.md (Windows + Linux + Docker hosts) |
| IRIS evidence attach path | DOCUMENTED | manual upload + API path in evidence workflow |
| Enrolled client | **NONE** | no client records on server - hunt execution not possible yet |

## Manual steps (no safe client available - documented per prompt)

1. Enroll a safe test client (Linux pilot or Windows pilot VM) per rollout runbooks.
2. GUI -> Hunts -> New hunt -> `Generic.Client.Info` (non-invasive collection).
3. Run on the pilot client; wait for completion.
4. Download collection zip (Hunt -> Collected -> Download).
5. IRIS case -> Evidence -> Add -> upload zip, title `velociraptor-<huntid>-<hostname>-<date>`.
6. Record SHA256 of the zip in the case timeline.

## No invasive collection performed

Per prompt: "Run a non-invasive collection or document exact manual steps if no
safe client is available" - no clients enrolled, so steps documented only.

## Alert-to-hunt coverage

- Windows: persistence, PowerShell, LOLBins, RDP/logon, Defender exclusions, downloads, admin changes
- Linux: SSH keys, sudoers, cron/systemd, listening ports, processes, Docker abuse
- Map file: integrations/velociraptor/wazuh-alert-to-hunt-map-phase4.md (updated)

## Files

- integrations/velociraptor/evidence-to-iris-workflow.md
- integrations/velociraptor/wazuh-alert-to-hunt-map-phase4.md
