import json
import urllib.request


def lambda_handler(event, context):
    try:
        with urllib.request.urlopen("https://httpbin.org/get", timeout=10) as response:
            return {"statusCode": 200, "body": response.read().decode()[:500]}
    except Exception as error:
        return {"statusCode": 502, "body": json.dumps({"error": str(error)})}
