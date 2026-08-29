#!/usr/bin/env python3
import json,sys
x=json.load(open(sys.argv[1]));r=["approval","compose_sha256","old_backend_id","new_backend_id","scoped_secret_present","ca_present","admin_secret_absent","dead_letter_preserved","ledger_preserved","strict_e2e_passed","rollback_defined"];m=[k for k in r if not x.get(k)];print(json.dumps({"missing_or_false":m},indent=2));raise SystemExit(bool(m))
