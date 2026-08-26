# D7 Velociraptor Evidence - Final Validation

Date: 2026-08-11
Status: **PARTIAL - precise blocker: frontend port conflict prevents client enrollment**

## What was attempted (safe, non-invasive)

1. Generated a test client config from server.config.yaml (writeback path fixed to /tmp/opencode).
2. Ran the client: it enrolled locally (assigned client id C.12ef1c00ecd2dabe) and
   attempted to reach the server.
3. Client could NOT reach the frontend: "server gave HTTP response to HTTPS client"
   then "Invalid status while downloading PEM (404)".

## Root cause (precise)

- Server config `Frontend.bind_port: 8000`, `Client.server_urls: [https://localhost:8000/]`.
- **Port 8000 is owned by Portainer** (portainer container publishes 0.0.0.0:8000).
- Velociraptor frontend therefore is NOT on 8000. Actual listeners: 8001/8003/8889
  (8889 = GUI, 8003 serves HTTP 404 on /server.pem, 8001 no response).
- This is a **pre-existing deployment defect** (Phase 2) - the client-server
  path has never been functional because the frontend port collides with Portainer.

## No invasive collection performed

Per prompt: hunt/collection requires a reachable enrolled client - not possible
until the port conflict is fixed. Nothing destructive was attempted.

## Fix plan (operator decision)

1. Change Velociraptor `Frontend.bind_port` (e.g. 8002) + `Client.server_urls`
   in server.config.yaml (or bind Portainer's 8000 elsewhere).
2. Restart velociraptor service; confirm `GET /server.pem` on the new port.
3. Regenerate client configs with the new URL.
4. Enroll test client; run Generic.Client.Info; export evidence; attach to IRIS.

## Evidence workflow (already documented, valid)

- integrations/velociraptor/evidence-to-iris-workflow.md
- integrations/velociraptor/wazuh-alert-to-hunt-map-phase5.md (updated this phase)

## Deliverables

- integrations/velociraptor/test-client-enrollment.md (with the port-conflict finding)
- integrations/velociraptor/test-client-evidence-export.md (manual steps once reachable)
- integrations/velociraptor/wazuh-alert-to-hunt-map-phase5.md
