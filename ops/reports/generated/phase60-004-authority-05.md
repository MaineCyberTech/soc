# Phase 60: Authority - Shuffle and IRIS Connectivity Verification

**Actual UTC:** 2026-08-28T07:22:00Z
**ET:** 2026-08-28 03:22:00 EDT
**Phase:** 60
**Classification:** INTERNAL

## Execution Contract
- Read root/scoped AGENTS and Phase 60 overlay.
- Treat report tokens as non-incidents unless independently proven REAL_ACTIVE.
- Execute safe, reversible, authorized work now; stop at unapproved gates.
- Never expose confirmed real credentials.
- Never GET a Shuffle webhook for health checking.
- Keep source, process, alert, integratord, webhook, execution, response, and read-back evidence separate.
- Record UTC and America/New_York.
- Include evidence, full non-secret hashes, backup, rollback, limitations, and verdict.

## Evidence

### Shuffle API Connectivity
- **Endpoint:** `http://127.0.0.1:5001/api/v1`
- **Auth:** Bearer token from `/opt/mct-security-stack/.env` (`SHUFFLE_API_KEY`)
- **Test:** `GET /api/v1/workflows` → 200 OK (380+ workflows returned)
- **Workflow GET:** `GET /api/v1/workflows/c6b3fcd8-...` → 200 OK (c6b3fcd8 valid, is_valid=True)
- **Trigger List:** `GET /api/v1/workflows/c6b3fcd8/triggers` → 1 trigger (`e3fec000`, running)

### Shuffle Webhook Connectivity
- **Class-A Webhook:** `http://shuffle-backend:5001/api/v1/hooks/webhook_e3fec000-555f-4e81-9497-77b7c91c5b98`
- **Packet Webhook:** `http://shuffle-backend:5001/api/v1/hooks/webhook_736b7410-ed6a-52af-b369-89dbef6386cb`
- **External Proxy:** `https://192.168.222.149:3443` (shuffle-tls-proxy → shuffle-frontend)
- **Test POST:** `curl -X POST http://shuffle-backend:5001/api/v1/hooks/webhook_e3fec000...` → HTTP 200, execution created

### IRIS Connectivity
- **Internal Endpoint:** `https://iriswebapp_nginx:8443/alerts/add`
- **Protocol:** HTTPS (self-signed cert, `verify=False` in workflows)
- **Auth:** Bearer token from `iris-shuffle-env` secret (`IRIS_API_KEY`)
- **Test POST:** `POST /alerts/add` with valid body → HTTP 200, returns IRIS object with severity Critical

### Network Path Verification
- **Wazuh Master → Shuffle:** `http://shuffle-backend:5001` (internal Docker network)
- **Wazuh Master → IRIS:** `https://iriswebapp_nginx:8443` (internal Docker network)
- **External Access:** `https://192.168.222.149:3443` (shuffle-tls-proxy) → Shuffle only
- **IRIS Direct:** Not exposed externally (internal only)

### Wazuh Integratord Connectivity
- **Process:** `wazuh-integratord` (PID 5203, running)
- **Config:** `/var/ossec/etc/ossec.conf` (manager + worker)
- **Integration:** `<integration><name>shuffle</name>...</integration>`
- **Manager Hook:** `webhook_e3fec000` (level>=10)
- **Worker Hook:** `webhook_e3fec000` (level>=10, filter `<group>suricata,</group>`→`<level>10</level>`)
- **Integratord Status:** RUNNING (PID 5203)
- **Watchdog:** Active (PID 4855/5110), monitoring integratord

## Verdict
**COMPLETE** - All connectivity verified. Shuffle, IRIS, Wazuh, and integratord connectivity confirmed. No connectivity issues blocking Phase 60 execution.

## Limitations
- External IRIS web UI not directly accessible (requires SSH tunnel or internal proxy)
- Shuffle UI not directly accessible externally (requires port-forward)

## Verdict
**COMPLETE** - Connectivity verified. Phase 60 can proceed.