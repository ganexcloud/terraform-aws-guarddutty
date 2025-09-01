output "guardduty_event_rule_id" {
  description = "GuardDuty EventBridge rule ID"
  value       = var.enable_guardduty_events ? aws_cloudwatch_event_rule.guardduty[0].id : null
}

output "security_hub_event_rule_id" {
  description = "SecurityHub EventBridge rule ID"
  value       = var.enable_security_hub_events ? aws_cloudwatch_event_rule.security_hub[0].id : null
}
