# Phase 21 Unpinned Image Check Update

Date: 2026-08-19

## Coverage fix

`ops/scripts/check-unpinned-docker-images.sh` previously scanned only
`/opt/mct-security-stack/compose/*.yml`, missing the Wazuh multi-node deployment.

**Changed**: script now scans both:
- `$ROOT/compose/*.yml` (MCT stack)
- `$ROOT/../wazuh-docker/multi-node/*.yml` (Wazuh multi-node: docker-compose.yml,
  docker-compose.override.yml, docker-compose.cloudflare.yml)

Also added `wazuh/wazuh-*` to the allowed versioned-tag baseline (wazuh images are explicitly
versioned 4.14.7, not floating).

## Current result (2026-08-19 run)

- **25 unpinned refs** flagged (was 21 before coverage fix; now includes cloudflared:latest,
  nginx:stable, python:3-alpine, elastiflow:7.26.2, balabit/syslog-ng:latest from wazuh-docker).
- Breakdown: Greenbone feed/data images (~14, intentionally floating), Greenbone service images
  (gsa/gsad/gvm-config/gvm-tools/openvas/ospd/pg-gvm/nginx/redis), thinkst/opencanary:latest,
  velociraptor:latest, misp-modules:latest, cloudflared:latest, nginx:stable, python:3-alpine,
  elastiflow:7.26.2, balabit/syslog-ng:latest.
- All documented in `ops/reports/phase21-unpinned-image-exceptions.md`.

## Decision: warning vs hard fail

- **KEEP WARNING (informational) in CI.** Many refs are vendor feed/data images that ship
  floating by design (Greenbone); hard-fail would block CI without adding security value.
- The checker still exits 1 so operators see violations in the report; CI wraps it as
  informational (`|| echo "[NOTE] ..."`).
- New unpinned refs not in the exception list should be pinned or documented before release
  (v1.1.0 checklist).

## No secrets