# Phase 15 Dashboard W1/W2 Build Notes (operator)

Date: 2026-08-16

## Prerequisite data (verified)

- Index pattern: wazuh-alerts-4.x-*
- Fields: data.win.system.channel, data.win.system.eventID,
  data.win.eventdata.image, data.win.eventdata.imageLoaded,
  agent.id, rule.level, timestamp.

## W1 - Windows Endpoint Health

Panels (saved searches -> dashboard):
1. Agent status: agent.id:012 OR 013, latest event time.
2. Channel flow: terms data.win.system.channel (24h).
3. Event volume: date_histogram timestamp, filter agents 012/013.
4. Alert volume: terms rule.level (24h).

## W2 - Sysmon Overview

1. EID distribution: terms data.win.system.eventID, filter Sysmon channel.
2. Top images: terms data.win.eventdata.image (EID 1).
3. Module loads: terms data.win.eventdata.imageLoaded (EID 7).
4. Suppression check: count rule.id 92153/92900 (expect ~0 post-suppression).

## Build steps

1. Wazuh dashboard -> Discover -> create saved searches (names: W1-* / W2-*).
2. Dashboard -> Create -> add panels.
3. Time filter 24h; save "W1 Windows Endpoint Health" + "W2 Sysmon Overview".

## Acceptance

- Both dashboards show data for agents 012 + 013.
- Suppression panel shows 92153/92900 near-zero (post-7-day).

## No secrets
