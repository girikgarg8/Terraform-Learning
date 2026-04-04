import json


def handler(event, context):
    """Non-proxy event: fields come from API Gateway VTL (rawBody, size)."""
    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(
            {
                "rawBody": event.get("rawBody"),
                "size": event.get("size"),
            }
        ),
    }
