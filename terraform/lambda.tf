data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "../lambda/lambda_function.py"
  output_path = "lambda_function_payload.zip"
}

resource "aws_lambda_function" "pipeline_lambda" {
  function_name = "intro-pipeline-task-lambda-terraform"
  description   = "A Lambda for copying files from source s3 to datalake"
  filename      = "lambda_function_payload.zip"
  role          = aws_iam_role.pipeline_lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.11"

  tags = {
    project_name = "Introductory Pipeline Task"
  }
}
