import json


def lambda_handler(event, context):
    """Handle S3 object created events."""
    records = event.get("Records", [])
    for record in records:
        s3 = record.get("s3", {})
        bucket = s3.get("bucket", {}).get("name")
        key = s3.get("object", {}).get("key")
        # Log or process the new object
        print(f"S3 trigger: bucket={bucket}, key={key}")
    return {"statusCode": 200, "body": json.dumps({"processed": len(records)})}
