<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.67.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.guardduty](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_rule.security_hub](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.guardduty_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_event_target.security_hub_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_guardduty_detector.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_detector) | resource |
| [aws_iam_role.guardduty_notification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_securityhub_product_subscription.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_product_subscription) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_event_target_arn"></a> [cloudwatch\_event\_target\_arn](#input\_cloudwatch\_event\_target\_arn) | ARN of the target para EventBridge events (SNS, Lambda, SQS, etc) | `string` | `null` | no |
| <a name="input_enable"></a> [enable](#input\_enable) | Enable or disable the module (no-op when false) | `bool` | `true` | no |
| <a name="input_enable_guardduty_events"></a> [enable\_guardduty\_events](#input\_enable\_guardduty\_events) | Whether to use GuardDuty as an event source. | `bool` | `false` | no |
| <a name="input_enable_security_hub_events"></a> [enable\_security\_hub\_events](#input\_enable\_security\_hub\_events) | Whether to use SecurityHub as an event source. | `bool` | `false` | no |
| <a name="input_enable_security_hub_subscription"></a> [enable\_security\_hub\_subscription](#input\_enable\_security\_hub\_subscription) | (Required) Enable a Guardduty Subscription. | `bool` | `false` | no |
| <a name="input_event_input_template"></a> [event\_input\_template](#input\_event\_input\_template) | Custom input template for EventBridge events transformer | `string` | `null` | no |
| <a name="input_event_role_policy"></a> [event\_role\_policy](#input\_event\_role\_policy) | Custom IAM policy for EventBridge role | `string` | `null` | no |
| <a name="input_event_role_policy_actions"></a> [event\_role\_policy\_actions](#input\_event\_role\_policy\_actions) | List of IAM actions to allow in EventBridge role | `list(string)` | <pre>[<br/>  "events:InvokeApiDestination"<br/>]</pre> | no |
| <a name="input_event_transformer_enabled"></a> [event\_transformer\_enabled](#input\_event\_transformer\_enabled) | Whether to enable input transformer for EventBridge events | `bool` | `true` | no |
| <a name="input_features"></a> [features](#input\_features) | Map of GuardDuty features to enable (supports S3 protection, EKS audit logs, and EC2 EBS malware scan in AWS provider v4) | `map(bool)` | <pre>{<br/>  "ec2_ebs_malware_scan": false,<br/>  "eks_audit": false,<br/>  "s3_protection": false<br/>}</pre> | no |
| <a name="input_finding_publishing_frequency"></a> [finding\_publishing\_frequency](#input\_finding\_publishing\_frequency) | Frequency of publishing findings from GuardDuty to EventBridge | `string` | `"FIFTEEN_MINUTES"` | no |
| <a name="input_min_severity"></a> [min\_severity](#input\_min\_severity) | Minimum GuardDuty severity to notify. Ranges: Low=0.1–3.9, Medium=4.0–6.9, High=7.0–8.9 | `number` | `4` | no |
| <a name="input_suppressed_types"></a> [suppressed\_types](#input\_suppressed\_types) | List of finding types to suppress notifications for | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_guardduty_event_rule_id"></a> [guardduty\_event\_rule\_id](#output\_guardduty\_event\_rule\_id) | GuardDuty EventBridge rule ID |
| <a name="output_security_hub_event_rule_id"></a> [security\_hub\_event\_rule\_id](#output\_security\_hub\_event\_rule\_id) | SecurityHub EventBridge rule ID |
<!-- END_TF_DOCS -->