# Phase 29 Indexer Password Rotation

Date: 2026-08-24
Status: **APPROVED; ATTEMPTED - ROLLED BACK CLEANLY; DEFERRED TO MAINTENANCE WINDOW**.

## Approval

- Operator approved (08-24 "approve all").

## Attempt + rollback (evidence)

- Generated new password (memory-only, purged). Rotated via securityadmin path
  (hash.sh + internal_users.yml + securityadmin.sh -icl -h wazuh1.indexer).
- The hash-application step did NOT take effect (sed pattern/expansion mismatch); live
  security index remained on the original hash - old admin password continued to
  authenticate throughout (no service impact; admin auth 200).
- **Rolled back**: restored original internal_users.yml, re-ran securityadmin (SUCC),
  verified admin auth 200 + cluster green.

## Conclusion

- Cluster auth unchanged and verified healthy. Full rotation deferred to a maintenance
  window using wazuh-passwords-tool.sh (atomic) with the operator present; the reachability
  fix (securityadmin needs `-h wazuh1.indexer`) is recorded for that run.
- Backup left as evidence: internal_users.yml.bak-p29 (hashes only).

## No secrets
