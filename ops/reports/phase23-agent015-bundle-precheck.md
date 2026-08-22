# Phase 23 Agent 015 Mac Bundle Integrity and Precheck

Date: 2026-08-22
Bundle: integrations/macos/remediation-bundle/

## 1. Integrity

| File | sha256 (prefix) | bash -n |
|---|---|---|
| repair-agent015-unified-log.sh | b54808a4... | PASS |
| verify-agent015.sh | 9c415009... | PASS |
| rollback-agent015.sh | 3876f2f1... | PASS |
| collect-agent015-diagnostics.sh | 61f3fd23... | PASS |

## 2. Predicate QA (vs intended filtered ULS set)

- Bundle predicate now covers: sudo, loginwindow, securityd, **sshd, tccd, screensharingd,
  logoutd, logout, session** + com.apple.Authorization, com.apple.SystemConfiguration,
  com.apple.loginwindow subsystems.
- **UPDATED this phase** (pack research-informed set: sshd/tccd/screensharingd/logout/session
  were missing from the P22 predicate). Script syntax verified after edit.

## 3. Live evidence (endpoint already repaired)

- Agent 015 reconnected 04:22 UTC; `location: macos` events flowing (45/3h); sudo events with
  srcuser/dstuser/pwd/command visible (e.g. `sudo[5438]: root ...`). The bounded predicate is
  active on the endpoint. Archives 0/12h (flood gone).

## 4. Upgrade-preservation risk (documented)

- macOS Wazuh agent upgrades may rewrite ossec.conf, replacing the bounded localfile with the
  default unbounded form. Mitigation: re-run `repair-agent015-unified-log.sh --check` after
  every agent upgrade; verify `MCT-PHASE22-BOUNDED-MACOS` marker present (add to verify-agent015.sh
  output guidance).

## 5. Precheck verdict

- Bundle: READY (updated predicate). Endpoint: repair appears APPLIED (external); full 24h
  validation in 23.09.

## No secrets