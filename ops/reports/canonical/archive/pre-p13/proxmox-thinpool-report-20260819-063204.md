# Proxmox Thin Pool Report

Date: 2026-08-19 06:32 UTC
Host: 192.168.222.187

## Pool status

| Metric | Value | Threshold |
|---|---|---|
| data thin pool usage | 0.00% | WARN 85 / ACTION 90 / EMERGENCY 95 |
| PV free | <206.93g | |
| Status | **OK** | |

## Disk usage by LV (sorted by data% - VM 201-205)

```

```

## Unused disk entries in VM configs

```
0
```

## Recommendations

- If >= 90%: remove unused disks (verify first), then consider pool extension.
- If >= 95%: immediate action - extend pool or reduce VM disk usage.
- Windows Update growth on pilot VMs is disabled by policy.
