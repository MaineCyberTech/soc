#!/usr/bin/env python3
import json,sys
x=json.load(open(sys.argv[1]));r=["document_ids_match","documents_match","mappings_match","settings_match","aliases_match","retention_match","access_match","production_untouched"];m=[k for k in r if not x.get(k)];print(json.dumps({"missing_or_false":m},indent=2));raise SystemExit(bool(m))
