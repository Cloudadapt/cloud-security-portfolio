#!/usr/bin/env bash
set -euo pipefail
REGION="${1:-$(aws configure get region)}"; OUT="${2:-securityhub_findings.json}"
if [[ -z "${REGION}" ]]; then echo "Usage: $0 <region> <output_file>"; exit 1; fi
aws securityhub get-findings --region "${REGION}" --filters '{ "RecordState": [{"Value":"ACTIVE","Comparison":"EQUALS"}] }' --max-results 100 --query 'Findings' > "${OUT}"
echo "Exported findings to ${OUT}"
