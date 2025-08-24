resource "aws_wafv2_web_acl" "this" {
  name        = "${var.project}-waf"
  description = "Baseline WAF with AWS managed rules"
  scope       = "REGIONAL"
  default_action { allow {} }
  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 1
    override_action { none {} }
    statement { managed_rule_group_statement { name = "AWSManagedRulesCommonRuleSet", vendor_name = "AWS" } }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.project}-waf-common"
      sampled_requests_enabled   = true
    }
  }
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.project}-waf"
    sampled_requests_enabled   = true
  }
  tags = { Name = "${var.project}-waf" }
}

resource "aws_wafv2_web_acl_association" "alb_assoc" {
  resource_arn = aws_lb.alb.arn
  web_acl_arn  = aws_wafv2_web_acl.this.arn
}
