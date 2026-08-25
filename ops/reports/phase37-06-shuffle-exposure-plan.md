# Phase 37 — Shuffle Exposure Lockdown Plan

**Date:** 2026-08-25T19:28Z  
**Status:** APPROVED (plan only — execution in phase37-07)  
**Approval gate:** Operator approval required before execution

---

## Objective

Restrict Shuffle frontend access from all interfaces (0.0.0.0:3001) to localhost only (127.0.0.1:3001) via iptables. Operator access via SSH tunnel.

---

## Plan

### Step 1: Apply iptables Rule

```bash
# Allow localhost access to port 3001
iptables -A INPUT -p tcp --dport 3001 -s 127.0.0.1 -j ACCEPT

# Drop all other traffic to port 3001
iptables -A INPUT -p tcp --dport 3001 -j DROP
```

### Step 2: Persist iptables Rules

```bash
# Save rules (distro-dependent)
iptables-save > /etc/iptables/rules.v4
# or
netfilter-persistent save
```

### Step 3: Verify

```bash
# Confirm rule applied
iptables -L INPUT -n --line-numbers | grep 3001

# Test from localhost (should succeed)
curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:3001/

# Test from external IP (should timeout/refuse)
curl -s -o /dev/null -w "%{http_code}" http://<external-ip>:3001/ --connect-timeout 5
```

### Step 4: SSH Tunnel for Operator Access

```bash
# Operator connects via SSH tunnel
ssh -L 3001:127.0.0.1:3001 user@host

# Then access Shuffle at http://127.0.0.1:3001/ locally
```

---

## Rollback Plan

```bash
# Remove iptables rules
iptables -D INPUT -p tcp --dport 3001 -s 127.0.0.1 -j ACCEPT
iptables -D INPUT -p tcp --dport 3001 -j DROP

# Save
iptables-save > /etc/iptables/rules.v4
```

---

## Approval

| Item | Status |
|------|--------|
| Plan documented | ✅ Complete |
| Operator approval | ⏸ PENDING |
| Execution | ⏸ Blocked on approval |
| Validation | ⏸ Blocked on execution |

---

## No secrets
