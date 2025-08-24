#!/usr/bin/env python3
import csv, sys, datetime as dt
from collections import Counter
if len(sys.argv) < 2:
    print("Usage: compute_sla_adherence.py vuln_report.csv"); sys.exit(1)
path = sys.argv[1]; today = dt.date.today(); stats = Counter(); total = 0
with open(path) as f:
    r = csv.DictReader(f)
    for row in r:
        total += 1
        sev = row.get("Severity","Unknown").strip()
        due = row.get("DueDate","").strip()
        closed = row.get("Closed","No").lower() in ("yes","true","1")
        due_date = dt.date.fromisoformat(due) if due else None
        if closed: stats[f"{sev}_closed"] += 1
        else:
            stats[f"{sev}_open"] += 1
            if due_date and today > due_date: stats[f"{sev}_breached"] += 1
print(f"Analyzed {total} vulnerabilities")
for sev in ("Critical","High","Medium","Low","Unknown"):
    for k in ("closed","open","breached"):
        key = f"{sev}_{k}"
        if stats[key]: print(f"{key}: {stats[key]}")
