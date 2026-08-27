# Phase 55: Hook Source Restrictions (networks)

**Report ID:** phase55-124-hook-source
**Phase:** 55
**Prompt:** 124-hook-source
**Title:** Hook Source Restrictions (networks)
**Generated (UTC):** 2026-08-27T23:40:00Z
**Operator (EDT):** 2026-08-27T19:40:00-0400
**Verdict:** PARTIAL
**Classification:** INTERNAL

## Summary
Webhook trigger has empty `auth` and the intake is exposed only via the TLS proxy bound to 192.168.222.149 (not 0.0.0.0). No IP allow-list is configured at the Shuffle layer; network-level source restriction is infrastructure-owned and not inspectable here.

## Evidence
- **EV-TRIG-001 (VERIFIED):** `GET /api/v1/triggers` (org `264c0502-9136-4cfc-938b-390b97b861b8`) returns exactly ONE webhook trigger: id `736b7410-ed6a-52af-b369-89dbef6386cb`, name `suricata-eve-in`, status `running`, running `true`, bound workflow `e133a645-95b9-4e01-9454-e270d2a0b599`, owner `soc@mainecybertech.com`, `info.url` = `https://shuffler.io/api/v1/hooks/webhook_736b7410-ed6a-52af-b369-89dbef6386cb`, `version_timeout`=15. No pipelines or schedules present.
- **EV-TLS-001 (VERIFIED):** `compose/docker-compose.shuffle.yml`: backend on `127.0.0.1:5001` (loopback-only); `shuffle-tls-proxy` binds `192.168.222.149:3443:443` (TLS). Webhook `info.url` still references `shuffler.io` default (known item: forwarders must POST to local `:3443`). No TLS change performed (gated).

## Backup / Rollback
No mutation of stack configuration, secrets, services, or data performed. Reversible webhook replays posted to the existing (running) test trigger only; synthetic executions isolated. Any erroneous dead-letter/notification cache writes are guarded (try/except, never raises) and reversible via workflow revision. Restored-by-design from live Swarm spec + compose; no backup taken because no write occurred.

## Stop conditions
None (read-only).

## Limitations
Network/firewall source restriction (infra owner) not visible from Shuffle API; cannot confirm IP allow-listing. Shuffle-side: no auth token on the webhook (by design, network-restricted).

## Verdict rationale
Shuffle-side source restriction = network bind only; explicit IP allow-list UNVERIFIED (infra gate).
