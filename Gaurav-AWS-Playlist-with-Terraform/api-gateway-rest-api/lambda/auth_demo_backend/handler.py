import json


def handler(event, context):
    ctx = (event.get("requestContext") or {}).get("authorizer") or {}
    print(f"authorizer context: {json.dumps(ctx)}")

    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(
            {
                "message": "auth-demo",
                "userid_from_context": ctx.get("userid"),
            }
        ),
    }
