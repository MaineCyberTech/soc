# Phase 22 macOS Repair Bundle Review

Date: 2026-08-22
Bundle: `macos-remediation/` (now mirrored to `integrations/macos/remediation-bundle/`)

## Script-by-script review

| Script | Purpose | Review result |
|---|---|---|
| repair-agent015-unified-log.sh | check/apply bounded unified-log fix | PASS after fix (see below) |
| verify-agent015.sh | config/process/log/queue check | PASS (covers config grep, agentd proc, log tail, queue size; server-side note) |
| rollback-agent015.sh | list/apply backups | PASS (timestamped pre-rollback save, install 640 root:wheel, restart) |
| collect-agent015-diagnostics.sh | offline diagnostics bundle | PASS (mode 600 output, no secrets) |

## repair-agent015-unified-log.sh detailed review

| Item | Finding |
|---|---|
| Paths | `/Library/Ossec/etc/ossec.conf` (overridable via WAZUH_OSSEC_CONF) - matches standard install |
| Backup behavior | timestamped backup to `/Library/Ossec/etc/mct-backups` (mode 700) before any change; `cp -p` preserves perms |
| Bounded predicate | `process == "sudo" OR loginwindow OR securityd OR subsystem BEGINSWITH com.apple.Authorization OR com.apple.SystemConfiguration` - security-relevant, bounded |
| localfile syntax | `<log_format>macos</log_format>` + `<location>macos</location>` + `<query>` = modern Wazuh macOS unified-log form. **NOTE**: this supersedes the P19/P20 docs which used `<location>log</location>`; the bundle form matches Wazuh 4.14 macOS agent defaults. P19/20 operator docs remain valid in intent (bounded query), but the bundle is the authoritative implementation. |
| Service control | wazuh-control -> ossec-control -> launchctl kickstart fallback |
| Permissions | install -m 640 -o root -g wheel |
| **Regex bug (fixed)** | Original non-greedy `.*?` anchored at first `<localfile>` could span multiple blocks if the macos block is not first, deleting valid localfiles. Replaced with a block-safe tempered pattern `(?:(?!</localfile>).)*?` - verified with a 3-localfile sample: only the macos block removed, others preserved. |
| XML validation | `xmllint --noout` when available; otherwise proceeds (script-restart risk acceptable, backup retained) |
| Rollback | documented + scripted (list/apply) |

## Safety-rule compliance

- `--check` default; changes require `--apply` (with sudo) - YES.
- Timestamped backup before any write - YES.
- Does NOT remove all macOS telemetry (replaces unbounded with bounded query) - YES.
- No enrollment secrets in scripts - YES.

## Customization

- No change needed for standard `/Library/Ossec` installs. If the agent uses a non-standard
  install path, set WAZUH_OSSEC_CONF / WAZUH_BACKUP_DIR env vars.

## Verdict

**REVIEWED + FIXED + READY.** Bundle packaged at `integrations/macos/remediation-bundle/`.
Apply remains blocked on Mac access (Phase 22.07).

## No secrets