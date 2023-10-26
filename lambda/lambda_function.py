import json
import logging
import boto3

logger = logging.getLogger()
logger.setLevel(logging.INFO)

s3 = boto3.resource("s3")


def lambda_handler(event, context):
    body = json.loads(event["Records"][0]["body"])
    logger.info("SQS Message Body: %s", body)

    source_bucket_name = body["Records"][0]["s3"]["bucket"]["name"]
    logger.info("Source Bucket's Name: %s", source_bucket_name)

    key = body["Records"][0]["s3"]["object"]["key"]
    logger.info("Object's Key: %s", key)

    copy_source = {"Bucket": source_bucket_name, "Key": key}

    target_bucket_name = "intro-pipeline-task-datalake"

    response = s3.meta.client.copy(copy_source, target_bucket_name, key)
    logger.info("S3 Client response: %s", response)

    return {
        "statusCode": 200,
        "body": json.dumps("Hello from Lambda!"),
    }
