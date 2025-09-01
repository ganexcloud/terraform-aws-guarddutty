locals {
  min_severity_normalized = max(1, floor(var.min_severity * 10))
  allowed_source_arns = compact([
    try(aws_cloudwatch_event_rule.guardduty["main"].arn, null),
    try(aws_cloudwatch_event_rule.security_hub["main"].arn, null),
  ])
}
