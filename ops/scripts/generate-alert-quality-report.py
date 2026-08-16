#!/usr/bin/env python3
"""
Alert quality report generator.

Measures alert volume vs actionable signal: top rules, FP candidates,
rule hit rates, Class A/B/C/D split. Dry-run renders sample data.

Usage:
    python3 generate-alert-quality-report.py                  # sample
    WAZUH_ADMIN_PASSWORD=... python3 generate-alert-quality-report.py --live
"""
import argparse
import json
import os
import sys
import urllib.request
import ssl
from datetime import date
from pathlib import Path

ROOT = Path("/opt/mct-security-stack")
OUTPUT = ROOT / "reporting/output"
INDEXER = "https://127.0.0.1:9200"

SAMPLE = {
    "period": f"{date.today():%Y-%m} (sample)",
    "total_alerts": 0,
    "top_rules": [],
    "fp_candidates": [],
    "class_split": {"A": 0, "B": 0, "C": 0, "D": 0},
    "notes": "sample data - run --live for real numbers",
}


def q(index: str, body: dict, auth: tuple) -> dict:
    ctx = ssl.create_default_context()
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE
    import base64
    token = base64.b64encode(f"{auth[0]}:{auth[1]}".encode()).decode()
    req = urllib.request.Request(
        f"{INDEXER}/{index}/_search", data=json.dumps(body).encode(),
        headers={"Content-Type": "application/json", "Authorization": f"Basic {token}"},
    )
    with urllib.request.urlopen(req, timeout=30, context=ctx) as resp:
        return json.load(resp)


def live_data(auth: tuple) -> dict:
    data = {}
    total = q("wazuh-alerts-*", {"size": 0, "track_total_hits": True, "query": {"match_all": {}}}, auth)
    data["total_alerts"] = total["hits"]["total"]["value"]
    data["period"] = f"{date.today():%Y-%m} (live)"

    top = q("wazuh-alerts-*", {
        "size": 0,
        "aggs": {"by_rule": {"terms": {"field": "rule.id", "size": 10}}},
    }, auth)
    data["top_rules"] = [f"{b['key']}: {b['doc_count']}" for b in top["aggregations"]["by_rule"]["buckets"]]

    fp = q("wazuh-alerts-*", {
        "size": 0,
        "aggs": {"by_level": {"terms": {"field": "rule.level", "size": 20}}},
    }, auth)
    data["class_split"] = {
        "A": 0, "B": 0, "C": 0, "D": 0,
    }
    for b in fp["aggregations"]["by_level"]["buckets"]:
        lvl = b["key"]
        if lvl >= 12: data["class_split"]["A"] += b["doc_count"]
        elif lvl >= 8: data["class_split"]["B"] += b["doc_count"]
        elif lvl >= 5: data["class_split"]["C"] += b["doc_count"]
        else: data["class_split"]["D"] += b["doc_count"]
    data["fp_candidates"] = ["level<=4 high-volume rules - review in noise-tuning-plan.md"]
    data["notes"] = "live data"
    return data


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--live", action="store_true")
    ap.add_argument("--out", default=None)
    args = ap.parse_args()

    if args.live:
        auth = ("admin", os.environ.get("WAZUH_ADMIN_PASSWORD", ""))
        if not auth[1]:
            print("ERROR: set WAZUH_ADMIN_PASSWORD for --live", file=sys.stderr)
            return 1
        data = live_data(auth)
    else:
        data = dict(SAMPLE)

    out = Path(args.out or OUTPUT / f"alert-quality-report-{date.today():%Y-%m-%d}.md")
    out.parent.mkdir(parents=True, exist_ok=True)
    lines = [f"# Alert Quality Report - {data['period']}", ""]
    lines.append(f"- Total alerts: {data['total_alerts']}")
    lines.append("- Class split: " + ", ".join(f"{k}={v}" for k, v in data["class_split"].items()))
    lines.append("- Top rules: " + ("; ".join(data["top_rules"]) if data["top_rules"] else "n/a"))
    lines.append("- FP candidates: " + ("; ".join(data["fp_candidates"]) if data["fp_candidates"] else "none"))
    lines.append(f"- Notes: {data['notes']}")
    out.write_text("\n".join(lines) + "\n")
    print(f"Wrote {out} ({'live' if args.live else 'sample'})")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
