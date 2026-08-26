# Phase 29 Full System Audit

Date: 2026-08-24

## Live stack (post-change)

| Area | P28 | P29 | Regression |
|---|---|---|---|
| Healthcheck | 0 FAIL | **2 FAIL (Security Onion VM down + suricata)** | NO (external VM outage) |
| CI | PASS | ACTION REQUIRED (agent 008 not active - same SO outage) | NO (environmental) |
| Secret | PASS | PASS | NO |
| Cluster | green | green (264 shards) | NO |
| Guardrail | operational | operational (exec 100755; cron firing; failover re-proven) | NO |
| Fleet | 3/3 coverage | 3/3 coverage; 013/015 transient offline; 008 (SO) down | NO |
| Images | 8 mutable (P0) | pins prepared + CI gate + exec-mode audit (approval-pending) | NEW (improved) |
| Capacity | 81% | 82%; **swap 98%** (watch) | NO (watch) |
| Canonical map | PARTIAL (scorecard generators wrong) | **CORRECTED** (ops/scripts canonical) | NO |

## Findings

1. **Security Onion VM down** - 192.168.222.116 100% ping loss; agent 008 disconnected
   since 18:59Z. External; healthcheck + CI both reflect it (correct). Owner action.
2. **Memory pressure** - swap 98% (7.9/8.0GiB), free mem 249MiB; consumers = indexer JVMs +
   shuffle opensearch. Watch; restart shuffle-opensearch or reduce heap if exhausts.

## Verdict

- **No regressions from phase changes**; 2 environmental incidents (SO VM, memory pressure)
  tracked. Guardrail + image-pinning posture improved.

## No secrets