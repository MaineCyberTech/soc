#!/usr/bin/env python3
"""render-branded-template.py - render client-facing artifacts from white-label
config (brand.yml + client profile). Falls back to committed examples.

Usage: python3 scripts/reporting/render-branded-template.py [--out FILE]
"""
import json, sys, pathlib, argparse

root = pathlib.Path('/opt/mct-security-stack')

def load_simple_yaml(path):
    data = {}
    if not path.exists():
        return data
    for line in path.read_text().splitlines():
        if ':' in line and not line.lstrip().startswith('-'):
            k, v = line.split(':', 1)
            data[k.strip()] = v.strip().strip('"')
    return data

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--out', default=str(root / 'reporting/output/client/phase16-whitelabel-sample-scorecard.md'))
    ap.add_argument('--email', action='store_true', help='render kickoff email too')
    args = ap.parse_args()

    # Prefer live config (gitignored), fall back to committed examples.
    brand_path = root / 'config/brand.yml'
    if not brand_path.exists():
        brand_path = root / 'config/examples/brand.example.yml'
    client_path = root / 'config/clients/example-client.yml'
    if not client_path.exists():
        client_path = root / 'config/examples/client-profile.example.yml'

    brand = load_simple_yaml(brand_path)
    client = load_simple_yaml(client_path)

    out = pathlib.Path(args.out)
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(f"""# {brand.get('brand_name','Managed Security')} Security Scorecard

Client: {client.get('client_slug','example-client')}

## Executive Summary

White-label production scorecard rendered from brand/client config.

## Endpoint Coverage

| Endpoint | Status |
|---|---|
| SAMSUNG (013) | monitored |
| DESKTOP-MI54LFT (014) | monitored |
| Julians-Air (015) | monitored |

## Alerts and Findings

- No actionable threats fleet-wide.
- FP suppression validated; macOS queue tuning applied.

## SCA and Vulnerability

- CIS benchmarks tracked. Client scan pending authorization.

## Recommendations

- Complete W1/W2 dashboards; authorize vulnerability scan.

## Support

Email: {brand.get('support_email','support@example.com')}
Phone: {brand.get('support_phone','000-000-0000')}
""", encoding='utf-8')
    print(f"Wrote {out}")

    if args.email:
        email = root / 'client-onboarding/templates/phase16-branded-kickoff-email.md'
        email.write_text(f"""Subject: {brand.get('brand_name','Managed Security')} monitoring is live for {client.get('client_slug','your organization')}

Hi {{client_contact}},

{client.get('client_slug','your organization')} is now onboarded to {brand.get('brand_name','Managed Security')} monitoring.

What is live:
- Endpoint monitoring (Windows 11 endpoints)
- Sysmon + Windows security telemetry
- Monthly security scorecard

Support: {brand.get('support_email','support@example.com')} | {brand.get('support_phone','000-000-0000')}

Best,
{brand.get('brand_name','Managed Security')}
""", encoding='utf-8')
        print(f"Wrote {email}")

if __name__ == '__main__':
    main()
