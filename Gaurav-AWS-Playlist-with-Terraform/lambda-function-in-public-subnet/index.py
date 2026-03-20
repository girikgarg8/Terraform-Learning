# index.py
import json
import urllib.request

def lambda_handler(event, context):
    try:
        # Or: import requests; requests.get("https://httpbin.org/get", timeout=10)
        with urllib.request.urlopen("https://httpbin.org/get", timeout=10) as r:
            return {"statusCode": 200, "body": r.read().decode()[:500]}
    except Exception as e:
        return {"statusCode": 502, "body": json.dumps({"error": str(e)})}