#!/usr/bin/env python3
import json, argparse, sys
try:
    import boto3
except Exception:
    boto3 = None

def extract_instance_ids(f):
    ids = []
    res = f.get("Resource", {})
    inst = res.get("InstanceDetails", {})
    if "InstanceId" in inst:
        ids.append(inst["InstanceId"])
    return ids

def main():
    p = argparse.ArgumentParser()
    p.add_argument("file")
    p.add_argument("--tag", action="store_true")
    args = p.parse_args()
    with open(args.file) as fh:
        data = json.load(fh)
    findings = data.get("Findings", data if isinstance(data, list) else [])
    insts = set()
    for f in findings:
        title = f.get("Title", f.get("Type"))
        sev = f.get("Severity", 0)
        ids = extract_instance_ids(f)
        for i in ids: insts.add(i)
        print(f"[{sev}] {title} :: {ids}")
    print("Unique instances:", sorted(insts))
    if args.tag and insts:
        if not boto3:
            print("boto3 not installed; cannot tag.", file=sys.stderr); sys.exit(2)
        ec2 = boto3.client("ec2")
        ec2.create_tags(Resources=list(insts), Tags=[{"Key":"NonCompliant","Value":"GuardDutyFinding"}])
        print("Tagged instances.")

if __name__ == "__main__":
    main()
