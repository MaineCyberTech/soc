# Phase 78 Corpus Report

**Report ID:** 114
**Phase:** 78
**Title:** IRIS Local TLS — cert-validated delivery
**Date:** 2026-08-30
**Timestamp:** 2026-08-30T20:05:59Z (2026-08-30 16:05:59 EDT)
**Classification:** INTERNAL
**Status:** PASS
**Source Path:** /home/user/mct-p78/prompts/114-iris-tls-05.md
**Prompt:** 114-iris-tls-05

## Verdict
PASS — genuine evidence, no fabricated or host-substitute delivery.

## Evidence
In-shuffle-tools probe: TLS handshake with cafile=/run/secrets/iris-ca.crt against iriswebapp_nginx:8443 succeeded (TLSv1.3, tls_cert_validated=true). The SAN of the IRIS gateway cert includes iriswebapp_nginx, so the action's verify=/run/secrets/iris-ca.crt path is genuine, not verify=False.

## Action
Executed the deployed workflow c6b3fcd8-13e5-44a8-a818-024e4ae4422b via the Shuffle API with a synthetic Wazuh-style alert as execution_argument; the execute_python v2 action ran in shuffle-tools and delivered to IRIS over cert-validated TLS. Independent IRIS readback (Governed token) confirmed object existence and marker parity.

## Backup-Rollback
No destructive change. The /etc/hosts in-place edit in shuffle-workers/orborus/shuffle-tools is runtime-only and is reverted on container recreate (rollback = recreate the service). IRIS alert objects (607, 608) are intentionally left isolated; no IRIS DB delete was performed.

## Stop-Conditions
If IRIS readback returned non-200, or marker parity failed, or the action returned anything other than ROUTED/200, the run would be reported PARTIAL/BLOCKED. All checks passed.

## Limitations
Delivery was validated for two synthetic canaries only; production counters, cases, billing, and scorecards were not touched. The two repairs are runtime /etc/hosts edits and should be made durable by recreating the worker/orborus services with corrected extra_hosts.
