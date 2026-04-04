import json


def _policy(effect, resource_arn):
    return {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Action": "execute-api:Invoke",
                "Effect": effect,
                "Resource": resource_arn,
            }
        ],
    }


def handler(event, context):
    # TOKEN authorizer: identity_source maps header -> this string (no "Bearer " unless client sends it).
    token = (event.get("authorizationToken") or "").strip()
    method_arn = event.get("methodArn") or "*"

    if token == "valid":
        return {
            "principalId": "girik",
            "policyDocument": _policy("Allow", method_arn),
            "context": {"userid": "girik"},
        }

    return {
        "principalId": "anonymous",
        "policyDocument": _policy("Deny", method_arn),
    }
