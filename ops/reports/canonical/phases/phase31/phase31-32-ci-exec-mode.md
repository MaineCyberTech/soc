# Phase 31 CI Executable-Mode Wiring

Date: 2026-08-24
Status: **WIRED (hosted CI)**.

- Added step runs `p29-executable-mode-audit.sh` (timeout 300) - fails on cron/systemd/
  entrypoint scripts lacking git mode 100755. All tracked .sh currently 100755 (0 non-exec).

## No secrets
