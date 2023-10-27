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

resource "aws_lambda_event_source_mapping" "sqs_lambda_trigger" {
  event_source_arn = aws_sqs_queue.source_bucket_event_sqs_queue.arn
  function_name    = aws_lambda_function.pipeline_lambda.arn
  batch_size       = 1
}

resource "aws_cloudwatch_log_group" "pipeline_lambda_cloudwatch_group" {
  name              = "/aws/lambda/${aws_lambda_function.pipeline_lambda.function_name}"
  retention_in_days = 14
}
