#!/usr/bin/env python3
"""
Monthly MCT security scorecard generator.

Dry-run mode (default): renders the monthly scorecard template with sample data,
no credentials needed. --live: pulls real counts from the local OpenSearch
indexer using creds from environment (never hardcoded).

Usage:
    python3 generate-monthly-scorecard.py                     # sample/dry-run
    python3 generate-monthly-scorecard.py --client "North Parish"   # named client, sample data
    WAZUH_ADMIN_PASSWORD=... python3 generate-monthly-scorecard.py --live --client "North Parish"
"""
import argparse
import json
import os
import sys
import urllib.request
import ssl
from datetime import date, datetime
from pathlib import Path

ROOT = Path("/opt/mct-security-stack")
TEMPLATE = ROOT / "reporting/templates/monthly-client-scorecard.md"
QUERIES = ROOT / "reporting/queries"
OUTPUT = ROOT / "reporting/output"
INDEXER = "https://127.0.0.1:9200"

SAMPLE = {
    "client_name": "Maine Cyber Tech Internal",
    "period": f"{datetime.now().replace(day=1):%Y-%m} (sample)",
    "alerts_total": 0,
    "alerts_high": 0,
    "alerts_critical": 0,
    "open_cases": 0,
    "critical_vulns": 0,
    "agents_online": 0,
    "agents_total": 0,
    "canary_hits": 0,
    "misp_matches": 0,
    "backup_ok": "n/a (sample)",
}


def opensearch_query(index: str, body: dict, auth: tuple) -> dict:
    ctx = ssl.create_default_context()
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE
    import base64
    token = base64.b64encode(f"{auth[0]}:{auth[1]}".encode()).decode()
    req = urllib.request.Request(
        f"{INDEXER}/{index}/_search",
        data=json.dumps(body).encode(),
        headers={
            "Content-Type": "application/json",
            "Authorization": f"Basic {token}",
        },
    )
    with urllib.request.urlopen(req, timeout=30, context=ctx) as resp:
        return json.load(resp)


def count_alerts(client: str, auth: tuple, last_n_days: int = 30) -> dict:
    result = {"total": 0, "high": 0, "critical": 0}
    try:
        d = opensearch_query("wazuh-alerts-*", {
            "size": 0,
            "track_total_hits": True,
            "query": {"range": {"timestamp": {"gte": f"now-{last_n_days}d"}}},
        }, auth)
        result["total"] = d["hits"]["total"]["value"]
        for lvl, key in ((8, "high"), (12, "critical")):
            body = {
                "size": 0,
                "track_total_hits": True,
                "query": {"bool": {"filter": [
                    {"range": {"timestamp": {"gte": f"now-{last_n_days}d"}}},
                    {"range": {"rule.level": {"gte": lvl}}},
                ]}},
            }
            d = opensearch_query("wazuh-alerts-*", body, auth)
            result[key] = d["hits"]["total"]["value"]
    except Exception as e:
        print(f"[warn] live query failed: {e}", file=sys.stderr)
    return result


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--client", default="Maine Cyber Tech Internal")
    ap.add_argument("--live", action="store_true", help="pull real numbers from indexer")
    ap.add_argument("--out", default=None)
    args = ap.parse_args()

    data = dict(SAMPLE)
    data["client_name"] = args.client

    if args.live:
        auth = ("admin", os.environ.get("WAZUH_ADMIN_PASSWORD", ""))
        if not auth[1]:
            print("ERROR: set WAZUH_ADMIN_PASSWORD in environment for --live", file=sys.stderr)
            return 1
        counts = count_alerts(args.client, auth)
        data.update({
            "alerts_total": counts["total"],
            "alerts_high": counts["high"],
            "alerts_critical": counts["critical"],
            "total": counts["total"],
        })
        data["period"] = f"{datetime.now():%Y-%m} (live)"
        data["agents_online"] = data["agents_total"] = "n/a"

    out = args.out or OUTPUT / f"scorecard-{args.client.lower().replace(' ', '-')}-{date.today():%Y-%m-%d}.md"
    OUT = Path(out)
    OUT.parent.mkdir(parents=True, exist_ok=True)

    if TEMPLATE.exists():
        tpl = TEMPLATE.read_text()
        for k, v in data.items():
            tpl = tpl.replace(f"{{{{ {k} }}}}", str(v))
        OUT.write_text(tpl)
    else:
        OUT.write_text(json.dumps(data, indent=2))

    print(f"Wrote {OUT} ({'live' if args.live else 'sample'})")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
