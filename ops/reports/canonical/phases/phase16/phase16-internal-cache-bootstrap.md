# Phase 16 Internal Cache Bootstrap

Date: 2026-08-16

## Status: BOOTSTRAPPED

## Cache root: /opt/mct-cache

| Dir | Purpose | Content |
|---|---|---|
| docker-images/ | docker save/load tars | empty (plan) |
| endpoint-assets/ | endpoint packages | empty |
| checksums/ | artifact checksums | velociraptor.sha256 |
| python-wheelhouse/ | pip wheelhouse | empty (P16.11) |
| os-packages/ | OS pkg cache | empty |
| iso-media-external/ | licensed ISO notes | empty |
| velociraptor/ | velociraptor binary | **velociraptor-v0.77.2-linux-amd64** (cached) |
| sysmon/ | Sysmon.zip | empty |
| wazuh-agents/ | wazuh agent pkgs | empty |

## First artifact cached

- velociraptor v0.77.2: sha256 6c4c23c466d892788ff56ddcd3a31f844e4c0d797ade454c5e2625eb9e427077
- Checksum recorded in checksums/velociraptor.sha256 + repo-artifact-cache-manifest.json.

## Rules

- Cache lives OUTSIDE the repo (/opt/mct-cache) - never committed.
- Every artifact: checksum + manifest entry.

## No secrets
