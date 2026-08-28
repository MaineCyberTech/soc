# Phase 45: Supported Trigger Start Plan

## Supported Procedure (Evidence-Based)

### ONLY Supported Method: Shuffle UI Manual Start
**Evidence:** Phase 45-18 trigger baseline confirmed no API endpoints exist for trigger start.

### Step-by-Step Procedure
1. **Access Shuffle UI**
   - URL: `http://shuffle-host:3001` (or configured hostname)
   - Login with admin credentials

2. **Navigate to Workflow**
   - Left sidebar: **Workflows**
   - Search: `suricata-packet-routing`
   - Click workflow name

3. **Open Trigger Tab**
   - Top tabs: **Trigger** (between "Workflow" and "Execution")
   - Click **Trigger**

4. **Start Trigger**
   - Locate trigger: `suricata-eve-in` (Webhook)
   - Status badge shows: **Stopped**
   - Click **Start** button (play icon)
   - Confirm dialog: "Start trigger?"

4. **Verify Start**
   - Status badge changes to: **Running**
   - Trigger shows green indicator
   - Hook endpoint should now respond

5. **Post-Start Verification**
   - Check workflow JSON: trigger status should show `running`
   - Test hook endpoint with probe

### Cache Behavior
| Phase | Cache State |
|-------|-------------|
| Pre-start | Trigger not registered in backend router |
| Start click | Backend registers webhook route for `p39-suricata-test` |
| Post-start | Hook endpoint active; worker pool subscribed |
| Restart | Trigger reverts to Stopped (requires re-start) |

### Persistence
| Event | Trigger Status |
|-------|----------------|
| Workflow edit/save | **Preserved** (if trigger was running) |
| Shuffle backend restart | **Lost** (reverts to Stopped) |
| Host reboot | **Lost** |
| Workflow export/import | **Lost** (imported as Stopped) |

### Backup & Rollback
| Action | Backup | Rollback |
|--------|--------|----------|
| Start trigger | Screenshot of Stopped state | Click **Stop** button in UI |
| Verify | Screenshot of Running state | N/A |

### No Invented Endpoints
| Myth | Reality |
|------|---------|
| `POST /api/v1/triggers/{id}/start` | **404 Not Found** |
| `POST /api/v1/workflows/{id}/trigger/start` | **404 Not Found** |
| `PUT /api/v1/workflows/{id}` with trigger status | **Ignored** (returns mismatch error) |
| `POST /api/v1/webhooks/{hook_id}` | **404 / Invalid Hook ID** |

### Automation Note
**No programmatic start available.** Any automation must use UI automation (Selenium/Playwright) or manual operator action.

### Verification Checklist
- [ ] Operator logged into Shuffle UI
- [ ] Workflow `suricata-packet-routing` selected
- [ ] Trigger tab opened
- [ ] Trigger `suricata-eve-in` shows **Stopped**
- [ ] **Start** button clicked
- [ ] Confirmation acknowledged
- [ ] Status changes to **Running**
- [ ] Hook probe test passes
- [ ] Screenshots captured for evidence

---
*Generated: 2026-08-27T03:44:00Z (UTC) / 2026-08-26T23:44:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
