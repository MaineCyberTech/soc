#!/usr/bin/env python3
import json,sys,urllib.parse
x=json.load(open(sys.argv[1]));u=x.get("iris_url","");h=urllib.parse.urlparse(u).hostname;bad=h in {"127.0.0.1","localhost","::1",None};r=["iris_url","shared_network","dns_identity","tls_validated","rollback_defined"];m=[k for k in r if not x.get(k)];print(json.dumps({"missing":m,"loopback_forbidden":bad},indent=2));raise SystemExit(bool(m or bad))
