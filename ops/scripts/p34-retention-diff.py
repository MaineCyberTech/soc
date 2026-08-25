#!/usr/bin/env python3
import json,sys
before=json.load(open(sys.argv[1])); after=json.load(open(sys.argv[2]));
def names(x): return {i.get('index') for i in x if i.get('index')}
b=names(before); a=names(after)
print(json.dumps({'deleted':sorted(b-a),'created':sorted(a-b),'before_count':len(b),'after_count':len(a)},indent=2))
