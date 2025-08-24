# Year 2 — Hardening & Detection (GuardDuty + Security Hub + Auto-Response)

**Prepared:** August 24, 2025

## What I did (first person)
I enabled GuardDuty and Security Hub, turned on key data sources, enabled common standards (FSBP/CIS), exported findings for evidence, and automated actions: tagging impacted instances from GuardDuty findings and quarantining compromised EC2 instances via Lambda + EventBridge. I also added a vulnerability SLA calculator and formalized runbooks so remediation stays on track.

## How to use (quick)
1. `infra/terraform`: `terraform init && terraform apply` to enable GuardDuty + Security Hub.
2. `scripts/enable_securityhub_standards.sh us-east-1` to enable FSBP + CIS.
3. Create a Lambda with `lambda/quarantine_instance.py` (grant `ec2:StopInstances`), then attach an EventBridge rule using `config/eventbridge_guardduty_pattern.json`.
4. Export evidence: `scripts/export_securityhub_findings.sh us-east-1 securityhub_findings.json`.
5. Parse/tag sample: `python3 scripts/guardduty_parser.py artifacts/sample_data/guardduty_sample_finding.json --tag`.
6. SLA stats: `python3 scripts/compute_sla_adherence.py artifacts/vuln_report_sample.csv`.

## Evidence I publish
- Enabled standards (screenshot), GuardDuty settings, exported findings JSON
- Parser output showing instance IDs and tags set
- Lambda logs showing quarantine action
- SLA adherence summary from the CSV

## Interview lines
- “I tuned detections, mapped ownership, and automated quarantine for severe findings to cut time‑to‑contain.”
- “I used Security Hub FSBP/CIS as a baseline, exported findings for audit evidence, and tracked remediation SLAs.”

## Cleanup
Disable the EventBridge rule and delete the Lambda if created; `terraform destroy` to remove GuardDuty/Security Hub from this test account.
