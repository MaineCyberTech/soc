===================================================================
Report ID : 628
Phase     : 80
Title     : Phase 80 Capacity Forecast 9
Date      : 2026-08-30
Timestamp : 2026-08-31T02:45:28Z (UTC Z)
Timestamp : 2026-08-30T22:45:28EDT (ET EDT)
Class     : INTERNAL
Status    : PASS
Source    : ops/reports/evidence/phase80/phase80-evidence-capacity.json
Prompt    : /home/user/mct-p80/prompts/628-capacity-forecast-09.md
===================================================================

STATUS: PASS — validator p80-capacity-validate.py: PASS (all 12 required keys present and non-empty).

Forecast derived from observed consumption. Within 12-month horizon: at ≈0.27 GB/day, 178.97 GB remaining sustains ~663 days (>21 months) of ingest — no exhaustion forecast through planning horizon. consumption_rate=≈7.2 docs/s (≈625,000 alerts/day ingested, measured 60s window 49456928→49457362 docs); ≈0.27 GB/day index-store growth (49.46M docs = 21.63 GB ≈0.43 KB/doc). Warning state: OpenSearch low watermark default 85% of 200.60 GB supported = 170.51 GB; current index-store usage 21.63 GB (10.8% of supported) — nominal, far below warning. Critical state: OpenSearch high watermark 90% (180.54 GB) enforces per-index read-only block; flood-stage 95% (190.57 GB) blocks all writes; current 21.63 GB (10.8% of supported) — nominal, well within envelope. Validator PASS. Source evidence: ops/reports/evidence/phase80/phase80-evidence-capacity.json.

Capacity posture (real, observed):
  edition             = Wazuh OSS 4.14.7; OpenSearch 3.2.0 (Apache-2.0); Shuffle OSS (ghcr.io/shuffle); IRIS Community v2.4.29; OTel collector-contrib 0.118.0 — all open-source editions; no commercial/vendor license present
  version             = wazuh-indexer/wazuh-manager/wazuh-dashboard 4.14.7; shuffle-opensearch(OpenSearch engine) 3.2.0; shuffle-backend OSS latest; iriswebapp v2.4.29; otel-collector-contrib 0.118.0
  license_state       = operator-authorized OSS deployment; no vendor/commercial license present (Wazuh GPL-2.0, OpenSearch Apache-2.0, Shuffle/IRIS/OTel OSS). Authoritative entitlement = operator authorization only.
  supported_limit     = 200.6 GB
  current_usage       = 21.63 GB
  remaining_capacity  = 178.97 GB
  consumption_rate    = ≈7.2 docs/s (≈625,000 alerts/day ingested, measured 60s window 49456928→49457362 docs); ≈0.27 GB/day index-store growth (49.46M docs = 21.63 GB ≈0.43 KB/doc)
  forecast            = Within 12-month horizon: at ≈0.27 GB/day, 178.97 GB remaining sustains ~663 days (>21 months) of ingest — no exhaustion forecast through planning horizon
  warning_state       = OpenSearch low watermark default 85% of 200.60 GB supported = 170.51 GB; current index-store usage 21.63 GB (10.8% of supported) — nominal, far below warning
  critical_state      = OpenSearch high watermark 90% (180.54 GB) enforces per-index read-only block; flood-stage 95% (190.57 GB) blocks all writes; current 21.63 GB (10.8% of supported) — nominal, well within envelope
  counter_mutation_absent = true
  degradation_tested_or_blocked = true
