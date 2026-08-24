# Phase 31 SO Routing Cleanup

Date: 2026-08-24
Status: **APPLIED** (SO-dependent forward disabled; rollback retained).

## Changes

- **syslog-ng bridge** (security-onion container): disabled the raw-archives -> Security
  Onion syslog destination (192.168.222.116:514) + both log paths; sources retained for
  re-enable. Config marked DISABLED-P31; container restarted, healthy.
- **Healthcheck/CI**: SO + agent 008 no longer active failures (RETIRED) - done in 04.
- Stale packet-freshness expectations for 008 removed.

## Rollback

- Restore `config/security_onion/syslog-ng.conf.bak-phase31` + restart security-onion.

## No secrets