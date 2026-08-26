# Phase 15 Internal Dependency Cache Plan

Date: 2026-08-16

## Status: PLAN COMPLETE - implementation backlog

## Summary

- Docker: registry mirror (registry:2 on :5000) OR docker save/load tars.
- pip: wheelhouse (P15.17).
- Endpoint assets: /opt/mct-cache/endpoint/ with checksums (P15.18).
- Proxmox ISO: already used for lab media.
- Host OS packages: apt-cacher-ng recommended.

## Priority

1. Docker digest pinning (P15.16) - prerequisite for image caching.
2. pip wheelhouse (P15.17).
3. Endpoint artifact cache + checksums (P15.18).

## Acceptance

- Offline rebuild possible with: repo + /opt/mct-cache + documented licensed
  media (ISO).

## No secrets
