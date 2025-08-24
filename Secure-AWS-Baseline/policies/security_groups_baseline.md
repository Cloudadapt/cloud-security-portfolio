# Security Group Baseline (Excerpt)

- Public ingress only to ALB and edge components.
- App tier accepts traffic only from ALB SG.
- No direct internet access to private app (egress via NAT only).
- Changes require ticket and review; capture evidence.
