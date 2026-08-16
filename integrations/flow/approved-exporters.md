# Approved Flow Exporters

Source of truth for ElastiFlow exporter allowlist. Must match the
`flow-unknown-exporter` OpenSearch monitor must_not list.

| Site | Exporter IP | Type | Added | Notes |
|---|---|---|---|---|
| Zen | 192.168.222.1 | UniFi gateway | Deployed | LAN gateway |
| SKK | 23.150.201.36 | UniFi gateway | Deployed | Internet-facing |
| LBM-Dock | 23.150.201.165 | UniFi gateway | Deployed | Internet-facing |

## Adding a new exporter

1. Add the IP here with site/type/date.
2. Update the flow-unknown-exporter monitor must_not list (OpenSearch Alerting UI or API).
3. Verify the monitor still fires for unknown IPs (test payload below).

## Verification

```bash
# what exporters are sending flows now
curl -sk -u admin:$WAZUH_ADMIN_PASSWORD -H 'Content-Type: application/json' \
  -d '{"size":0,"query":{"range":{"@timestamp":{"gte":"now-24h"}}},"aggs":{"by_exporter":{"terms":{"field":"host.ip","size":10}}}}' \
  "https://127.0.0.1:9200/elastiflow-flow-ecs-8.0-2.5-*/_search"
```

Any exporter IP NOT in this table = Class A unknown-exporter alert.
