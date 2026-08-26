# Phase 33 /tmp Producer Attribution

Date: 2026-08-25
- Narrowed: bulk = JVM/process temp trees (pyc caches under CI/py_compile runs, opencode
  scratch, transient .so) - spread across many small files; not a single PID.
- Attribution: p32-tmp-audit tracks by user/dir; pyc trees (p30-pyc/mct-p28-pyc) originate
  from python compile with PYTHONPYCACHEPREFIX. Mitigation: set PYTHONPYCACHEPREFIX to a
  bounded location; opencode scratch to a workdir.

## No secrets
