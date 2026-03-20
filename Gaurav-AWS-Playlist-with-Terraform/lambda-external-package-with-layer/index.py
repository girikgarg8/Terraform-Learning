"""
Function code only — `requests` is supplied by the Lambda layer (see build_layer.sh).
"""

import json

import requests


def lambda_handler(event, context):
    try:
        resp = requests.get("https://httpbin.org/get", params={"via": "layer"}, timeout=10)
        resp.raise_for_status()
        data = resp.json()
        return {
            "statusCode": 200,
            "body": json.dumps(
                {
                    "message": "requests from layer OK",
                    "httpbin_args": data.get("args"),
                }
            ),
        }
    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)}),
        }
