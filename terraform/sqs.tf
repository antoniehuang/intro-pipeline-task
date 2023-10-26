resource "aws_sqs_queue" "source_bucket_event_sqs_queue" {
  name = "intro-pipeline-task-queue-terraform"

  tags = {
    project_name = "Introductory Pipeline Task"
  }
}
