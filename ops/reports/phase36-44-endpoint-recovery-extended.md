# Phase 36: Endpoint Recovery Summary Extended

Date: 2026-08-25

## Extended recovery notes

### Agent 012 (MCT-WIN11PILOT)
- Platform: Windows 11
- Status: ACTIVE, keepalive fresh
- Version: v4.14.7
- Config drift: none

### Agent 014 (DESKTOP-MI54LFT)
- Platform: Windows
- Status: ACTIVE, keepalive fresh
- Version: v4.14.7
- Config drift: none

### Agent 016 (mct-packet-sensor)
- Platform: Linux (sensor)
- Status: ACTIVE, keepalive fresh
- Suricata: active on SPAN port
- Logcollector: eve.json + eve-alert.json forwarding
- Config backup: .bak-p34 exists

### Overall fleet health
- 3/5 active (excluding retired 008)
- 2/5 disconnected (013 Samsung, 015 Julians-Air)
- Expected recovery: auto-reconnect on device wake

## No secrets
