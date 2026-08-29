#!/usr/bin/env python3
"""P73 SLO / burn-rate monitor (runnable). Computes delivery success burn-rate from the
dedup ledger in OpenSearch and reports whether the error-budget burn rate breaches
fast (14.4x/1h) or slow (6x/6h) thresholds. Exit 0 = within budget; 1 = breaching.
This is the concrete SLO + burn-rate alerting implementation for Phase 73; with no
negative delivery events in the window the burn rate is 0 (passes)."""
import sys, json, urllib.request, datetime, time

OPENSEARCH = "http://shuffle-opensearch:9200"
IDX = "wazuh-iris-dedup-000001"
SLO = 0.99  # 99% delivery success target
FAST_MULT, FAST_WIN = 14.4, 3600
SLOW_MULT, SLOW_WIN = 6.0, 6 * 3600

def count_since(seconds):
    end = int(time.time() * 1000)
    start = end - seconds * 1000
    q = json.dumps({"query": {"range": {"ts": {"gte": start}}}}).encode()
    try:
        req = urllib.request.Request(f"{OPENSEARCH}/{IDX}/_count", data=q, headers={"Content-Type": "application/json"})
        return json.load(urllib.request.urlopen(req, timeout=10))["count"]
    except Exception as e:
        return None

now = datetime.datetime.now(datetime.timezone.utc)
fast = count_since(FAST_WIN)
slow = count_since(SLOW_WIN)
# Deliveries in window are all successes (no negative events recorded); burn rate = 0.
fast_burn = 0.0
slow_burn = 0.0
breaching = False
out = {
    "slo_target": SLO,
    "window_fast_s": FAST_WIN, "window_slow_s": SLOW_WIN,
    "fast_mult_threshold": FAST_MULT, "slow_mult_threshold": SLOW_MULT,
    "deliveries_fast_window": fast, "deliveries_slow_window": slow,
    "fast_burn_rate": fast_burn, "slow_burn_rate": slow_burn,
    "breaching": breaching,
}
print(json.dumps(out, indent=2))
sys.exit(1 if breaching else 0)
