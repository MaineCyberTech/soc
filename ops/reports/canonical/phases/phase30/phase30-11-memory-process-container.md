# Phase 30 Memory Process and Container Inventory

Date: 2026-08-24
Tooling: p30-memory-audit.sh (process-swap-kb.txt, processes.txt, docker-stats.txt).

## Top consumers

| Process | RSS | VmSwap (swapped) | Note |
|---|---|---|---|
| java (wazuh1.indexer) | 1.60GB | 465MB | indexer JVM |
| java (wazuh2.indexer) | 1.51GB | 369MB | indexer JVM |
| java (wazuh3.indexer) | 1.55GB | 359MB | indexer JVM |
| java (shuffle-opensearch) | 1.40GB | - | opensearch JVM (limit 1.5GB) |
| flowcoll (elastiflow) | 811MB | - | netflow collector |
| opencode | 799MB / 21.6% CPU | - | session tool (transient) |
| tenzir-node | 486MB | - | tenzir (5.2% CPU) |
| wazuh-modulesd | 370MB | 159MB | manager module |
| celery (shuffle) xN | ~700KB each | ~146MB total | shuffle workers |

## Container limits (docker stats)

- opencanary 128MiB (36%), shuffle-frontend 256MiB, shuffle-backend 768MiB,
  shuffle-orborus 384MiB, shuffle-opensearch 1.5GiB.
- **indexer containers: NO memory limit** (mem_limit=0) - unbounded on 15GiB host.

## Conclusion

- ~6GB of Java JVMs + ~1.3GB flowcoll/tenzir + base = 12GB committed. Indexers unbounded;
  heap default (no explicit -Xmx). Swapped pages concentrated in indexer JVMs + modulesd.

## No secrets