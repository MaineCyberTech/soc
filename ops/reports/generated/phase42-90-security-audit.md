# Phase 42 Security Audit — SEC-AUD-42-01

**Report ID:** phase42-90-security-audit
**Phase:** 42
**Title:** Security Audit — Rotation Posture Stable, TLS Headers Now Single-XFO + Single-XCTO (Verified Live), Credential Modes Conform (shuffle-api-key 600 Gitignored; VT Container 640 DONE / Host 644 Owner Item; ossec Shuffle Placeholders CONFIRMED Both Nodes via Grep), Corpus Secret-Scan Zero, Pins Verified; Residual Risks Ranked With R-DISKBYPASS NEW Top-Tier
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T10:27:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-90-security-audit.md`

---

## 1. Rotation posture

No credential rotation executed this phase (approval-gated; none scheduled).
Last rotation lineage: pw-rotation-20260807 backups intact. Rotation-capable
validation tooling present (`credential-rotation-validation` script family).
TLS cert: self-signed TOFU CN=shuffle.mgmt (R-TOFU carried; rotated-notAttested
posture unchanged since phase41-87).

## 2. Listeners & TLS headers

```
$ curl -skI https://192.168.222.149:3443/
HTTP/1.1 200 OK
X-Frame-Options: DENY                ← exactly ONE
X-Content-Type-Options: nosniff      ← exactly ONE (dedup DONE this phase)
```

Listener surface re-audited: loopback-only bindings for frontend/backend/idx1/
dashboard/IRIS; TLS proxy LAN-IP-scoped :3443; wildcard set = by-design decoys +
management planes (R-HOOKS-LAN watchlist, netdata :19999 added this audit).

## 3. Credential modes (paths only, values never printed)

| Item | Expected | Observed | Verdict |
|---|---|---|---|
| `config/shuffle-api-key` | 600, gitignored | **600**; gitignore rule active | ✓ |
| Master ossec.conf in container | 640 root:root (phase42-53) | **640 root:root** live re-stat; 15/15 daemons running | ✓ |
| Host-side wazuh_manager.conf | 640 target | still 644-class host file — **owner sudo-window item** carried | OPEN |
| Worker conf | no VT block | placeholder-only shuffle token confirmed | ✓ |
| ossec shuffle integration strings | literal placeholder both nodes | grep confirms `<api_key>SHUFFLE_API_KEY_PLACEHOLDER</api_key>` on master AND worker | ✓ |
| Master VT api_key | REAL key inline — flag only | presence flagged via masked awk probe; value never printed (not even fragments); R-VTOSSEC carried | CARRIED |
| `/opt/wazuh-docker/.../creds.env` | 600 outside repo | referenced-by-path pattern preserved in all new scripts/reports | ✓ |

## 4. Corpus secret-scan

report-CI Gate4: files_with_hits=0, total_matching_lines=0 over the full
generated corpus (final-count run embedded phase42-87); canonical-CI Gate4:
0 high-confidence hits tree-wide; low-confidence informational lines confined
to historical docs (7 files / 29 lines, unchanged). Zero NEW secret-bearing
files introduced by the P42 batch.

## 5. Image pins & synthetic markers

Digest pins verified for nginx + all four shuffle refs + IRIS app (table in
phase42-88 §5; opensearch/postgres/redis tag-only gaps carried). Synthetic
markers honored: MCT-CANARY classification remains index-side-substring method
of record; zero synthetic leakage into production counters observed in any P42
proof (isolation proof phase42-21 stands).

## 6. Residual risks ranked

| Rank | ID | Statement |
|---|---|---|
| 1 | **R-DISKBYPASS** | **NEW top-tier:** watermark enforcement disabled on BOTH OpenSearch stores (indexer yml line 44 + shuffle compose line 100) → no cluster self-protection at disk exhaustion; owner decision OW-42-01 |
| 2 | R-VTOSSEC | real VT key inline in master conf; container half hardened, host chmod owner item |
| 3 | R-HOOKS-LAN | management/decoy planes LAN-exposed by design (+netdata note) |
| 4 | R-TOFU | self-signed proxy cert |
| 5 | R-PKT-PLATFORM | lane disabled ⇒ fail-open bounded |
| 6 | R-FIELD-LEGACY | rejection bursts bounded to rollover |
| 7 | R-DEL | DELETE-scope denied for user key |
