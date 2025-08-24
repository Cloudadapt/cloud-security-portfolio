# Year 3 — CI/CD & Supply Chain Security with OIDC Deploy (GitHub → AWS)

**Prepared:** August 24, 2025

## What I did (first person)
I secured the pipeline end-to-end: secret, dependency, container, and IaC scans; SBOM generation; and environment approvals. I replaced static keys with GitHub **OIDC → AWS** for short-lived deploy credentials and pushed images to ECR. This shows modern supply-chain controls that support delivery speed.

## Quick start
1. **Create ECR**: `cd deploy/ecr/terraform && terraform init && terraform apply` (save output `repository_url`).  
2. **OIDC Role**: `cd ../../aws-oidc-iam/terraform && terraform init && terraform apply -var='github_org=Cloudadapt' -var='github_repo=cloud-security-portfolio' -var='ecr_repo_arn=arn:aws:ecr:...:repository/your-repo'`.  
3. **Repo secrets**: set `AWS_ROLE_TO_ASSUME`, `AWS_REGION`, `ECR_REPOSITORY`.  
4. **Protect environment**: GitHub → Settings → Environments → `production` (require reviewers).  
5. **Run**: push to `main` or `Run workflow` in Actions.

## Evidence I commit or attach
- CI artifacts: `artifacts/pip_audit.json`, `artifacts/trivy_container.txt`, `artifacts/sbom.spdx.json`
- Screenshot: environment approval + deploy note
- Terraform outputs for ECR/role (redacted)

## Interview lines
- “I added policy-as-code checks and SBOMs to every build and swapped long-lived keys for OIDC short-lived creds.”
- “The pipeline requires environment approvals and stores evidence for audit and remediation SLAs.”

## Cleanup
- Remove the ECR repo and OIDC role if not needed; restrict scope to exact repo/branch.
