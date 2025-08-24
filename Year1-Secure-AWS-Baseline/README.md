# Year 1 — Secure AWS Baseline (VPC, ALB + WAF, Flow Logs)

**Prepared:** August 24, 2025

## What I did (first person)
I built a secure AWS landing zone for an internet-facing app with: segmented VPC, private app tier (no public IPs), WAF-protected ALB, VPC Flow Logs, and SSM-enabled instances (no SSH). This is the foundation I’d deliver in Year 1 of a cloud migration.

## Deploy (summary)
- Edit `terraform/variables.tf` if needed (region, CIDRs, ingress).
- In `terraform/`: `terraform init` → `terraform apply`.
- Grab `alb_dns_name` from outputs and open it to test 200 OK.
- Optional: set `enable_alb_access_logs=true` and supply `alb_logs_bucket` (precreated) to enable ALB access logs.

## Evidence to add (./artifacts)
- Screenshot of ALB page (200 OK)
- WAF metrics and sampled requests (CloudWatch)
- VPC Flow Logs entries
- Security group export
- Redacted `terraform apply` output

## Notes
- Lock down `allowed_ingress_cidr` before any real use.
- Use non-prod accounts and destroy when done: `terraform destroy`.
