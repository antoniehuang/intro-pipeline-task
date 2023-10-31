resource "aws_iam_role" "pipeline_lambda_role" {
  name               = "intro-pipeline-task-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

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

data "aws_iam_policy_document" "lambda_logging" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"
  policy      = data.aws_iam_policy_document.lambda_logging.json
}

data "aws_iam_policy_document" "lambda_sqs_read_policy" {
  statement {
    effect = "Allow"

    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes"
    ]

    resources = [aws_sqs_queue.source_bucket_event_sqs_queue.arn]
  }
}

resource "aws_iam_policy" "lambda_sqs_read_policy" {
  name        = "lambda_sqs_read_policy"
  path        = "/"
  description = "IAM policy for lambda to read from sqs"
  policy      = data.aws_iam_policy_document.lambda_sqs_read_policy.json
}

data "aws_iam_policy_document" "lambda_bucket_read_write_policy" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]

    resources = ["${aws_s3_bucket.source_bucket.arn}/*", "${aws_s3_bucket.datalake_bucket.arn}/*"]
  }
}

resource "aws_iam_policy" "lambda_bucket_read_write_policy" {
  name        = "lambda_bucket_read_write_policy"
  path        = "/"
  description = "IAM policy for lambda to read and write to s3"
  policy      = data.aws_iam_policy_document.lambda_bucket_read_write_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda_policies_attachment" {
  role = aws_iam_role.pipeline_lambda_role.name

  for_each = toset([
    aws_iam_policy.lambda_logging.arn,
    aws_iam_policy.lambda_sqs_read_policy.arn,
    aws_iam_policy.lambda_bucket_read_write_policy.arn
  ])

  policy_arn = each.value
}

# Snowflake Access
data "aws_iam_policy_document" "snowflake_s3_access_policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion"
    ]
    resources = ["${aws_s3_bucket.datalake_bucket.arn}/*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]
    resources = ["${aws_s3_bucket.datalake_bucket.arn}"]
  }
}

resource "aws_iam_policy" "snowflake_s3_access_policy" {
  name        = "snowflake_s3_access_policy"
  path        = "/"
  description = "IAM policy for snowflake to read from s3"
  policy      = data.aws_iam_policy_document.snowflake_s3_access_policy.json
}

resource "aws_iam_role" "snowflake_role" {
  name               = "intro-pipeline-task-snowflake-role"
  assume_role_policy = data.aws_iam_policy_document.snowflake_assume_role.json
}

data "aws_iam_policy_document" "snowflake_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy_attachment" "snowflake_role_policy_attachment" {
  role       = aws_iam_role.snowflake_role.name
  policy_arn = aws_iam_policy.snowflake_s3_access_policy.arn
}