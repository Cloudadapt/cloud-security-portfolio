# CI/CD & Supply Chain Security (GitHub to Cloud)

**Date:** August 24, 2025

## Summary (first person)
I secured the software delivery pipeline from repository to cloud by introducing identity‑aware deployments, dependency and code scanning, and secrets hygiene.

## Business context
The org adopted cloud‑native delivery. I needed to reduce supply chain risk and keep developer flow high.

## Control objectives (mapped)
- **NIST CSF:** PR.IP, PR.AC, PR.DS, DE.CM
- **CIS Controls:** 2, 3, 6, 7, 16, 18
- **ISO 27001:** A.12, A.14

## What I did (high level)
- Enforced branch protection, code review, and secrets scanning in repos.
- Introduced automated dependency and code scanning; created a risk‑based triage process.
- Implemented identity‑based deployments from CI to cloud with short‑lived credentials.
- Added policy checks for infrastructure definitions before provisioning.
- Documented exceptions and time‑boxed them with owners.

## Evidence to include
- Repo protection rules summary.
- Sample vulnerability report with triage notes and deadlines.
- Secrets scanning report with remediation steps.
- Change approval checklist for higher‑risk deployments.

## Metrics I report
- Vulnerability fix SLA adherence by severity.
- # of secrets found vs remediated.
- % of pipelines using short‑lived credentials.
- Change failure rate and mean time to restore.

## Interview: STAR narrative
**Situation:** Rapid delivery increased supply chain risk.  
**Task:** Secure repos and pipelines without impacting developer velocity.  
**Actions:** Enforced reviews and scanning, implemented short‑lived deploy identities, added policy checks, documented exceptions.  
**Result:** Faster, safer releases with measurable reductions in exposed secrets and unreviewed changes.
