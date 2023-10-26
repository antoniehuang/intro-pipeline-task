data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "pipeline_lambda_role" {
  name               = "intro-pipeline-task-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}
