variable "enable" {
  description = "Enable or disable the module (no-op when false)"
  type        = bool
  default     = true
}

variable "finding_publishing_frequency" {
  description = "Frequency of publishing findings from GuardDuty to EventBridge"
  type        = string
  default     = "FIFTEEN_MINUTES"
  validation {
    condition     = contains(["FIFTEEN_MINUTES", "ONE_HOUR", "SIX_HOURS"], var.finding_publishing_frequency)
    error_message = "The finding_publishing_frequency value must be one of: FIFTEEN_MINUTES, ONE_HOUR, SIX_HOURS."
  }
}

variable "features" {
  description = "Map of GuardDuty features to enable (supports S3 protection, EKS audit logs, and EC2 EBS malware scan in AWS provider v4)"
  type        = map(bool)
  default = {
    s3_protection        = false
    eks_audit            = false
    ec2_ebs_malware_scan = false
  }
}

variable "cloudwatch_event_target_arn" {
  description = "ARN of the target para EventBridge events (SNS, Lambda, SQS, etc)"
  type        = string
  default     = null
}

variable "event_transformer_enabled" {
  description = "Whether to enable input transformer for EventBridge events"
  type        = bool
  default     = true
}

variable "event_input_template" {
  description = "Custom input template for EventBridge events transformer"
  type        = string
  default     = null
}

variable "event_role_policy" {
  description = "Custom IAM policy for EventBridge role"
  type        = string
  default     = null
}

variable "event_role_policy_actions" {
  description = "List of IAM actions to allow in EventBridge role"
  type        = list(string)
  default     = ["events:InvokeApiDestination"]
}

variable "enable_security_hub_subscription" {
  description = "(Required) Enable a Guardduty Subscription."
  type        = bool
  default     = false
}

variable "enable_guardduty_events" {
  description = "Whether to use GuardDuty as an event source."
  type        = bool
  default     = false
}

variable "enable_security_hub_events" {
  description = "Whether to use SecurityHub as an event source."
  type        = bool
  default     = false
}

variable "min_severity" {
  description = "Minimum GuardDuty severity to notify. Ranges: Low=0.1–3.9, Medium=4.0–6.9, High=7.0–8.9"
  type        = number
  default     = 4.0
  validation {
    condition     = var.min_severity >= 0.0 && var.min_severity <= 8.9
    error_message = "The min_severity value must be between 0.0 and 8.9."
  }
}

variable "suppressed_types" {
  description = "List of finding types to suppress notifications for"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
