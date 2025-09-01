resource "aws_cloudwatch_event_rule" "guardduty" {
  count       = var.enable_guardduty_events ? 1 : 0
  name        = "guarddutty-${data.aws_region.current.name}-notifications"
  description = "Route GuardDuty findings to target"
  event_pattern = jsonencode({
    source        = ["aws.guardduty"],
    "detail-type" = ["GuardDuty Finding"],
    detail = merge(
      {
        severity = [for s in range(max(1, floor(var.min_severity * 10)), 90) : s / 10]
      },
      length(var.suppressed_types) > 0 ? {
        type = { "anything-but" = var.suppressed_types }
      } : {}
    )
  })

  tags = var.tags
}

resource "aws_cloudwatch_event_rule" "security_hub" {
  count          = var.enable_security_hub_events ? 1 : 0
  name           = "guarddutty-security-hub-${data.aws_region.current.name}-notifications"
  description    = "Route SecurityHub GuardDuty findings to target"
  event_bus_name = "default"
  event_pattern = jsonencode({
    source        = ["aws.securityhub"],
    "detail-type" = ["Security Hub Findings - Imported"],
    detail = {
      findings = merge(
        {
          ProductArn = [
            { prefix = "arn:aws:securityhub:${data.aws_region.current.name}:product/aws/guardduty" }
          ],
          Severity = {
            Normalized = [
              { numeric = [">=", local.min_severity_normalized] }
            ]
          }
        },
        length(var.suppressed_types) > 0 ? {
          Types = { "anything-but" = var.suppressed_types }
        } : {}
      )
    }
  })

  tags = var.tags
}

resource "aws_cloudwatch_event_target" "guardduty_target" {
  count     = var.enable_guardduty_events ? 1 : 0
  rule      = aws_cloudwatch_event_rule.guardduty[0].name
  target_id = "guardduty-findings-target"
  arn       = var.cloudwatch_event_target_arn
  role_arn  = aws_iam_role.guardduty_notification[0].arn
  dynamic "input_transformer" {
    for_each = var.event_transformer_enabled ? [true] : []
    content {
      input_paths = {
        severity     = "$.detail.findings[0].Severity.Label"
        account_id   = "$.detail.findings[0].AwsAccountId"
        finding_id   = "$.detail.findings[0].Id"
        finding_type = "$.detail.findings[0].Types[0]"
        region       = "$.region"
        title        = "$.detail.findings[0].Title"
        description  = "$.detail.findings[0].Description"
        url          = "$.detail.findings[0].SourceUrl"
      }
      input_template = var.event_input_template != null ? var.event_input_template : <<EOF
{
  "account": "<account_id>",
  "id": "<finding_id>",
  "region": "<region>",
  "source": "GuardDuty",
  "detail-type": "<title>",
  "detail": {
    "severity": "<severity>",
    "type": "<finding_type>",
    "title": "<title>",
    "description": "<description>"
  }
}
EOF
    }
  }
}

resource "aws_cloudwatch_event_target" "security_hub_target" {
  count     = var.enable_security_hub_events ? 1 : 0
  rule      = aws_cloudwatch_event_rule.security_hub[0].name
  target_id = "security-hub-findings-target"
  arn       = var.cloudwatch_event_target_arn
  role_arn  = aws_iam_role.guardduty_notification[0].arn

  dynamic "input_transformer" {
    for_each = var.event_transformer_enabled ? [true] : []
    content {
      input_paths = {
        severity     = "$.detail.findings[0].Severity.Label"
        account_id   = "$.detail.findings[0].AwsAccountId"
        finding_id   = "$.detail.findings[0].Id"
        finding_type = "$.detail.findings[0].Types[0]"
        region       = "$.region"
        title        = "$.detail.findings[0].Title"
        description  = "$.detail.findings[0].Description"
        url          = "$.detail.findings[0].SourceUrl"
      }
      input_template = var.event_input_template != null ? var.event_input_template : <<EOF
{
  "account": "<account_id>",
  "id": "<finding_id>",
  "region": "<region>",
  "source": "SecurityHub",
  "detail-type": "<title>",
  "detail": {
    "severity": "<severity>",
    "type": "<finding_type>",
    "title": "<title>",
    "description": "<description>"
  }
}
EOF
    }
  }
}
