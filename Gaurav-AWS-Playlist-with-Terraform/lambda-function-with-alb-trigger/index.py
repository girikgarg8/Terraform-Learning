import json


def lambda_handler(event, context):
    """
    ALB Lambda target integration expects this response shape.
    See: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/lambda-functions.html
    """
    return {
        "statusCode": 200,
        "statusDescription": "200 OK",
        "isBase64Encoded": False,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps({"message": "Hello from Lambda behind ALB"}),
    }
