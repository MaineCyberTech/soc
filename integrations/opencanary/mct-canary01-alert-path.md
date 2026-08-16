# mct-canary01 Alert Path

```text
canary VM port touch -> opencanary-mct-canary01 JSON syslog
  -> Wazuh master 15140/udp (allowed-ips 192.168.222.0/24)
  -> decoder json -> rule 121012 "OpenCanary: connection made" level 12 (Class A)
  -> Shuffle webhook (wazuh-high-severity trigger) -> IRIS opencanary-hit case
```

## Validation

1. From canary: `timeout 3 bash -c "</dev/tcp/127.0.0.1/9100"`
2. Wazuh host: soc-smoke-test.sh --opencanary (or grep archives for opencanary-mct-canary01)
3. Confirm rule 121012 + IRIS case

## Distinction

- opencanary-mct-01 = local host canary
- opencanary-mct-canary01 = dedicated VM canary (when built)

## Fallback

If Shuffle variable substitution fails: static title + raw payload (case tagged shuffle-templating-degraded).
