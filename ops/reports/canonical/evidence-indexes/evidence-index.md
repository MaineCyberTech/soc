# Evidence Index — ops/evidence Pointers

**Report ID:** canonical-evidence-index
**Phase:** 39
**Title:** Canonical Evidence Index — SHA-256 Pins Over ops/evidence (Evidence Stays Out of Band)
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T23:25:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/canonical/evidence-indexes/evidence-index.md`

---

Raw evidence is `permanent-evidence` and is NEVER copied into the canonical tree. This index pins
the 8 files currently under `ops/evidence/` (hashed live 2026-08-25T23:24Z). Referenced by the
evidence ledger (`ledgers/`) and phase workflow reports.

| Evidence file | sha256 |
|---|---|
| `p37-workflow-export/wazuh-flow-classb-to-iris.json` | `94f2d9a2d0578e1f9aa04faf539b5ad005fa0dab2578eda8a93770fde2b8cb86` |
| `p37-workflow-export/wazuh-high-severity-to-iris.json` | `b0a2721ae6bb5d0577da9789a2dbd7632d4681e02a5ff4afc9cbc52102b09380` |
| `p38-workflow-export/SHA256SUMS.txt` | `e5c5f1261db0724bd556df47b3ddf6fdd0b5e310997f3f031ae81c436d45d1b4` |
| `p38-workflow-export/e951db98-9a57-4328-8344-09f8b5b9a69f.json` | `5cde4879321a8425df2b05c90910b3ceb33de8663f28294c8e98b15f0db2356f` |
| `p38-workflow-export/eb937a37-5244-46dc-95ff-62ad4c681322.json` | `4389a64d34428982de203acfe7cbc491adaa7dc2f9d7e96e2e80f84cde0ba0d8` |
| `p38-workflow-export/executions-flow-classb.json` | `d1132a52bdf53d5c2954858ed654c7c6e285f17de462b7e959400027c9befd21` |
| `p38-workflow-export/executions-high-severity.json` | `296d12cddc67d54923a87820fd97e6081fde966a704b163400bd766d094ecb25` |
| `p39-workflow-export/packet-workflow-import.json` | `8242145e2cf4a24d6d0390e039e50efe7ab79b585faf055468d096fa883d37fc` |

Regeneration: `cd /opt/mct-security-stack/ops/evidence && find . -type f -exec sha256sum {} \; | sort -k2`.
Manual edits to this index are forbidden (regenerated wholesale by tooling).
