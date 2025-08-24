# Identity & Access Management: Least Privilege & Access Reviews

**Date:** August 24, 2025

## Summary (first person)
I led a least‑privilege effort for cloud roles, service accounts, and human access. I focused on role design, access review cadence, and emergency access handling.

## Business context
We needed to reduce excessive permissions and establish a repeatable access review process that would stand up in audits and keep engineers productive.

## Control objectives (mapped)
- **NIST CSF:** PR.AC (all subcategories), PR.IP-3
- **CIS Controls:** 6, 7, 8, 14, 16
- **ISO 27001:** A.5, A.6, A.8, A.9, A.12

## What I did (high level)
- Created role catalogs for human and machine identities with clear owners and purpose.
- Implemented least‑privilege policies using a deny‑by‑default approach and documented exceptions.
- Set up a quarterly access review workflow with evidence capture and remediation SLAs.
- Established break‑glass procedures with logging and post‑use reviews.
- Implemented session durations and MFA requirements; removed long‑lived keys for users.

## Evidence to include
- Role catalog (CSV or markdown) with owner, purpose, and last review date.
- Access review checklist and completed sample review with remediation notes.
- Break‑glass SOP with approvals record template.
- Before/after summary of permissions reduced.

## Metrics I report
- # of identities with administrative privileges over time.
- % of roles reviewed this quarter; % with remediation completed.
- # of long‑lived user keys eliminated.
- Mean time to revoke access after role change/termination.

## Interview: short pitch
I rationalized cloud roles, enforced MFA and short sessions, and institutionalized quarterly access reviews with clear owners and evidence. We reduced admin privileges and eliminated long‑lived user keys.

## Interview: STAR narrative
**Situation:** Access sprawl and audit findings around excessive permissions.  
**Task:** Reduce risk and implement a sustainable review process.  
**Actions:** Built a role catalog, enforced MFA and session limits, defined break‑glass, ran reviews with evidence and SLAs.  
**Result:** Cut admin roles by >50%, eliminated long‑lived keys, and closed prior audit findings with a repeatable process.

## Repo structure
- ./artifacts/ (role catalog, redacted screenshots)
- ./checklists/ (access review templates)
- ./sops/ (break‑glass, joiner/mover/leaver)
- README.md
