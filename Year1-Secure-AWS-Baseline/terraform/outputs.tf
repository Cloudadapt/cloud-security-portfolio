output "alb_dns_name" { value = aws_lb.alb.dns_name, description = "Public DNS of the ALB" }
output "vpc_id" { value = aws_vpc.main.id }
output "private_instance_id" { value = aws_instance.app.id }
output "waf_acl_arn" { value = aws_wafv2_web_acl.this.arn }
output "flow_log_group" { value = aws_cloudwatch_log_group.flowlogs.name }
