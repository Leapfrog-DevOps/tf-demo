# modules/shield/main.tf
resource "aws_shield_protection" "protection" {
  name         = "${var.stage}-shield"
  resource_arn = var.resource_arn

  tags = {
    Environment = var.stage
    Managed_By  = "Terraform"
  }
}

# CloudWatch Alarms
resource "aws_cloudwatch_metric_alarm" "ddos_alarm" {
  alarm_name          = "${var.stage}-ddos-detection"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "DDoSDetected"
  namespace           = "AWS/DDoSProtection"
  period              = "300"
  statistic           = "Sum"
  threshold           = "0"
  alarm_description   = "DDoS attack detected"
  alarm_actions       = [aws_sns_topic.ddos_alerts.arn]
}

resource "aws_sns_topic" "ddos_alerts" {
  name = "${var.stage}-ddos-alerts"

  tags = {
    Environment = var.stage
    Managed_By  = "Terraform"
  }
}

resource "aws_sns_topic_policy" "default" {
  arn = aws_sns_topic.ddos_alerts.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudwatch.amazonaws.com"
        }
        Action   = "SNS:Publish"
        Resource = aws_sns_topic.ddos_alerts.arn
      }
    ]
  })
}

