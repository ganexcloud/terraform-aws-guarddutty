resource "aws_guardduty_detector" "this" {
  enable                       = var.enable
  finding_publishing_frequency = var.finding_publishing_frequency
  datasources {
    s3_logs {
      enable = lookup(var.features, "s3_protection", false)
    }
    kubernetes {
      audit_logs {
        enable = lookup(var.features, "eks_audit", false)
      }
    }
    malware_protection {
      scan_ec2_instance_with_findings {
        ebs_volumes {
          enable = lookup(var.features, "ec2_ebs_malware_scan", false)
        }
      }
    }
  }
  tags = var.tags
}
