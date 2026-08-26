# Proxmox Thin Pool Report

Date: 2026-08-16 01:51 UTC
Host: 192.168.222.222

## Pool status

| Metric | Value | Threshold |
|---|---|---|
| data thin pool usage | 87.84% | WARN 85 / ACTION 90 / EMERGENCY 95 |
| PV free | 4.75g | |
| Status | **WARN (>=85%)** | |

## Disk usage by LV (sorted by data% - VM 201-205)

```
  vm-202-disk-1      3.00g 90.92 
  vm-201-disk-0     80.00g 61.34 
  vm-204-disk-1      3.00g 46.78 
  vm-205-disk-1      3.00g 40.78 
  vm-201-disk-3      4.00m 14.06 
  vm-203-disk-1     30.00g 6.53  
  vm-201-disk-4      4.00m 1.56  
```

## Unused disk entries in VM configs

```
0
```

## Recommendations

- If >= 90%: remove unused disks (verify first), then consider pool extension.
- If >= 95%: immediate action - extend pool or reduce VM disk usage.
- Windows Update growth on pilot VMs is disabled by policy.
