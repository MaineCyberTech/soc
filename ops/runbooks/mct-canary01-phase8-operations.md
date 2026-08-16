# mct-canary01 Operations

## Build (when access)

1. VM 202 Debian 13 (manual-vm-create-procedure.md).
2. Install docker + opencanary (mct-canary01-final-config.md).
3. Validate: soc-smoke-test.sh --opencanary -> rule 121012.

## Operations

- Health: docker ps | grep opencanary
- Event path: local canary D1 drill (validated)
- Hit triage: IRIS opencanary-hit, Class A
- Quarterly placement review; no real creds on canary

## Safety

- Deception only; no blocking.
- FP cautions: scanner 192.168.222.154 suppressed; host probes 172.20.0.1 benign.
