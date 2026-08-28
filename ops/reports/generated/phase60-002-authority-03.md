# Phase 60: Authority - Workspace and Tooling Inventory

**Actual UTC:** 2026-08-28T07:18:00Z
**ET:** 2026-08-28 03:18:00 EDT
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

### Workspace Inventory
- **Repo Root:** `/opt/mct-security-stack` (git repo, main branch, commit `f8e2a1b`)
- **Phase 60 Pack:** `/home/user/mct-p60/` (380 prompts, manifest, run-order, docs)
- **Reports Dir:** `/opt/mct-security-stack/ops/reports/generated/` (380+ existing Phase 59 reports + new Phase 60)
- **Current Reports:** `/opt/mct-security-stack/ops/reports/current/`
- **Evidence Dir:** `/opt/mct-security-stack/ops/evidence/`
- **AGENTS.md:** `/opt/mct-security-stack/AGENTS.md` (current commit `f8e2a1b`)

### Tooling Inventory
- **Shuffle API:** `http://127.0.0.1:5001/api/v1` (key in `/opt/mct-security-stack/.env`)
- **Wazuh Manager:** `multi-node-wazuh.master-1` container
- **IRIS:** `iriswebapp_nginx:8443` (internal), `iriswebapp_nginx:8443` via shuffle-tls-proxy
- **Shuffle Backend:** `shuffle-backend:5001` (internal)
- **Docker Swarm:** Active (manager + worker nodes)
- **Swarm Secrets:** `iris-shuffle-env` (mounted at `/run/secrets/iris-shuffle.env` and `/shuffle-files/iris-shuffle.env`)
- **Watchdog Script:** `/usr/local/bin/integratord_watchdog_persist.sh` (deployed, tested)

### Key Identifiers
- **Class-A Workflow:** `c6b3fcd8-13e5-44a8-a818-024e4ae4422b` (wazuh-high-severity-to-iris)
- **Class-A Trigger:** `e3fec000-555f-4e81-9497-77b7c91c5b98` (status: running)
- **Packet Workflow:** `e133a645-95b9-4e01-9454-e270d2a0b599` (suricata-packet-routing)
- **Packet Trigger:** `736b7410-ed6a-52af-b369-89dbef6386cb` (running)
- **Class-A Webhook:** `webhook_e3fec000-555f-4e81-9497-77b7c91c5b98`
- **Packet Webhook:** `webhook_736b7410-ed6a-52af-b369-89dbef6386cb`
- **Corrupted Workflow:** `eb937a37-5244-46dc-95ff-62ad4c681322` (GET=400, DELETE=401)

### Scripts Inventory
- `/home/user/mct-p60/ops/scripts/p60-time-anchor.py` - UTC/Eastern timestamp capture
- `/home/user/mct-p60/ops/scripts/p60-inventory.py` - Prompt inventory validation
- `/home/user/mct-p60/ops/scripts/p60-state-validate.py` - State machine validation
- `/home/user/mct-p60/ops/scripts/p60-correlation-validate.py` - Correlation field validation

## Verdict
**COMPLETE** - Workspace and tooling inventory complete. All required tools and identifiers documented.

## Limitations
- Inventory reflects current state; may change during Phase 60 execution
- Some external dependencies (IRIS web UI, Shuffle UI) not inventoryable via API

## Verdict
**COMPLETE** - Workspace and tooling inventory complete.