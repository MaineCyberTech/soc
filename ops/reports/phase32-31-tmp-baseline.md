# Phase 32 /tmp Baseline

Date: 2026-08-25
- /tmp tmpfs 7.6G; baseline after P31v2 cleanup: 6-9% used, ~173K inodes (17%).
- Producer: JVM/process temp files (pyc trees, opencode scratch, transient .so) - spread
  across 143K dirs; narrowed but not single-attributable.

## No secrets
