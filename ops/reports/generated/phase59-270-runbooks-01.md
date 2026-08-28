**Report ID:** phase59-270-runbooks-01
**Phase:** 59
**Title:** Runbooks 01
**Date:** 2026-08-28
**Timestamp:** 2026-08-28T05:56:29Z
**Classification:** INTERNAL
**Status:** VERIFIED
**Source Path:** ops/reports/generated/phase59-270-runbooks-01.md

## Execution
- Contract: read AGENTS + Phase 59 overlay; real, reversible, authorized work; stop at gates; never GET a Shuffle webhook; never expose secret values.

## Evidence (layered)
Monitor: monitor excludes synthetic.

## Ground truth
- UTC: 2026-08-28T05:56:29Z | ET: 2026-08-28 01:56:29 EDT
- Class-A: c6b3fcd8 (wazuh-high-severity-to-iris) status=test is_valid=True trigger e3fec000 running LITERAL_IRIS_KEY=False (rotated to c2173178...)
- Packet: e133a645 (suricata-packet-routing) trigger 736b7410 running LITERAL_IRIS_KEY=False
- Corrupt: eb937a37-5244-46dc-95ff-62ad4c681322 GET=400 / DELETE=401 (RBAC)
- integratord running: True | hook_url=http://shuffle-backend:5001/api/v1/hooks/webhook_e3fec000... | level>=10
- Watchdog: deployed at /usr/local/bin/integratord_watchdog_persist.sh, tested functional (restarted integratord PID 5203)
- IRIS token rotated: new key c2173178... deployed to iris-shuffle-env, workflows verified ROUTED 200
- Watchdog persistence: deployed at /usr/local/bin/integratord_watchdog_persist.sh, survives container restart
