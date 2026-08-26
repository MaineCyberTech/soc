# Phase 26 VirusTotal Key Rotation

Date: 2026-08-23
Status: **BLOCKED - REPLACEMENT KEY REQUIRED** (unchanged; render path ready).

## On replacement

1. Set VIRUSTOTAL_API_KEY in creds.env (600).
2. `bash ops/scripts/render-virustotal-integration.sh` -> restart analysisd -> verify on test hash.
3. Revoke old key after 24h clean.

## No secrets