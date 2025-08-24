# Emergency Key Revocation

**Updated:** 2025-08-24

## Steps
1. Notify stakeholders and freeze affected workloads.
2. Disable key usage in KMS; record time.
3. Rotate dependent secrets and credentials.
4. Re-encrypt data with a replacement key.
5. Validate application functionality.
6. Document impact and timelines; attach logs and approvals.

## Evidence
- KMS event log
- Secret rotation log
- Validation results
