import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def lambda_handler(event, context):
    body = json.loads(event["Records"][0]["body"])
    logger.info("SQS Message Body: %s", body)

    source_bucket_name = body["Records"][0]["s3"]["bucket"]["name"]
    logger.info("Source Bucket's Name: %s", source_bucket_name)

    key = body["Records"][0]["s3"]["object"]["key"]
    logger.info("Object's Key: %s", key)

    return {
        "statusCode": 200,
        "body": json.dumps("Hello from Lambda!"),
    }
