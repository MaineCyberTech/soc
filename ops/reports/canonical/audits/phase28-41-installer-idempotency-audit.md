# Phase 28 Installer Idempotency Audit

Date: 2026-08-24

## Audit (endpoint installers + stack installers)

| Installer | Check-before-apply | Fail-closed | Resume-safe | Non-destructive |
|---|---|---|---|---|
| install-wazuh-linux.sh | YES ("already installed - skipping"; systemctl is-active) | YES (active check exit 1) | YES (idempotent) | YES |
| install-wazuh-macos.sh | YES (is-active / exists) | YES | YES | YES |
| install-wazuh-windows.ps1 | YES (already installed; config exists) | YES | YES | YES |
| verify-endpoint-{linux,windows}.sh/ps1 | read-only | YES | - | YES |
| uninstall-endpoint-*.sh/ps1 | confirmation-gated | YES | - | rollback path |
| p28-fresh-target-gate.sh | runs CI+secret+syntax gates | exits on failure | YES | read-only |
| build-release-bundle.sh | bundle gates (0 sensitive files) | YES | - | no volume ops |

## Findings

- Endpoint installers are check/apply aware and idempotent (evidence: "already installed -
  skipping", is-active branches).
- Sysmon tuning scripts are self-contained no-arg check/apply/rollback (proven P24-P27).
- Stack install procedure is documented (golden path 46) with readiness gates (39).

## Verdict

- **PASS** for idempotency posture; no destructive volume ops anywhere.

## No secrets