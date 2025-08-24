# Backup & Restore Validation Runbook

**Last updated:** 2025-08-24

## Objective
Validate that backups meet RPO/RTO targets and that restore steps are complete, documented, and repeatable.

## Preconditions
- Approved change ticket
- Test dataset identified and sanitized
- Target environment available

## Steps
1. Announce start in the change ticket and chat channel.
2. Snapshot/backup creation or selection.
3. Restore to isolated environment.
4. Verify integrity (hash or record counts) and application smoke tests.
5. Record timings: start, restore complete, validation complete.
6. Compare with RPO/RTO targets from `policies/backup_rpo_rto_table.csv`.
7. Capture screenshots/CLI output in `artifacts/`.
8. Create lessons learned and next actions.

## Rollback
If validation fails, restore previous known-good state and notify stakeholders.

## Evidence
- Screenshots
- Logs
- Completed validation checklist
