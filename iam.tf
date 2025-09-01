resource "aws_iam_role" "guardduty_notification" {
  count = var.enable_guardduty_events || var.enable_security_hub_events ? 1 : 0
  name  = "guarddutty-${data.aws_region.current.name}-notification"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = { Service = "events.amazonaws.com" },
        Action    = "sts:AssumeRole",
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.id
          }
          ArnLike = {
            "aws:SourceArn" = local.allowed_source_arns
          }
        }
      }
    ]
  })
  inline_policy {
    name = "default"
    policy = var.event_role_policy != null ? var.event_role_policy : jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Effect   = "Allow",
          Action   = var.event_role_policy_actions,
          Resource = var.cloudwatch_event_target_arn
        }
      ]
    })
  }
  tags = var.tags
}
