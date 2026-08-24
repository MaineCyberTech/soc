# Phase 29 v1.3.0 Bundle

Date: 2026-08-24
Status: **BUILT** (deterministic; approval-pending for release).

## Bundle

- Artifact: /home/user/mct-security-releases/mct-security-stack-release-20260824-203124.tar.gz
- Size: 10,348,557 bytes (~10MB)
- SHA-256: **da72bde45db379c5417970224c11caf5305b281e47b302b07e45d823411b589c**
- Sensitive-file count: **0** (must be 0) - .env/creds/client.config.yaml excluded
- Manifest: release-manifest-20260824-203124.json (copied to repo root release-manifest.json)

## Contents (verified present)

- config/{dependency-lock,image-pin-set,schema,service-graph}.json, config/profiles/
- ops/scripts/p28-*/p29-* tooling, cache manifest, runbooks, checks, reports.

## Mirrors

- /home/user/mct-security-releases/ (build dir). Mirror to
  /opt/mct-security-stack-backups/releases/ + S3 on release execution.

## No secrets