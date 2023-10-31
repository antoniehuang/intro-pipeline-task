resource "aws_sns_topic" "source_bucket_event_sns_topic" {
  name = "intro-pipeline-task-topic-terraform"

  tags = {
    project_name = "Introductory Pipeline Task"
  }
}

resource "aws_sns_topic" "datalake_bucket_event_sns_topic" {
  name = "intro-pipeline-task-datalake-topic-terraform"

  tags = {
    project_name = "Introductory Pipeline Task"
  }
}

resource "aws_sns_topic_policy" "default" {
  arn = aws_sns_topic.source_bucket_event_sns_topic.arn

  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

resource "aws_sns_topic_policy" "datalake_sns_policy" {
  arn = aws_sns_topic.datalake_bucket_event_sns_topic.arn

  policy = data.aws_iam_policy_document.sns_topic_policy.json
}


data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions = [
      "SNS:Publish"
    ]

    resources = [
      aws_sns_topic.source_bucket_event_sns_topic.arn,
      aws_sns_topic.datalake_bucket_event_sns_topic.arn
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = ["114888082308"]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [aws_s3_bucket.source_bucket.arn, aws_s3_bucket.datalake_bucket.arn]
    }

  }
}
