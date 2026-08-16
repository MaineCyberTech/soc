#!/usr/bin/env python3
"""
Example scorecard generator skeleton.

Generates a client scorecard from placeholder/sample data by default.
Optional: connect to the local OpenSearch indexer to fill real numbers
(creds from environment only — never hardcode secrets).

Usage:
    python3 generate-scorecard.example.py                        # sample data
    python3 generate-scorecard.example.py --client "Client Name" # sample data, named client
    WAZUH_ADMIN_PASSWORD=<redacted> python3 generate-scorecard.example.py --live

Requires: pip install requests
"""
import argparse
import json
import os
import sys
from datetime import date
from pathlib import Path

ROOT = Path("/opt/mct-security-stack")
TEMPLATE = ROOT / "reporting/templates/client-scorecard.md"
QUERIES = ROOT / "reporting/queries"
OUTPUT = ROOT / "reporting/output"

SAMPLE = {
    "client_name": "Maine Cyber Tech Internal",
    "period": "2026-07-12 to 2026-08-10",
    "managed_agents": 12,
    "active_agents": 11,
    "offline_agents": 1,
    "class_a": 2,
    "class_b": 14,
    "total_alerts": 380,
    "confirmed_incidents": 1,
    "critical_vulns": 3,
    "internet_facing_vulns": 1,
    "sca_pass_pct": 94,
    "sysmon_enabled": "4/4",
    "velociraptor_enrolled": "6/6",
    "top_alerts": [
        ("100120 ssh bruteforce", 210, "no"),
        ("100410 unifi wan drop", 95, "no"),
        ("100900 flow unusual port", 31, "yes"),
    ],
    "incidents": [("2026-07-28", "Phishing + Sysmon TTP", "Resolved, MISP updated", "Closed")],
    "top_cves": [("CVE-2026-0000", "critical", "web01")],
    "action_items": [("Patch CVE-2026-0000", "ops", "Open")],
    "work_completed": ["Wazuh 4.14.7 multi-node online", "Elastiflow + flow relay live"],
    "next_priorities": ["Phase 2 stack validation", "Windows Sysmon rollout pilot"],
    "recommendations": ["Enable MFA on all admin accounts", "Rotate DO Spaces keys"],
}


def run_query(name: str, live: bool) -> dict:
    """Load query JSON. If live, execute against indexer; else return sample aggs."""
    q = json.loads((QUERIES / name).read_text())
    if not live:
        return {"query": name, "sample": True}
    # Live path: use requests with env creds (WAZUH_ADMIN_PASSWORD), never print values.
    import requests

    url = os.environ.get("WAZUH_INDEXER_URL", "https://127.0.0.1:9200")
    user = os.environ.get("WAZUH_ADMIN_USER", "admin")
    pwd = os.environ.get("WAZUH_ADMIN_PASSWORD", "")
    body = {**q["query"], "query": {"range": {q["time_field"]: {"gte": f"now-{q.get('range_days', 30)}d/d"}}}}
    r = requests.post(f"{url}/{q['index']}/_search", json=body, auth=(user, pwd), verify=False, timeout=30)
    r.raise_for_status()
    return r.json().get("aggregations", {})


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--client", default="Maine Cyber Tech Internal")
    ap.add_argument("--live", action="store_true", help="query OpenSearch (requires env creds)")
    args = ap.parse_args()

    data = dict(SAMPLE)
    data["client_name"] = args.client
    data["period"] = f"{date.today().replace(day=1)} to {date.today()}"

    for qname in ("wazuh-alerts.json", "agent-health.json", "elastiflow-summary.json",
                  "vulnerabilities.json", "sca-failures.json"):
        try:
            data.setdefault("queries", {})[qname] = run_query(qname, args.live)
        except Exception as exc:  # keep generator usable offline
            data.setdefault("queries", {})[qname] = {"error": str(exc), "sample": True}

    def fill(text: str, key: str, value: str) -> str:
        return text.replace(f"{{{{{key}}}}}", value)

    text = TEMPLATE.read_text()
    for key in ("client_name", "period", "active_agents", "offline_agents",
                "class_a", "class_b", "total_alerts", "confirmed_incidents",
                "critical_vulns", "internet_facing_vulns", "sca_pass_pct",
                "sysmon_enabled", "velociraptor_enrolled"):
        # Template uses <n> style; replace report-style placeholders only if present.
        text = fill(text, key, str(data.get(key, "TBD")))

    # fill computed values into the template's <n> placeholders by context
    queries = data.get("queries", {})
    alerts_total = count_total(queries.get("wazuh-alerts.json", {}))
    agents_total = count_total(queries.get("agent-health.json", {}))
    flow_total = count_total(queries.get("elastiflow-summary.json", {}))
    vuln_critical = count_bucket(queries.get("vulnerabilities.json", {}), "by_severity", "Critical")
    vuln_high = count_bucket(queries.get("vulnerabilities.json", {}), "by_severity", "High")

    text = text.replace("Endpoints under management: <n> (active <n>)",
                        f"Endpoints under management: {agents_total} (active {agents_total})")
    text = text.replace("Alerts this period: <n> (Class A <n>, Class B <n>)",
                        f"Alerts this period: {alerts_total} (Class A 0, Class B 0)")
    text = text.replace("Total flows (30d): <n>", f"Total flows (30d): {flow_total}")
    text = text.replace("- Critical: <n> (internet-facing <n>)",
                        f"- Critical: {vuln_critical} (internet-facing 0)")
    text = text.replace("- High: <n>", f"- High: {vuln_high}")

    OUTPUT.mkdir(parents=True, exist_ok=True)
    out = OUTPUT / f"scorecard-{args.client.replace(' ', '-').lower()}-{date.today()}.md"
    out.write_text(text)
    print(out)
    return 0


def count_total(q: dict) -> int:
    if not isinstance(q, dict) or "sample" in q:
        return 0
    # live path stores aggregations only; sum the largest bucket set
    total = q.get("hits", {}).get("total", {}).get("value", 0)
    if total:
        return total
    aggs = q.get("aggregations", q)
    for agg in aggs.values():
        if "value" in agg and isinstance(agg.get("value"), (int, float)):
            return int(agg["value"])
    for agg in aggs.values():
        buckets = agg.get("buckets", [])
        if buckets:
            return sum(b.get("doc_count", 0) for b in buckets)
    return 0


def count_bucket(q: dict, agg: str, key: str) -> int:
    if not isinstance(q, dict):
        return 0
    for b in q.get("aggregations", {}).get(agg, {}).get("buckets", []):
        if str(b.get("key", "")).lower() == key.lower():
            return b.get("doc_count", 0)
    return 0


if __name__ == "__main__":
    sys.exit(main())
