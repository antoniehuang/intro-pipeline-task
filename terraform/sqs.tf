resource "aws_sqs_queue" "terraform_queue" {
  name = "intro-pipeline-task-queue-terraform"

  tags = {
    project_name = "Introductory Pipeline Task"
  }
}
