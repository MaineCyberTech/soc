#!/usr/bin/env python3
"""
Example: MISP -> Wazuh CDB malicious IOC export.

Pulls MISP events tagged for blocking (action:block, confidence >= medium,
not expired) and writes a Wazuh CDB list file. Placeholder — configure
values from the protected secret store, never hardcode secrets.

Usage:
    python3 misp-to-wazuh-cdb.example.py [--output /tmp/malicious-iocs.cdb]

Requires: pip install pymisp
"""
import argparse
import sys

try:
    from pymisp import PyMISP
except ImportError:
    sys.exit("pymisp not installed: pip install pymisp")

MISP_URL = "<REDACTED_URL>"            # e.g. https://misp.internal
MISP_API_KEY = "<REDACTED_TOKEN>"      # read from env in production
ORG_NAME = "Maine Cyber Tech Internal"
BLOCK_TAGS = ["action:block"]
MIN_CONFIDENCE = "confidence:medium"


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", default="/tmp/malicious-iocs.cdb")
    args = parser.parse_args()

    misp = PyMISP(MISP_URL, MISP_API_KEY, False)
    events = misp.search(
        tags=BLOCK_TAGS,
        to_ids=True,
        with_attachments=False,
        pythonify=True,
        include_events_attributes=True,
    )

    lines = []
    for event in events:
        tags = [t.name for t in event.tags]
        if MIN_CONFIDENCE not in tags:
            continue
        if hasattr(event, "expiration") and event.expiration and event.expiration < 0:
            continue  # expired
        org = event.Orgc.name if hasattr(event, "Orgc") else ""
        for attr in event.attributes:
            if attr.type in ("ip-src", "ip-dst"):
                key = attr.value
            elif attr.type in ("domain", "hostname"):
                key = attr.value
            elif attr.type == "sha256":
                key = attr.value
            else:
                continue
            lines.append(f"{key}:1,source:misp,type:{attr.category},org:{org}")

    with open(args.output, "w", encoding="utf-8") as fh:
        fh.write("\n".join(sorted(set(lines))) + "\n")

    print(f"Wrote {len(lines)} IOCs to {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
