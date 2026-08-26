# Phase 19 mct-portal Redis Loop Fix

Date: 2026-08-18
Status: **NOT FIXED - OWNER-BLOCKED** (portal VPS 138.197.105.82 / agent 007, no access from this session)

## 1. Current rule 120537 volume

- 24h: 9,323 (constant ~10K/day all week: 08-12..08-18 range 9.3K-11K).
- Source: agent `mct-portal-dev` (007), docker container log path
  `/var/lib/docker/containers/b90cc0ee...-json.log` (hostname `b90cc0ee2366`).

## 2. Root cause (confirmed by sample of live alerts)

```
full_log: {"log":"{\"level\":50,\"time\":1787089195731,\"pid\":1,\"hostname\":\"b90cc0ee2366\",
\"error\":\"getaddrinfo EAI_AGAIN redis\",\"msg\":\"BullMQ worker error\"}"}
```

- The portal app container cannot resolve the service hostname **`redis`**
  (`getaddrinfo EAI_AGAIN` = DNS temporary failure), so every BullMQ worker retry errors.
- Exact same pattern as Phase 18 - **root cause not addressed**.

Likely specific causes (in order, to check on the VPS):
1. App container and redis container on **different Docker networks** (compose service name
   `redis` not resolvable from the app network).
2. Docker embedded DNS (127.0.0.11) not resolving due to stale `--dns`/`dns_search` config
   or the redis service renamed/depends_on mismatch.
3. VPS systemd-resolved / DNS timeout (EAI_AGAIN is transient by nature; persistent = config).

## 3. Fix (owner: portal VPS admin - agent 007 host)

1. `docker inspect` both containers: confirm shared network + `redis` service exists.
2. Recreate the app container on the same network as redis (`docker compose up -d --force-recreate`
   or correct `networks:` mapping).
3. Verify from inside the app container: `getent hosts redis` resolves.
4. If network is correct, restart Docker DNS: `systemctl restart docker` (brief outage).
5. Confirm BullMQ worker errors stop (`docker logs <app> | grep -c "BullMQ worker error"`).

## 4. Rule level decision

- Keep rule 120537 at **level 3** (noise-reduced) while the loop persists.
- **Restore to level 5** after the VPS fix is verified (0-10 errors/24h for 48h).
- Repo `local_rules.xml` updated to level 3 this phase to match running config (drift fix).

## 5. Status

- SOC-side fix: **blocked** (VPS access required). Owner path documented; revisit next phase.
- If the owner cannot fix, alternative: raise a threshold/min-ignore on 120537 once volume
  proves fixed, or suppress identical `EAI_AGAIN redis` repeats with a first-time-only rule.

## No secrets