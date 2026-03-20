import json
import time


def lambda_handler(event, context):
    time.sleep(2)
    return {
        "statusCode": 200,
        "body": json.dumps(
            {
                "message": "Reserved concurrency demo",
                "request_id": context.aws_request_id,
            }
        ),
    }
