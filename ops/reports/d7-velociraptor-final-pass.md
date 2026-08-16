# D7 Velociraptor Evidence - FINAL PASS

Date: 2026-08-11
Status: **PASS**

## Evidence path validated (non-invasive)

```text
Test client (this host) enrolled -> server pushed flow (Generic.Client.Stats)
  -> client executed collection -> results stored server-side
  -> export/attach to IRIS (documented workflow)
```

## Proof

1. Client enrolled: C.ef79f1598cca19a9 (server filestore clients/)
2. Check-in: /reader HTTP 200, /control HTTP 200 (client log)
3. Flow F.D9TR4TO1N2RC2 collected + completed (collections/stats.json.db)
4. Evidence export workflow documented: integrations/velociraptor/d7-evidence-export.md
5. IRIS attachment: manual upload path (case -> Evidence) documented

## What was fixed to unblock

- Port rebind 8000 -> 8002 (Portainer conflict)
- Client config: server_urls (cert SAN), ca_certificate, nonce
- /etc/hosts entry for VelociraptorServer

## Remaining (not blockers)

- GUI admin password not set (hunt launch via GUI/API needs it)
- IRIS evidence attachment is manual (no automation - acceptable)
- Production client rollouts need cert-SAN-matched DNS or cert regen
