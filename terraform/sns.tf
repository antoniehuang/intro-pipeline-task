resource "aws_sns_topic" "source_bucket_event_sns_topic" {
  name = "intro-pipeline-task-topic-terraform"

  tags = {
    project_name = "Introductory Pipeline Task"
  }
}
