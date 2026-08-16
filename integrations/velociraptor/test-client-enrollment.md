# Velociraptor Test Client Enrollment

## Status

BLOCKED - frontend port conflict (port 8000 owned by Portainer; Velociraptor
config points clients at https://localhost:8000/).

## Fix (operator)

```bash
# 1. Edit /opt/mct-security-stack/data/velociraptor/server.config.yaml
#    Frontend.bind_port: 8000 -> 8002  (and Client.server_urls -> https://localhost:8002/)
# 2. Restart
sudo systemctl restart velociraptor
# 3. Verify
curl -sk https://127.0.0.1:8002/server.pem | head -c 50
```

## Enrollment (after fix)

```bash
# generate client config (from server config)
cd /tmp/opencode
/usr/local/bin/velociraptor --config /opt/mct-security-stack/data/velociraptor/server.config.yaml config generate > client.config.yaml
# fix writeback path (user-writable)
sed -i 's|writeback_linux: /etc/velociraptor.writeback.yaml|writeback_linux: /tmp/opencode/velo.writeback.yaml|' client.config.yaml
# run client (non-invasive; it enrolls + polls)
timeout 30 /usr/local/bin/velociraptor --config client.config.yaml client -v
# verify enrollment: GUI (https://127.0.0.1:8889) -> Clients -> new client id
```

## Notes

- Client id format: C.<hex> (e.g. C.12ef1c00ecd2dabe).
- The client only needs to run during collection; keep it short-lived for the test.
- After enrollment, run a hunt (see test-client-evidence-export.md).
