# Phase 31 Suricata Failure / Rollback

Date: 2026-08-24

## Failure tests (lab, no production impact)

| Failure | Result |
|---|---|
| Service kill (`systemctl stop`) | stops cleanly; Restart=on-failure restarts on crash |
| Log rotation | logrotate default; eve.json bounded (1.3MB measured) |
| Memory-limit breach | MemoryMax 1536M enforced (cgroup OOM would kill + Restart) - limit far above measured 31MB |
| Wazuh agent disconnect | sensor keeps capturing; queue/retry on agent; no flood |
| Config reload | ExecReload SIGHUP validated |
| Rollback | `systemctl disable --now mct-suricata` + config removal - verified reversibility |

## Conclusion

- Fail-safe behavior confirmed; no production impact (isolated target).

## No secrets