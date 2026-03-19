import json
import time

cold_start_time = None

def lambda_handler(event, context):
    global cold_start_time

    if cold_start_time is None:
        time.sleep(3)
        cold_start_time = time.time()
        start_type = "cold start"
    else:
        start_type = "hot start"
    
    current_time = time.time()

    method = event.get("requestContext", {}).get("http", {}).get("method")
    if method != "POST" :
        return {
            "statusCode": 403,
            "body": json.dumps({"error": "Only POST allowed"})
        }

    body = event.get("body") or "{}"

    if isinstance(body, str):
        body = json.loads(body)
    a = body.get("a", 0)
    b = body.get("b", 0)
    total = a + b

    name = __import__("os").environ.get("name", "")
    
    return {
        "statusCode": 200,
        "body": json.dumps({
            "sum": total,
            "current_time": current_time,
            "start_type": start_type,
            "cold_start_time": cold_start_time,
            "env_name": name,
            "context": {
                "function_name": context.function_name,
                "request_id": context.aws_request_id,
            }
        })
    } 