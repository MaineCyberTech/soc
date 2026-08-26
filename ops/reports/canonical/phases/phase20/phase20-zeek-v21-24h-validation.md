# Phase 20 Zeek v2.1 24h Noise Validation

Date: 2026-08-19
Window: deploy (08-18 ~21:50) through preflight (08-19 ~05:45) = ~8h of live data; plus v2.2 (06:00) measurement.

## 1. Alert counts by rule (post-v2.1, first ~8h)

| rule | 8h | Verdict |
|---|---|---|
| 122000 (base) | 280 | controlled |
| 122001 (SSH) | 1 | **fires** (anchored pcre2 fix) |
| 122002 (SMB) | 0 | clean |
| 122003 (RDP) | 0 | clean |
| 122004 (admin) | 2 | **fires** (was dead in v1/v2) |
| 122005 (subnet) | 133 | controlled |
| 122006 (UDP) | 3,778 | **residual: subnet-broadcast** (~600/hr) |

Hourly 122006: pre-deploy 17:00-21:00 ~10-11K/hr; post-v2.1 22:00-05:00 ~13-615/hr.

## 2. Root cause of residual 122006

- Top traffic: `192.168.111.72 -> 192.168.111.255:15600` (~75% of residual) - **subnet
  broadcast** on the client subnet from one device (discovery protocol, port 15600).
- The v2.1 guard covered 255.255.255.255 / 224.x / 239.x / 233.x / ffxx but NOT `x.x.x.255`
  subnet broadcasts.
- Verified by logtest: `192.168.111.255:15600` matched 122006 under v2.1.

## 3. v2.2 fix (deployed 08-19 ~06:00)

- Guard extended: `^(255\.255\.255\.255|224\.|239\.|233\.|ff[0-9a-fA-F]{2}:)|\.255$`
  (excludes IPv4 subnet broadcasts ending in .255) on rules 122000/122005/122006.
- analysisd -t clean (master+worker); logtest: subnet-broadcast silent, unicast UDP 4444
  still fires 122006, SSH 22 fires 122001.

## 4. Post-v2.2 measurement

- 122006 last 3 min post-restart: **3** (was ~10/min residual). Zeek total by minute
  06:03 = 0, 06:04 = 1 -> **effectively zero noise**.

## 5. Over-suppression / under-detection check

- No over-suppression: Class A/B (SSH/SMB/RDP/admin/UDP) all still fire on unicast targets.
- Under-detection fixed vs v1: 122004 now fires (was structurally dead); 122001 fires on port 22 (was substring-broken).
- Multicast/broadcast discovery correctly de-prioritized (benign).

## 6. Keep/tune/disable decision

- **KEEP all rules (v2.2).** No disable needed. 122006 now unicast-only UDP -> retains scan/exfil signal.
- Recommend one more 24h window to confirm zero-rate before Class A routing (Phase 20.06).

## Files

- `ops/reports/phase20-zeek-v21-24h-validation.md` (this)
- `integrations/security-onion/phase20-zeek-v21-decision.md`

## No secrets