# Velociraptor Port Rebind Runbook

## Problem

Portainer owns 8000; Velociraptor frontend (config port 8000) was unreachable.

## Procedure

1. Audit: `ss -tlnp | grep -E ':8000|:8002'`
2. Backup: `cp server.config.yaml server.config.yaml.bak-<date>`
3. Edit server.config.yaml:
   - `Frontend.bind_port: 8002`
   - `Client.server_urls: [https://VelociraptorServer:8002/]`
4. Restart: `sudo systemctl restart velociraptor`
5. Verify: `curl -sk https://127.0.0.1:8002/server.pem | head -c 30`

## Client config essentials (must match server)

- `server_urls`: use cert SAN hostname (`VelociraptorServer`) - add to /etc/hosts if needed
- `ca_certificate`: copy from server config Client.ca_certificate (config generate embeds a different CA!)
- `nonce`: copy from server config Client.nonce (config generate regenerates it!)
- Use a fresh writeback for first enrollment

## Verify enrollment

```bash
# client run
velociraptor --config client.config.yaml client -v
# server side
ls /var/tmp/velociraptor/clients/   # expect C.<hex> dir
# check-in logs show: Connected to .../reader status: 200
```

## Notes

- GUI admin password not set - set with: `velociraptor user set_password admin`
- Frontend cert SAN is VelociraptorServer; production clients need DNS or cert regen.
