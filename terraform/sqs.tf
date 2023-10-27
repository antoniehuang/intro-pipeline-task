resource "aws_sqs_queue" "source_bucket_event_sqs_queue" {
  name = "intro-pipeline-task-queue-terraform"

  tags = {
    project_name = "Introductory Pipeline Task"
  }
}

resource "aws_sns_topic_subscription" "source_bucket_event_sns_to_sqs" {
  topic_arn            = aws_sns_topic.source_bucket_event_sns_topic.arn
  protocol             = "sqs"
  endpoint             = aws_sqs_queue.source_bucket_event_sqs_queue.arn
  raw_message_delivery = true
}

resource "aws_sqs_queue_policy" "default" {
  queue_url = aws_sqs_queue.source_bucket_event_sqs_queue.id

  policy = data.aws_iam_policy_document.sqs_queue_policy.json
}

data "aws_iam_policy_document" "sqs_queue_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }

    actions = [
      "sqs:SendMessage"
    ]

    resources = [
      aws_sqs_queue.source_bucket_event_sqs_queue.arn,
    ]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_sns_topic.source_bucket_event_sns_topic.arn]
    }

  }
}
