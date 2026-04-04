import json


def _header(headers, name):
    """API Gateway proxy events usually lowercase header keys; clients may send mixed case."""
    if not headers:
        return None
    lowered = {k.lower(): v for k, v in headers.items()}
    return lowered.get(name.lower())


def handler(event, context):
    pid = (event.get("pathParameters") or {}).get("id")
    qs = event.get("queryStringParameters") or {}
    is_test = _header(event.get("headers"), "x-isTest")

    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(
            {
                "id": pid,
                "page": qs.get("page"),
                "size": qs.get("size"),
                "isTest": is_test,
            }
        ),
    }
