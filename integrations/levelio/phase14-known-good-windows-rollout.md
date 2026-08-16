# Phase 14 Known-Good Windows Rollout (agent 013)

Date: 2026-08-16
Status: RECORDED - production-validated path

## Steps (validated with client 013)

1. Level.io automation renders WAZUH_MANAGER/WAZUH_REG_PASSWORD/WAZUH_AGENT_GROUP
   into install-wazuh-windows.ps1 args or env (variable-driven, P13 model).
2. Script fails fast if any required value missing/unresolved (exit 2).
3. Agent enrolls -> group windows-clients (verified: agent 013 group correct).
4. VERIFY NODE: agent may connect to worker01 - group config + suppressions
   must exist on ALL nodes (master + worker).
5. Sysmon channel: added to windows-clients shared agent.conf - collection
   verified (175 events/24h, EID 1+7).
6. SCA: CIS Windows 11 benchmark summaries flow (classified informational).
7. FP suppressions: custom_rules/suppressions.xml on every node (121105/121106).

## Gotchas recorded

- Local_rules.xml loads before the ruleset -> if_sid children/overwrites there
  don't work. Use etc/custom_rules (loaded after ruleset/rules) on every node.
- Agent node assignment varies (manager <-> worker01) - check agent_control -i.
- Sysmon is installed by the script but channel collection needs the group
  agent.conf localfile.

## No secrets

## macOS gotcha (fixed 2026-08-16)

- Wazuh macOS packages are ARCH-SPECIFIC: the URL must be
  wazuh-agent-<ver>-1.intel64.pkg (Intel) or wazuh-agent-<ver>-1.arm64.pkg
  (Apple Silicon). The old script used the Linux-style name (-1.pkg) which
  returned 403 and the silent curl produced an empty file -> installer error.
- Fix: install-wazuh-macos.sh now resolves arch via uname -m and fails fast on
  download errors (curl -fsSL + empty-file check).

## Level.io execution-mode gotcha (fixed 2026-08-16)

- Level.io may run scripts via stdin / bash -c where BASH_SOURCE is EMPTY.
  The old scripts failed with "BASH_SOURCE[0]: unbound variable" -> lib not
  loaded -> all helpers missing -> WAZUH_VERSION empty -> wrong pkg URL.
- Fix: install scripts now fall back to $0 and the repo-known lib path, and
  fail with a clear error if lib/mct-env.sh cannot be loaded.

## Self-contained scripts (fixed 2026-08-16)

- Install scripts previously sourced lib/mct-env.sh - but Level.io copies ONLY
  the single script to the endpoint, so the lib was never present there.
- Fix: the helper functions are now INLINED in install-wazuh-linux.sh and
  install-wazuh-macos.sh (fully self-contained). lib/mct-env.sh remains for
  repo-side test harnesses.
- Verified: works via stdin (Level.io exec mode) with no repo/lib present;
  fail-fast exit 2 on missing required vars; dry-run exit 0.
