resource "aws_s3_bucket" "source_bucket" {
  bucket = "intro-pipeline-task-source-terraform"

  tags = {
    project_name = "Introductory Pipeline Task"
  }
}

resource "aws_s3_bucket" "datalake_bucket" {
  bucket = "intro-pipeline-task-datalake-terraform"

  tags = {
    project_name = "Introductory Pipeline Task"
  }
}
