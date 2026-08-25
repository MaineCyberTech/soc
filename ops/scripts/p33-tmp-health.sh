#!/usr/bin/env bash
set -euo pipefail
SPACE_WARN=${SPACE_WARN:-70}; SPACE_FAIL=${SPACE_FAIL:-90}; INODE_WARN=${INODE_WARN:-70}; FILE_WARN=${FILE_WARN:-250000}
space=$(df -P /tmp | awk 'NR==2{gsub(/%/,"",$5);print $5}'); inode=$(df -Pi /tmp | awk 'NR==2{gsub(/%/,"",$5);print $5}'); files=$(find /tmp -xdev -mindepth 1 2>/dev/null | wc -l)
state=HEALTHY; [ "$space" -ge "$SPACE_WARN" ] || [ "$inode" -ge "$INODE_WARN" ] || [ "$files" -ge "$FILE_WARN" ] && state=DEGRADED; [ "$space" -ge "$SPACE_FAIL" ] && state=FAILED
printf 'state=%s space_pct=%s inode_pct=%s files=%s
' "$state" "$space" "$inode" "$files"
[ "$state" != FAILED ]
