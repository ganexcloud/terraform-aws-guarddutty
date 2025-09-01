provider "aws" {
  region = "us-east-1"
}

module "guardduty" {
  source = "../../"
  #features = {
  #  ec2_ebs_malware_scan = true
  #}
  tags = {
    Environment = "demo"
    Project     = "Security Monitoring"
  }
}
