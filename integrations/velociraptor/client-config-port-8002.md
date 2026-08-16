# Velociraptor Client Config (port 8002)

## Working client config keys (verified 2026-08-11)

```yaml
Client:
  server_urls: ['https://VelociraptorServer:8002/']   # cert SAN hostname
  ca_certificate: <copy from server config Client.ca_certificate>
  nonce: <copy from server config Client.nonce>
  writeback_linux: /etc/velociraptor.writeback.yaml   # per host
```

## Critical gotchas

1. `config generate` embeds a DIFFERENT ca_certificate than the server - must copy.
2. `config generate` regenerates the nonce - must copy from server.
3. Client URL must use the frontend cert SAN (`VelociraptorServer`), not localhost/IP.
4. First enrollment needs a fresh writeback.

## Client rollout (any OS)

1. Obtain client config (fixed per above) + server CA.
2. Linux: `velociraptor --config client.config.yaml service install`
3. Windows: `velociraptor-v0.77.2-windows-amd64.exe service install --config client.config.yaml`
4. Verify in GUI (https://127.0.0.1:8889) -> Clients.
