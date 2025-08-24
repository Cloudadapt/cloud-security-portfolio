# Baseline Validation Checklist

- [ ] ALB DNS returns 200 OK
- [ ] WAF metrics visible in CloudWatch
- [ ] VPC Flow Logs receiving entries
- [ ] Private instance has no public IP and is reachable only via ALB
- [ ] Security groups follow least privilege
- [ ] Terraform state is stored securely (if remote backend used)
