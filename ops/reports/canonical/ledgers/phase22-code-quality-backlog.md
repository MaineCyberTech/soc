# Phase 22 Code Quality Backlog

Date: 2026-08-22

## FIXED this phase
1. opencanary decoder-plan XML (malformed) -> .md.
2. CI py_compile `__pycache__` pollution (PYTHONPYCACHEPREFIX in run-local-ci.sh + verify.yml).
3. flow-relay relay.py hardcoded ES_PASS fallback removed (env-only).

## MEDIUM
4. No canonical repo copy of `wazuh_manager.conf` (ops/backups artifact lags running by
   2 allowed-ips). Promote a config/ copy with `<api_key>` placeholder for drift reference.
5. `alert-volume-by-rule.sh` exits 0 on query failure (silent) - consider non-zero exit.
6. `generate-monthly-scorecard.py --live` renders zero-counts on query exception (warn-only) -
   consider explicit "unavailable" marker.
7. Container rule file name `phase18-zeek-rules.xml` vs source `phase19-zeek-custom-rules-v2.xml`.

## LOW
8. Duplicate Python generators (ops/scripts vs reporting/generators).
9. Committed __pycache__ dirs (gitignored; remove from disk).
10. Duplicate backup crons (user crontab + /etc/cron.d/wazuh-backups).

## No secrets