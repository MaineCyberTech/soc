# mct-canary01 Final Build

Date: 2026-08-11
Status: **BUILD BLOCKED - PVE API credentials in creds.env rejected (HTTP 401)**

## What was attempted

1. Verified PVE API reachability: port 8006 OPEN (network path fine).
2. Read-only API call (GET /api2/json/version) with stored credentials: **HTTP 401 Unauthorized**.
3. Conclusion: the PVE username/password in creds.env is stale or the account
   lacks API access (PVE 8 uses API tokens or realm-authenticated users).

## Blocker (precise)

- Cannot create VM 110 (mct-canary01) on PVE without working API credentials.
- Options: refresh PVE password in creds.env, create an API token
  (`pveuser@realm!token`), or use SSH to PVE host with a current key.
- No destructive provisioning was attempted.

## What exists (ready to execute once access works)

- `ops/runbooks/mct-canary01-build.md` - provision commands prepared:
  `qm create 110 --name mct-canary01 --memory 1024 --cores 1 ...`
- `integrations/opencanary/mct-canary01-config.md` - OpenCanary config draft
  (node_id opencanary-mct-canary01, syslog to 192.168.222.149:15140)
- Syslog forward plan: Wazuh master 15140/udp allowed-ips covers 192.168.222.0/24.
- Validation path: rule 121012 -> Shuffle -> IRIS (D1-verified for local canary).

## Validation path (documented, ready)

```text
canary VM -> port 9100 connect -> opencanary-mct-canary01 syslog
  -> Wazuh master 15140 -> rule 121012 level 12 -> IRIS (opencanary-hit template)
```

## Next action

Operator refreshes PVE credentials in creds.env (0600) or provides an API
token; then run build runbook provision commands + post-boot config.
