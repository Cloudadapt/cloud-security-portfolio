resource "aws_guardduty_detector" "this" {
  enable = true
  datasources {
    s3_logs { enable = true }
    kubernetes { audit_logs { enable = true } }
    malware_protection { scan_ec2_instance_with_findings { ebs_volumes = true } }
  }
  tags = { Project = var.project }
}

resource "aws_securityhub_account" "this" {
  depends_on = [aws_guardduty_detector.this]
}

output "guardduty_detector_id" { value = aws_guardduty_detector.this.id }
