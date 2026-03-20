"""
Demo Lambda using the `requests` library bundled in the deployment zip.

Pre-build: run ./build_package.sh from this folder so lambda_bundle/ exists.
"""

import json

import requests


def lambda_handler(event, context):
    try:
        # Public HTTP endpoint – no auth required (demo only)
        resp = requests.get("https://httpbin.org/get", params={"source": "lambda"}, timeout=10)
        resp.raise_for_status()
        data = resp.json()
        return {
            "statusCode": 200,
            "body": json.dumps(
                {
                    "message": "requests OK",
                    "httpbin_args": data.get("args"),
                    "url": data.get("url"),
                }
            ),
        }
    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)}),
        }
