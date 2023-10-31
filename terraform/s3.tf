resource "aws_s3_bucket" "source_bucket" {
  bucket = "intro-pipeline-task-source-terraform"

  tags = {
    project_name = "Introductory Pipeline Task"
  }
}

resource "aws_s3_bucket_notification" "source_bucket_notification" {
  bucket = aws_s3_bucket.source_bucket.id

  topic {
    topic_arn = aws_sns_topic.source_bucket_event_sns_topic.arn
    events    = ["s3:ObjectCreated:*"]
  }
}

resource "aws_s3_bucket" "datalake_bucket" {
  bucket = "intro-pipeline-task-datalake-terraform"

  tags = {
    project_name = "Introductory Pipeline Task"
  }
}

resource "aws_s3_bucket_notification" "datalake_bucket_notification" {
  bucket = aws_s3_bucket.datalake_bucket.id

  topic {
    topic_arn = aws_sns_topic.datalake_bucket_event_sns_topic.arn
    events    = ["s3:ObjectCreated:*"]
  }
}
