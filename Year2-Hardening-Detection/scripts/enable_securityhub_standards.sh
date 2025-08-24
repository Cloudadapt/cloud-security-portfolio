#!/usr/bin/env bash
set -euo pipefail
REGION="${1:-$(aws configure get region)}"
if [[ -z "${REGION}" ]]; then echo "Usage: $0 <region>"; exit 1; fi
echo "Using region: ${REGION}"
FSBP_ARN=$(aws securityhub list-standards --region "${REGION}" --query "Standards[?contains(Name, 'AWS Foundational Security Best Practices')].StandardsArn | [0]" --output text)
CIS_ARN=$(aws securityhub list-standards --region "${REGION}" --query "Standards[?contains(Name, 'CIS AWS Foundations')].StandardsArn | [0]" --output text)
aws securityhub batch-enable-standards --region "${REGION}" --standards-subscription-requests "[{\"StandardsArn\": \"${FSBP_ARN}\"}, {\"StandardsArn\": \"${CIS_ARN}\"}]"
echo "Enabled: FSBP + CIS standards in ${REGION}"
