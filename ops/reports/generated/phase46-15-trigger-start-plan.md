# Phase 46: Supported Trigger Start Procedure

## Purpose
Document the only supported method to start the webhook trigger, derived from local platform evidence (no invented endpoints).

## Procedure

### Prerequisites
1. Shuffle UI accessible at `https://192.168.222.149:3443`
2. User authenticated with workflow edit permissions
3. Workflow `suricata-packet-routing` exists (ID `e133a645…`)

### Steps (UI-Only)
1. Navigate to Shuffle UI → Settings → Workflows
2. Select `suricata-packet-routing` workflow
3. Click on the **trigger node** (`suricata-eve-in`)
4. In trigger panel, click **Start** (or toggle from Stopped to Started)
5. Verify status changes from `stopped` to `started`
6. Note the hook URL: `/api/v1/hooks/p39-suricata-test`

### Persistence
- Trigger state persists across backend restarts (Shuffle-managed)
- Once started, remains started until manually stopped
- Worker cache populated on first execution

### Test After Start
1. Send test event via:
   ```bash
   curl -X POST https://192.168.222.149:3443/api/v1/hooks/p39-suricata-test \
     -H "Content-Type: application/json" \
     -d '{"alert":{"signature_id":2027967,"src_ip":"10.0.0.1","dest_ip":"10.0.0.2","dest_port":443,"proto":"tcp"},"timestamp":"2026-08-27T06:00:00Z"}'
   ```
2. Verify workflow execution in Shuffle UI → Executions

### Rollback
1. Navigate to trigger panel
2. Click **Stop**
3. Verify hook URL returns "Hook ID not valid"

### Limitations
- **No API endpoint** for start/stop — UI only
- **No programmatic trigger management** — manual intervention required
- **No webhook test endpoint** — must start trigger first

## Evidence
- Trigger status STOPPED verified via API (Phase 46-14)
- Hook invalidity verified via curl (Phase 45-21)
- UI accessibility verified via prior phases

## Verification
- [ ] Procedure documented from platform evidence only
- [ ] No invented endpoints
- [ ] UI steps clear
- [ ] Rollback procedure included
- [ ] Test after start included

---
*Generated: 2026-08-27T06:15:00Z (UTC) / 2026-08-27T02:15:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
