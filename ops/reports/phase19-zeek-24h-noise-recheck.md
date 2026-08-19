# Phase 19 Zeek 24h Noise Recheck

Date: 2026-08-18 (window: last 24h, ending 21:30 UTC)
Method: indexer `wazuh-alerts-*`, terms on rule.id 122000-122006, plus top src/dst/port.

## 1. Alert counts by Zeek rule (24h)

| Rule | Alerts/24h | Class (P18 map) | Verdict |
|---|---|---|---|
| 122000 (base) | 83,081 | C | **TOO NOISY** (mDNS) |
| 122001 (SSH) | 0 | A | clean - keep |
| 122002 (SMB) | 0 | A | clean - keep |
| 122003 (RDP) | 0 | A | clean - keep |
| 122004 (admin ports) | 0 | B | clean - keep |
| 122005 (internal subnets) | 63,767 | C | **TOO NOISY** (mDNS) |
| 122006 (UDP) | **270,299** | B | **VERY NOISY - still failing** |

Zeek total ~417K/24h = dominant alert-index contributor.

## 2. Top sources / destinations / ports

| Rule | Top src | Top dst | Top ports | Nature |
|---|---|---|---|---|
| 122006 | 10.11.12.13 (19,319); 10.10.202.1 (17,886) | 255.255.255.255 (139,900); 233.89.188.1 (116,216) | 10001 (232,445); 56700 (8,370) | **UDP broadcast/multicast discovery** (Sonos port 10001; LIFX 56700) |
| 122000 | 10.10.10.1 / 10.11.12.13 (4,358) | 224.0.0.251 (43,608); ff02::fb (37,533) | 5353 (81,125) | **mDNS multicast** |
| 122005 | 192.168.111.1 (4,786); 192.168.222.1 (4,360) | 224.0.0.251 (63,012); 239.255.255.250 (461) | 5353 (62,942); 1900 (461) | **mDNS / SSDP multicast** |

## 3. 122006 post-tightening count

- Phase 18 tightened 122006 (excluded 53/123/1900/443/5353/5355/51820). 
- **Post-tightening 24h: 270,299** - target was "re-measure in 24h"; result is still excessive.
- Cause: exclusions were port-only; the traffic is **broadcast (255.255.255.255) and multicast (233.89.188.1) discovery on ports 10001/56700**, which the current negates do not cover.

## 4. Keep / tune / disable decision

| Rule | Decision | Rationale |
|---|---|---|
| 122001/122002/122003 | **KEEP (Class A)** | 0 alerts/24h; clean, high-value detections |
| 122004 | **KEEP (Class B)** | 0 alerts/24h; admin-port visibility |
| 122000 | **TUNE v2** | exclude multicast/broadcast destinations (mDNS) from base anchor |
| 122005 | **TUNE v2** | restrict to unicast internal traffic (drop multicast dst) |
| 122006 | **TUNE v2 (or disable if re-tune fails)** | add dst IP exclusions (255.255.255.255, 224/4, 233/8 multicast) + exclude 10001/56700; re-measure |

## 5. IRIS routing

- **Remains DISABLED.** Class A (122001-122003) are clean, but overall packet routing stays
  gated until the noise-check after v2 shows Class A stable AND the alert-index load is sane.
- No Class A events occurred in 24h anyway; enabling routing now would route nothing.

## 6. Recommendation

- Approve Phase 19.06 v2 rule changes (multicast/broadcast exclusion at base + 122006
  destination guards + port exclusions), deploy only with approval, then re-measure 24h.
- If 122006 stays above ~5K/24h after v2, disable it and keep only Class A/B TCP rules.