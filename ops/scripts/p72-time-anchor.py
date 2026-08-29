#!/usr/bin/env python3
from datetime import datetime,timezone
from zoneinfo import ZoneInfo
import json
u=datetime.now(timezone.utc);print(json.dumps({"utc":u.isoformat(),"eastern":u.astimezone(ZoneInfo("America/New_York")).isoformat()},indent=2))
