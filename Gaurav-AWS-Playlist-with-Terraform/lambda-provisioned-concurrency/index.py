import json
import time


def lambda_handler(event, context):
    time.sleep(1)
    return {
        "statusCode": 200,
        "body": json.dumps(
            {
                "message": "provisioned concurrency demo",
                "version": context.function_version,
                "request_id": context.aws_request_id,
            }
        ),
    }
