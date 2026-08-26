# Phase 39 AGENTS Discovery — Zero Instruction Files Found (Create-First Scenario)

**Report ID:** phase39-53-agents-discovery
**Phase:** 39
**Title:** Discovery of AGENTS.md / Agent-Instruction Files Across All Approved Roots — Result: ZERO Files, Create-First Arc
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T23:12:59Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Author:** opencode/ox-alpha
**Owner:** MCT SOC (automation: opencode/ox-alpha)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-53-agents-discovery.md`

---

## 1. Method

Single recursive case-insensitive search over every approved root (repo root, wazuh-docker
checkout, and the local pack directories), per the p39 pack preservation rule:
"Discover every `AGENTS.md`, `agents.md`, agent instruction file, or equivalent scoped
instruction file before editing."

## 2. Invocation and Evidence

```text
$ find /opt/mct-security-stack /opt/wazuh-docker /home/user \
    -maxdepth 6 \( -iname "AGENTS.md" -o -iname "agents.md" \
    -o -iname "*agent-instruction*" \) 2>/dev/null
(no output; exit 0)

$ find /opt/mct-security-stack -maxdepth 2 -iname "*.md" | grep -i agent
(no output; exit 1 — no filename-level matches at any depth of the repo root either)
```

Result: **zero files matched.** No `AGENTS.md`, no lowercase variant, no nested scoped
instruction file anywhere in:

| Root | Depth | Matches |
|---|---|---|
| `/opt/mct-security-stack` (git repo, origin github.com:MaineCyberTech/soc) | full tree via maxdepth-6 sweep + root-level sweep | **0** |
| `/opt/wazuh-docker` | 6 | **0** |
| `/home/user/mct-p33…p39` packs | 3 | **0** |

The p39 pack requirement "determine scope by directory hierarchy / never overwrite a more
specific nested file" was still evaluated: there is nothing to conflict with.

## 3. Implication — Create-First Scenario

- The backup step of the standard reconciliation flow is **N/A for this arc** (nothing to
  back up); this is documented rather than silently skipped (see phase39-54).
- This arc CREATES the first root `AGENTS.md` at `/opt/mct-security-stack/AGENTS.md`.
- Because there are no pre-existing instructions, nothing can be "lost" in this creation;
  the risk profile inverts from preservation to **invention risk** — the new file must
  codify only rules with provenance (phase39-55) and verified facts (phase39-56).
- Hash baseline: going forward, every future edit must be preceded by a timestamped backup
  + sha256 (policy established in phase39-54).

## 4. Precedence Model Going Forward

1. The root `AGENTS.md` governs the entire repository.
2. A future nested `AGENTS.md` (e.g., `compose/AGENTS.md`, `scripts/AGENTS.md`) may
   override or refine root guidance **for its subtree only**; root rules marked MUST/MUST NOT
   that concern safety, secrets, and immutable evidence remain non-overridable floors.
3. Any newly discovered external instruction file (packs, runbooks) does not outrank the
   root file; it becomes a candidate source to reconcile into it (with a change-ledger entry).
4. Conflicts between root and nested files must be surfaced, not silently resolved;
   resolution is recorded in the change register (phase39-02 lineage).

## Verdict

Discovery COMPLETE. Zero pre-existing agent-instruction files. Proceed create-first with
provenance-backed content (phase39-55/56), validation (58/59), dry run (62), apply (63).
