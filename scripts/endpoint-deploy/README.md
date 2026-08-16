# MCT Endpoint Deployment Kit (level.io)

Install the MCT endpoint stack on endpoints managed by level.io.

## Components per OS

| OS | Script | Installs |
|---|---|---|
| Linux | `install-wazuh-linux.sh` | Wazuh agent (+ Velociraptor, osquery optional) |
| macOS | `install-wazuh-macos.sh` | Wazuh agent (+ Velociraptor optional) |
| Windows | `install-wazuh-windows.ps1` | Wazuh agent + Sysmon (+ Velociraptor optional) |

Support scripts:

| Script | Purpose |
|---|---|
| `verify-endpoint-linux-macos.sh` | Post-install verification (PASS/FAIL) |
| `verify-endpoint-windows.ps1` | Post-install verification (PASS/FAIL) |
| `uninstall-endpoint-linux-macos.sh` | Clean removal (offboarding) |
| `uninstall-endpoint-windows.ps1` | Clean removal (offboarding) |
| `sysmon-mct.xml` | Sysmon config (embedded in PS1 too; standalone for managed deployment) |
| `prepare-velociraptor-client.sh` | Generate client.config.yaml from server config (run on Wazuh host) |

## level.io setup

### 1. Create the scripts

- level.io -> Scripts -> New -> paste each script.
- Recommended runtime:
  - Linux/macOS: `bash`
  - Windows: `PowerShell` (run as SYSTEM or admin account)
- Scope scripts to the right platforms (Linux kit to Linux devices, etc.).

### 2. Set variables (Script Settings / Environment)

| Variable | Example | Used by | Notes |
|---|---|---|---|
| `WAZUH_MANAGER` | `142.105.190.25` | all installers | **Public IP** (verified reachable on 1514/1515). Use LAN IP `192.168.222.149` only for on-site devices |
| `WAZUH_AGENT_GROUP` | `windows-clients` | all installers | Wazuh agent group; use `default` if none |
| `WAZUH_REG_PASSWORD` | (required) | all installers | **Required** - registration password is enforced on the master. Value = `WAZUH_REGISTRATION_PASSWORD` in host `creds.env` |
| `WAZUH_VERSION` | `4.14.7` | all installers | |
| `INSTALL_SYSMON` | `yes` | Windows | |
| `INSTALL_OSQUERY` | `no` | Linux | |
| `INSTALL_VELOCIRAPTOR` | `no` | all | enable when rolling out Velociraptor |
| `VELO_CONFIG_URL` | `https://.../client.config.yaml` | all | or use `VELO_CONFIG_B64` |
| `VELO_CONFIG_B64` | base64 blob | all | paste output of `prepare-velociraptor-client.sh` |

Secrets (`WAZUH_REG_PASSWORD`, `VELO_CONFIG_B64`) must be set as **encrypted/secret**
variables in level.io - never plaintext in the script body.

## Public IP enrollment (verified 2026-08-12)

- **Public IP: `142.105.190.25`** - the UniFi gateway (Zen) forwards ports to this host.
- **Port 1514** (agent comms): proven reachable from the internet (mct-portal droplet
  at 138.197.105.82 connects through the gateway).
- **Port 1515** (enrollment): open via public IP; enrollment with password tested
  end-to-end (agent-auth via public IP returned "Valid key received").
- **Registration password ENFORCED** (`use_password yes` on master): enrollment
  without the password returns "Invalid password" - rogue agent registration blocked.
- On-site/LAN devices: set `WAZUH_MANAGER=192.168.222.149` to avoid hairpin NAT.

### 3. Agent groups

Create Wazuh agent groups before rollout (Agents -> Groups):
- `linux-clients`, `mac-clients`, `windows-clients` (or per client/site).
- Windows Sysmon collection: upload `windows-sysmon-agent-group.xml` config to the
  Windows group (see integrations/sysmon/).

### 4. Rollout

- level.io -> Devices -> select group -> Run Script -> choose installer.
- Or use Automation/Triggers: run installer on device enrollment.
- After install, run the matching verify script to confirm PASS.

## Velociraptor client config (optional)

Run on the Wazuh host:

```bash
/opt/mct-security-stack/scripts/endpoint-deploy/prepare-velociraptor-client.sh
```

Produces a ready `client.config.yaml` with the correct server URL
(`https://VelociraptorServer:8002/`), CA, and nonce. Paste its base64 into
`VELO_CONFIG_B64` (encrypted variable) or serve the file via `VELO_CONFIG_URL`.

Important: the Velociraptor server must be reachable from endpoints by the
hostname in the config (`VelociraptorServer` - add DNS or hosts entry; see
integrations/velociraptor/client-config-port-8002.md).

## Verification

- `verify-endpoint-*.sh/.ps1` prints `[PASS]`/`[FAIL]` per check and exits 1 on FAIL.
- level.io shows script exit code; alert on non-zero.
- Confirm in Wazuh dashboard: Agents -> new agents Active; per-group counts.
- Confirm Sysmon events: verify script checks Event log; Wazuh side uses
  `integrations/sysmon/sysmon-validation-queries.md`.

## Offboarding

- Run the matching uninstall script; then remove the agent from Wazuh
  (agent_control -r or UI) and update inventory (offboarding-checklist.md).

## Safety

- Scripts contain no hardcoded secrets - all config via level.io variables.
- Installers are idempotent (safe to re-run).
- No broad Sysmon rollout without pilot approval (per pack policy).
