import json


def lambda_handler(event, context):
    """Simple handler; with async invoke + success destination, response is sent to SNS."""
    body = event if isinstance(event, dict) else {}
    a = int(body.get("a", 0))
    b = int(body.get("b", 0))
    result = {"sum": a + b, "message": "ok"}
    return {"statusCode": 200, "body": json.dumps(result)}
