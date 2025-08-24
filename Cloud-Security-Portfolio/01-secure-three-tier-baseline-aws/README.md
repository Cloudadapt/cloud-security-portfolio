# Secure Three‑Tier App & Governance Baseline (AWS)

**Date:** August 24, 2025

## Summary (first person)
I designed and implemented a secure three‑tier application baseline on AWS to demonstrate defense‑in‑depth: network segmentation, private data access, centralized logging, encryption at rest/in transit, and continuous compliance. I framed this as a realistic internal product onboarding to the cloud with guardrails.

## Business context
A product team needed a repeatable, secure landing zone. My goal was to provide a reference stack that balances delivery speed with strong controls and audit readiness.

## Scope
- VPC with public/private subnets, NAT for egress, no direct DB public access.
- App layer behind a load balancer and WAF.
- Data layer using a managed database with encryption, backups, and restricted access.
- Centralized logging/monitoring, findings aggregation, and baseline guardrails.

## Control objectives (mapped)
- **NIST CSF:** ID.AM, PR.AC, PR.DS, PR.IP, DE.CM, RS.RP
- **CIS Controls:** 1, 2, 4, 5, 7, 8, 9, 10, 13, 14, 16, 17, 18
- **ISO 27001 (Annex A):** A.5, A.8, A.9, A.12, A.13, A.14, A.16

## What I did (high level, no code)
- Defined a baseline architecture and documented trust boundaries.
- Applied least‑privilege security groups and route rules; blocked lateral paths.
- Enabled encryption for data stores and secrets; documented key ownership and rotation expectations.
- Turned on cloud logging, config/state recording, and findings aggregation.
- Implemented a WAF ruleset for basic OWASP protections and rate limiting.
- Established backup/RPO‑RTO targets and validated restores in a non‑prod environment.
- Wrote runbooks for onboarding a new app team into the baseline.

## Evidence to include in this repo (put files/screenshots in ./artifacts)
- Network diagram with subnets, ALB/WAF, app tier, data tier.
- Screenshots/redacted exports showing logging and configuration baselines enabled.
- Backup/restore validation notes.
- Access review checklist for service roles and S3 buckets.
- WAF rules summary and test notes.

## Metrics I report
- % of resources encrypted at rest and in transit.
- Number of public endpoints vs private.
- Time to restore from backup (RTO) and data recency (RPO).
- WAF blocked request trend and false‑positive rate.
- Compliance score from the chosen baseline checklist.

## Interview: short pitch (30–45 sec)
I built a secure three‑tier AWS baseline with WAF, private subnets, centralized logging, and full encryption. I validated backups and documented guardrails so new teams could onboard safely and quickly. The measurable outcomes were higher encryption coverage, reduced public exposure, and a repeatable pattern the org could scale.

## Interview: STAR narrative
**Situation:** A product team needed to deploy to AWS quickly without compromising security.  
**Task:** I had to stand up a reusable secure baseline and prove the controls worked.  
**Actions:** I segmented the VPC, enforced TLS, enabled logging/monitoring, added WAF protections, and documented runbooks and access reviews. I validated backups and restored a test dataset.  
**Result:** We achieved 100% at‑rest encryption, eliminated direct DB public access, and reduced exposure. Onboarding time for new teams decreased while audit evidence became standardized.

## Demo script (5–7 min)
- Show the network diagram and explain trust boundaries.  
- Walk through the logging/compliance dashboard and an example finding lifecycle.  
- Show the backup/restore validation note and RPO/RTO table.  
- Open the access review checklist and highlight least‑privilege decisions.

## Repo structure
- ./artifacts/ (screenshots, diagrams, redacted exports)
- ./policies/ (baseline guardrails and access review checklist)
- ./runbooks/ (onboarding, incident, backup restore)
- README.md (this file)

## What to say if asked “what did you learn?”
I learned how to balance developer speed with security controls and how to turn controls into clear runbooks and evidence that satisfy audits without slowing delivery.
