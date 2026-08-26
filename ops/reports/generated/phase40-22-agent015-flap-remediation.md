# Phase 40-22: Agent 015 Flap Remediation — Options Ranked (BLOCKED-OWNER)

**Report ID:** phase40-22-agent015-flap-remediation
**Phase:** 40
**Title:** Phase 40-22: Flap Remediation — Evidence-Backed Owner-Gated Options
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T01:50:00Z
**Classification:** INTERNAL
**Status:** BLOCKED
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-22-agent015-flap-remediation.md`

---

## 1. Status

**BLOCKED-OWNER.** All effective remediations require changes on the macOS device.
No server-side action can keep an asleep Mac transmitting keepalives; Wazuh already
auto-retries and re-registers the session on every wake (observed reconnects today,
phase40-21 §2). This report ranks the options so the owner can choose with evidence.

## 2. Options (ranked, evidence-backed)

### Option 1 — RECOMMENDED: prevent sleep during working hours [OWNER]
Either run, while working:

```bash
caffeinate -dis        # prevents display, idle-system AND disk sleep while it runs
```

or adjust System Settings → Energy (Battery/Power Adapter): disable "Put hard disks to
sleep", set "Prevent automatic sleeping on power adapter" on, extend display-off timer.

*Evidence:* flap correlates with idle windows after activity bursts; DHCP markers show
device present only when awake (phase40-21 §3). `caffeinate -dis` directly removes all
three sleep classes that sever TCP 1514 sessions.

### Option 2 — NOT NEEDED: agentd/remoted reconnect tuning [SERVER]
Wazuh's agentd auto-retries with backoff on wake; no `<server><tcp>` tuning is
required or recommended — today's reconnects succeeded within seconds of wake without
any server change. Listed for completeness so nobody "fixes" what already works.

### Option 3 — ACCEPT-WITH-MONITORING [SERVER + OWNER sign-off]
Accept sleep-cycle gaps as designed behavior; monitor instead:
- Delivery/fleet monitor watches `GET /agents` for 015 transitions and alerts only on
  absence >24h (distinguishes sleep from true loss).
- Billing treats sleep-gap hours as non-coverage per phase40-24 rules.
*Requires owner acknowledgment that overnight coverage gaps are accepted.*

## 3. Why None Apply Server-Side Today

| Lever | Available from this environment? |
|-------|----------------------------------|
| caffeinate / Energy settings | NO — runs in user session on the Mac |
| MDM power profile | NO MDM channel provisioned |
| Wake-on-LAN | Not provisioned; subnet broadcast path unverified |
| Keepalive tuning | Unnecessary (Option 2) |

## 4. Persistence & Logging Plan (attached to whichever option is chosen)

1. Record choice + date in change register (operator sign-off if Option 3).
2. Option 1: verify via ≥6h gap-free keepalive stretch during declared work hours;
   log first 48h of KA timestamps as evidence addendum to phase40-23.
3. Option 3: enable fleet-monitor rule for 015 (>24h absence → alert); document
   expected daily gap window.
4. Re-check weekly until phase40-23 sustained-keepalive check passes, then close arc.
