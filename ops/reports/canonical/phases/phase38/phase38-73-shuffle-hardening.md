# Phase 38-73 Shuffle Hardening Plan

**Report ID:** phase38-73-shuffle-hardening  
**Phase:** 38  
**Title:** Phase 38-73 Shuffle Credential and Exposure Hardening — APPROVAL-GATED Plan  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T21:13:25Z  
**Classification:** INTERNAL  
**Scope:** Network exposure restriction, TLS termination, bearer-token rotation for Shuffle; NOTHING APPLIED  
**Status:** PENDING  
**Authoritative:** true  
**Author:** opencode/ox-alpha  
**Owners:** ["human-operator", "opencode/ox-alpha"]  
**Evidence Roots:** ["/opt/mct-security-stack/ops/evidence/p38-workflow-export/"]  
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-73-shuffle-hardening.md`  
**Retention Class:** canonical-current  

---

## 1. Status: APPROVAL-GATED — DO NOT EXECUTE WITHOUT SIGN-OFF

Live exposure (verified 2026-08-25, docker ps): `shuffle-frontend → 0.0.0.0:3001->80/tcp`, no TLS,
no firewall restriction. Backend correctly bound to `127.0.0.1:5001`. Bearer token
`[REDACTED-TOKEN]` is disclosed in **at least 7 corpus files**
(e.g., `phase38-01-preflight.md`, `phase38-13-current-state-claims.md`, `phase38-82-code-audit.md`,
and phase36 reports) — **rotation is mandatory before ANY client-facing exposure of Shuffle**.

## 2. Step 1 — Firewall Restriction (iptables)

Restrict frontend port 3001 to loopback + admin workstation only. Pin `<ADMIN_IP>` to the actual
operator source before applying (host LAN observed: 192.168.222.149/24).

```bash
# allow loopback (local healthchecks)
sudo iptables -I DOCKER-USER -i lo -d 172.16.0.0/12 -p tcp --dport 3001 -j RETURN 2>/dev/null || true
sudo iptables -I DOCKER-USER -p tcp --dport 3001 ! -s <ADMIN_IP>/32 -j DROP
# if DOCKER-USER chain not present (non-bridge publish), fall back to INPUT:
sudo iptables -I INPUT 1 -p tcp --dport 3001 ! -s <ADMIN_IP>/32 -j DROP
sudo iptables -I INPUT 2 -i lo -p tcp --dport 3001 -j ACCEPT

# persist across reboot (debian/ubuntu)
sudo apt-get install -y iptables-persistent && sudo netfilter-persistent save
```

Preferred long-term fix (compose edit, gate G5): change shuffle-frontend publish from
`"3001:80"` to `"127.0.0.1:3001:80"` and let nginx terminate external access.

## 3. Step 2 — nginx TLS Reverse Proxy (sample config)

```nginx
server {
    listen 8444 ssl;                # new admin-facing port; 3001 stays internal-only
    server_name shuffle.internal.lan;

    ssl_certificate     /etc/nginx/ssl/shuffle.crt;
    ssl_certificate_key /etc/nginx/ssl/shuffle.key;
    ssl_protocols       TLSv1.2 TLSv1.3;

    # basic auth in front of Shuffle's own auth (defense in depth)
    auth_basic           "Shuffle Admin";
    auth_basic_user_file /etc/nginx/htpasswd.shuffle;

    location / {
        proxy_pass         http://127.0.0.1:3001;
        proxy_set_header   Host $host;
        proxy_set_header   X-Real-IP $remote_addr;
        proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_http_version 1.1;
        proxy_set_header   Upgrade $http_upgrade;      # websocket support (workflow editor)
        proxy_set_header   Connection "upgrade";
        proxy_read_timeout 3600s;
    }
}
```

## 4. Step 3 — Bearer Token Rotation Procedure

1. UI path: log in → **Settings → Your users → API keys** (or top-right avatar → *My profile*) → delete key ending context of old token → **Generate new key**. Copy once; it is shown a single time.
2. API path (after new token exists): all automation switches `Authorization: Bearer <NEW>`; verify with:
   `curl -s -H "Authorization: Bearer <NEW>" http://127.0.0.1:5001/api/v1/workflows | head -c 200`
3. Update consumers: `ops/scripts/shuffle-healthcheck.sh`, webhook smoke test, any cron using the old token.
4. Old token invalidation: confirm old token now returns HTTP 401.
5. Scrub corpus references where policy allows (generated reports are immutable history — record supersession instead; see §7).

## 5. Verification Tests (post-apply)

```bash
# FROM admin workstation (<ADMIN_IP>): must succeed over TLS proxy
curl -sk https://shuffle.internal.lan:8444/ -o /dev/null -w '%{http_code}\n'      # expect 200/302

# FROM any other LAN host: must FAIL (timeout/refused)
curl -m 5 http://<HOST_IP>:3001/ -o /dev/null                                     # expect failure

# backend unchanged
curl -s http://127.0.0.1:5001/api/v1/workflows -H "Authorization: Bearer <NEW>" >/dev/null && echo OK

# old token rejected
curl -s -o /dev/null -w '%{http_code}\n' -H "Authorization: Bearer [REDACTED-TOKEN]" \
  http://127.0.0.1:5001/api/v1/workflows                                          # expect 401
```

## 6. Workflow Impact Check + Logs To Watch

```bash
docker logs shuffle-backend --since 10m 2>&1 | grep -iE "auth|error|panic"
docker logs shuffle-frontend  --since 10m 2>&1 | tail -20
```

- Trigger one manual execution of `wazuh-high-severity-to-iris` from the Wazuh integration side and confirm it still reaches the backend (auth path unaffected by frontend binding).
- Watch for orborus/worker auth failures (`shuffle-workers.*` containers).
- If executions stall after rotation: check Wazuh integrator config still carries OLD token → update `/var/ossec/etc/ossec.conf` integration block (or environment) and restart `multi-node-wazuh.master-1`.

## 7. Residual Disclosure Risk

The current token remains visible in immutable historical reports. Rotation makes those references
harmless ONLY after step 4 confirms 401. Until then treat every disclosed copy as live. Do NOT paste
the NEW token into any report.

## 8. Rollback

```bash
sudo iptables -D INPUT -p tcp --dport 3001 ! -s <ADMIN_IP>/32 -j DROP
sudo iptables -D INPUT -i lo -p tcp --dport 3001 -j ACCEPT
sudo netfilter-persistent save          # or revert compose port binding to "3001:80"
# nginx: remove site file, reload nginx
```

Token rollback is not possible (old token invalidated); keep old-token revocation as the intended end state.

## 9. Execution Order

Firewall (§2) → TLS proxy (§3) → rotation (§4) → verification (§5) → monitoring (§6). Each sub-step
gets its own change-register entry under gate G5.
