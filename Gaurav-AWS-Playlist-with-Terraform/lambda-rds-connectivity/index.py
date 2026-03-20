"""
Lab probe: opens a TCP connection to RDS (no MySQL driver — proves network + security groups).
"""
import json
import os
import socket


def lambda_handler(event, context):
    host = os.environ.get("DB_HOST", "")
    port = int(os.environ.get("DB_PORT", "3306"))
    if not host:
        return {"statusCode": 500, "body": json.dumps({"error": "DB_HOST not set"})}

    try:
        with socket.create_connection((host, port), timeout=10) as sock:
            peer = sock.getpeername()
        return {
            "statusCode": 200,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps(
                {
                    "ok": True,
                    "message": "TCP connection to RDS succeeded",
                    "host": host,
                    "port": port,
                    "peer": {"addr": peer[0], "port": peer[1]},
                }
            ),
        }
    except OSError as e:
        return {
            "statusCode": 502,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"ok": False, "error": str(e), "host": host, "port": port}),
        }
