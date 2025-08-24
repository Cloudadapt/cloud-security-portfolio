# Network Security & Zero Trust Principles

**Date:** August 24, 2025

## Summary (first person)
I applied zero‑trust principles to cloud networking: least‑privilege connectivity, private service access, WAF/Shield for internet‑facing endpoints, and flow‑log analytics.

## Business context
Reduce attack surface and lateral movement while keeping services reachable for the right parties.

## Control objectives (mapped)
- **NIST CSF:** PR.AC, PR.IP, DE.CM
- **CIS Controls:** 4, 9, 12, 13
- **ISO 27001:** A.12, A.13

## What I did (high level)
- Segmented environments and enforced private access to data services.
- Standardized WAF policies and DDoS protections for public endpoints.
- Implemented egress controls and DNS filtering for known‑bad destinations.
- Analyzed flow logs and tuned security groups based on least‑use.
- Documented peerings, endpoints, and exceptions with owners.

## Evidence to include
- Network access matrix and exception register.
- WAF policy summary and blocked traffic trend.
- Flow‑log analysis notes and right‑sizing changes.
