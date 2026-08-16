# Alert Quality Report

Period: {{ period }}

## Summary

- Total alerts: {{ total_alerts }}
- Class split: A={{ class_split.A }}, B={{ class_split.B }}, C={{ class_split.C }}, D={{ class_split.D }}
- Top rules: {{ top_rules }}
- FP candidates: {{ fp_candidates }}
- Notes: {{ notes }}

## FP review guidance

1. High-volume rules at level <= 4: review in noise-tuning-plan.md.
2. UniFi roaming/churn family: expect high volume - route C.
3. Any rule at level >= 8 with < 1% case conversion: evaluate downgrade to B/C with evidence.
