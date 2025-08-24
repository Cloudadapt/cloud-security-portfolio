# Data Protection: Encryption, KMS & Secrets Management

**Date:** August 24, 2025

## Summary (first person)
I implemented an encryption and secrets management pattern to protect data at rest and in transit, and I clarified key ownership and lifecycle responsibilities.

## Business context
Sensitive customer data moved to the cloud. We needed strong encryption, proper key lifecycle, and reduced secret sprawl.

## Control objectives (mapped)
- **NIST CSF:** PR.DS, PR.AC-1, PR.IP-12
- **CIS Controls:** 3, 4, 6, 8, 10, 14
- **ISO 27001:** A.8, A.10, A.12

## What I did (high level)
- Enabled encryption for data stores; clarified key ownership and rotation policy.
- Centralized secrets in a managed secrets store; removed plaintext secrets from repos/CI.
- Documented data classification mapping to encryption requirements.
- Created a key rotation calendar and emergency key revocation steps.
- Implemented TLS and documented cipher standards.

## Evidence to include
- Data classification-to-encryption requirement matrix.
- Key inventory with owner, rotation, and usage notes (sanitized).
- Secrets store policy and example redacted secret lifecycle record.
- TLS standards sheet and validation notes.

## Metrics I report
- % of data stores and secrets managed centrally.
- # of plaintext secrets found vs. remediated.
- Key rotation adherence rate and time to revoke.

## Interview: STAR narrative
**Situation:** Cloud migration increased data exposure risk.  
**Task:** Ensure encryption and secrets are consistently managed with clear ownership.  
**Actions:** Standardized encryption, centralized secrets, defined rotation and revocation, mapped classification to controls.  
**Result:** Achieved near‑total encryption coverage, eliminated plaintext secrets in repos, and defined measurable ownership.
