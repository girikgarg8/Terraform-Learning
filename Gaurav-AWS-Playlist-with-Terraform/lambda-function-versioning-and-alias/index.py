import json
import os

BUILD_TAG = os.environ.get("BUILD_TAG", "v1")


def lambda_handler(event, context):
    # Function URL expects statusCode + body (and optional headers)
    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(
            {
                "build_tag": BUILD_TAG,
                "resolved_function_version": context.function_version,
            }
        ),
    }
