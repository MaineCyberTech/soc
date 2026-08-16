# Phase 8 Greenbone Results - GMP method (GSA UI optional)

Date: 2026-08-15

## Method used

- GMP protocol directly to gvmd socket (no GMP CLI / no GSA UI needed)
- Scripts: /root/gmp-*.py on VM103 (staged), docker exec into gvmd container
- Password: GREENBONE_ADMIN_PASSWORD from /opt/mct-security-stack/.env

## Results

- First scan PASS: MCT-lab-scan-242 -> Done, 10 info findings
- GSA UI remains available for manual config (https://<vm103>:443 via tunnel)

## Reusable commands

```bash
# on VM103
docker cp /root/gmp-task.py mct-security-stack-gvmd-1:/tmp/
docker exec -e GVM_PW="$GREENBONE_ADMIN_PASSWORD" mct-security-stack-gvmd-1 python3 /tmp/gmp-task.py
```
