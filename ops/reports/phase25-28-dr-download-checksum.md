# Phase 25 DR S3 Download and Checksum

Date: 2026-08-22
Status: **PASS**

## 1. Download

- Tool: `s3cmd` 2.4.0 against `https://nyc3.digitaloceanspaces.com` (region nyc3, host-bucket
  pattern from dr-s3-bundle.sh).
- Object: `s3://wazuh/dr/current/config-20260822-040001.tar.gz` -> scratch (160,538 bytes in
  0.2s).

## 2. Checksum comparison (NOT ETag-based)

| Source | SHA-256 (prefix) | Match |
|---|---|---|
| Trusted local stage (pre-upload) | 4c00952dcc34374d | - |
| Downloaded S3 object | 4c00952dcc34374d | **MATCH (byte-identical)** |

- ETag explicitly NOT treated as a universal content checksum (per pack research note).

## 3. Verdict

- **PASS** - S3 object verified identical to the trusted staged bundle.

## No secrets