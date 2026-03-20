import json

from myutils import add, greet


def lambda_handler(event, context):
    return {
        "statusCode": 200,
        "body": json.dumps(
            {
                "greeting": greet("Lambda"),
                "sum": add(40, 2),
            }
        ),
    }
