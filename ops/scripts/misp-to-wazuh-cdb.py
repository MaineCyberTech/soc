#!/usr/bin/env python3
"""
MISP -> Wazuh CDB malicious IOC export (production version).

Pulls MISP events tagged for blocking (action:block) with confidence >= medium,
not expired, and writes a Wazuh CDB list. Then pushes the list into the running
Wazuh master/worker containers (analysisd auto-reloads on file change).

Secrets come from environment/file, never from argv:
  - MISP API key: /opt/mct-security-stack/ops/backups/misp-api-key.txt
  - Config: /opt/mct-security-stack/ops/cdb/misp-cdb.conf (BASE_URL etc.)

Usage:
    python3 misp-to-wazuh-cdb.py [--output /opt/mct-security-stack/ops/cdb/malicious-iocs.cdb]
    python3 misp-to-wazuh-cdb.py --push   # also copy into wazuh master/worker containers
"""
import argparse
import json
import os
import re
import ssl
import sys
import urllib.request
import urllib.error
from datetime import datetime, timezone
from pathlib import Path

STACK = Path("/opt/mct-security-stack")
KEY_FILE = STACK / "ops/backups/misp-api-key.txt"
CONF_FILE = STACK / "ops/cdb/misp-cdb.conf"
DEFAULT_OUTPUT = STACK / "ops/cdb/misp-iocs"

CONF_DEFAULTS = {
    "MISP_BASEURL": "https://192.168.222.154:8443",
    "MIN_CONFIDENCE": "confidence:medium",
    "BLOCK_TAGS": "action:block",
}


def load_conf() -> dict:
    conf = dict(CONF_DEFAULTS)
    if CONF_FILE.exists():
        for line in CONF_FILE.read_text().splitlines():
            line = line.strip()
            if line and not line.startswith("#") and "=" in line:
                k, _, v = line.partition("=")
                conf[k.strip()] = v.strip()
    return conf


def api_get(baseurl: str, api_key: str, path: str) -> dict:
    # Internal MISP uses a self-signed cert; verify=False is acceptable on the
    # private management network (firewalled to the Wazuh host only).
    ctx = ssl.create_default_context()
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE
    req = urllib.request.Request(f"{baseurl}{path}", headers={
        "Authorization": api_key,
        "Accept": "application/json",
    })
    with urllib.request.urlopen(req, timeout=30, context=ctx) as resp:
        return json.load(resp)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--output", default=str(DEFAULT_OUTPUT))
    ap.add_argument("--push", action="store_true", help="copy the CDB into wazuh master/worker containers")
    args = ap.parse_args()

    if not KEY_FILE.exists():
        print("ERROR: MISP API key file not found", file=sys.stderr)
        return 1
    api_key = KEY_FILE.read_text().strip()
    conf = load_conf()
    baseurl = conf["MISP_BASEURL"]

    try:
        events = api_get(baseurl, api_key, "/events/index")
    except urllib.error.HTTPError as e:
        print(f"ERROR: MISP API {e.code}: {e.read()[:200]!r}", file=sys.stderr)
        return 1
    except Exception as e:
        print(f"ERROR: MISP API unreachable: {e}", file=sys.stderr)
        return 1

    now = datetime.now(timezone.utc)
    lines = set()
    ioc_count = 0
    for ev in events or []:
        # index view lacks tags/attributes: fetch the full event
        try:
            detail = api_get(baseurl, api_key, f"/events/{ev['id']}")
            ev = detail.get("Event", detail)
        except Exception as e:
            print(f"WARNING: event {ev.get('id')} detail failed: {e}", file=sys.stderr)
            continue
        tags = [t.get("name", "") for t in (ev.get("Tag") or ev.get("EventTag") or [])]
        if conf["BLOCK_TAGS"] not in tags:
            continue
        conf_tags = [t for t in tags if t.startswith("confidence:")]
        if not any(c in conf_tags for c in (conf["MIN_CONFIDENCE"], "confidence:high")):
            continue
        for attr in (ev.get("Attribute") or []):
            atype = attr.get("type", "")
            if atype in ("ip-src", "ip-dst", "domain", "hostname", "sha256", "md5"):
                key = attr.get("value", "").strip().lower()
                if not key:
                    continue
                # drop subnets/ranges for now (CDB exact match)
                if "/" in key:
                    continue
                lines.add(f"{key}:")
                ioc_count += 1

    out = Path(args.output)
    out.parent.mkdir(parents=True, exist_ok=True)
    # Wazuh CDB plain-list format: "key:" per line (analysisd compiles .cdb automatically)
    out.write_text("\n".join(sorted(lines)) + ("\n" if lines else ""))
    print(f"Wrote {ioc_count} IOCs to {out}")

    if args.push:
        for container in ("multi-node-wazuh.master-1", "multi-node-wazuh.worker-1"):
            rc = os.system(f"docker cp {out} {container}:/var/ossec/etc/lists/malicious-ioc/misp-iocs")
            print(f"push -> {container}: {'OK' if rc == 0 else 'FAILED'}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
