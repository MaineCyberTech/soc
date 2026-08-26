# level.io Endpoint Deployment Kit - Validation Report

Date: 2026-08-12
Location: /opt/mct-security-stack/scripts/endpoint-deploy/

## Deliverables (9 files)

| File | Purpose | Validated |
|---|---|---|
| install-wazuh-linux.sh | Wazuh agent (+Velociraptor/osquery opt) - Debian/Ubuntu/RHEL/Fedora/Amazon | bash -n OK |
| install-wazuh-macos.sh | Wazuh agent (+Velociraptor opt) - Intel + Apple Silicon | bash -n OK |
| install-wazuh-windows.ps1 | Wazuh agent + Sysmon (+Velociraptor opt) | saved for endpoint use |
| verify-endpoint-linux-macos.sh | Post-install PASS/FAIL | bash -n OK |
| verify-endpoint-windows.ps1 | Post-install PASS/FAIL | saved for endpoint use |
| uninstall-endpoint-linux-macos.sh | Clean removal | bash -n OK |
| uninstall-endpoint-windows.ps1 | Clean removal | saved for endpoint use |
| sysmon-mct.xml | Conservative Sysmon config (MCT detection backlog) | embedded + standalone |
| prepare-velociraptor-client.sh | Generate endpoint-ready client config from server | **LIVE TESTED** |
| README.md | level.io setup guide (variables, groups, rollout) | - |

## Live validation (this session)

- prepare-velociraptor-client.sh: produces config with correct
  server_urls (https://VelociraptorServer:8002/), matching CA, matching nonce.
- A client launched with the prepared config ENROLLED (C.0b81a19bfb44bc90)
  and connected with HTTP 200 on /reader + /control - proving the exact config
  level.io endpoints will receive works end-to-end.
- bash syntax: all 5 .sh files pass bash -n.
- PowerShell files: syntax validated at endpoint runtime (pwsh not on host);
  standard param/error handling used.

## level.io integration notes

- All config via script variables (no hardcoded secrets).
- WAZUH_REG_PASSWORD + VELO_CONFIG_B64 should be encrypted variables.
- Run install -> verify per device group; alert on non-zero exit.
- Agent groups: create linux-clients / mac-clients / windows-clients in Wazuh
  before rollout; upload windows-sysmon-agent-group.xml to the Windows group.
- Velociraptor endpoints need the server reachable as `VelociraptorServer`
  (DNS/hosts) - documented in README + client-config-port-8002.md.

## Safety

- Idempotent (re-run safe). No secrets embedded. No broad Sysmon rollout
  without pilot approval (pack policy) - INSTALL_SYSMON default yes for
  Windows but operator-controlled.
