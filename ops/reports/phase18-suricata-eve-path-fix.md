# Phase 18 Suricata EVE Path Fix

Date: 2026-08-17

## Status: FIXED + VERIFIED

## Problem

- ossec.conf localfile pointed at /nsm/suricata/eve.json (missing).
- SO rotates eve to timestamped files (eve-YYYY-MM-DD-HH:MM.json) - no stable
  path. logcollector ERROR (1103) every start.

## Fix

1. Symlink: /nsm/suricata/eve.json -> newest eve file (ln -sfn).
2. Updater: /usr/local/sbin/update-eve-symlink.sh (re-points to newest).
3. Cron: hourly (10 * * * *) to survive rotation.

## Verification

- ls -la eve.json -> symlink valid.
- logcollector: 'Analyzing file: /nsm/suricata/eve.json' - NO error (05:47).
- Suricata running (5 procs); eve file readable.

## Files

- integrations/security-onion/phase18-suricata-eve-localfile.md (created)

## No secrets
