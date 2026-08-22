# Phase 23 Approval Gates Checklist

Owner: SOC operator. Check each gate before the corresponding change.

## C1 - 014 Sysmon tuning
- [ ] Endpoint access confirmed (operator/Velociraptor authorized path)
- [ ] Approval marker recorded (operator)
- [ ] Sysmon config exported + hash captured
- [ ] EventID 7/1/10 baseline captured (endpoint + Wazuh side)
- [ ] Rollback config retained
- [ ] Apply -> verify parse -> reload -> agent keepalive + EID1/10 continuity
- [ ] Before/after + throttle retirement decision

## C2 - 015 macOS
- [ ] (External apply appears done 04:22 UTC) Validate only: reconnect, 24h volume <=50K,
      0 queue-full, bounded events present
- [ ] If validation fails: re-apply via bundle (check -> apply) with backup

## C3 - Zeek Class A routing
- [ ] Clean-window evidence current (<=~316/day; Class A minimal)
- [ ] Shuffle/IRIS health confirmed
- [ ] Duplicate-case protection + rate limits in place
- [ ] Approval marker recorded
- [ ] Enable -> case-volume window (<5/day) -> rollback if exceeded

## C4 - Disk relief
- [ ] Per-item approval (no evidence/snapshot/backup deletion outside policy)
- [ ] Dry-run/inventory first; log bytes reclaimed per item
- [ ] Post: disk < 85%, cluster green, no write blocks

## C5 - PVE222 token
- [ ] Replacement token provided (not printed)
- [ ] creds.env update + healthcheck PASS

## C6/C7 - Credential rotation
- [ ] Replacement values/approval present
- [ ] env-render/abstraction path used (no literals)
- [ ] Post-rotation validation (24)

## C8 - Docs governance
- [ ] CI + secret scan PASS before commit

## No secrets