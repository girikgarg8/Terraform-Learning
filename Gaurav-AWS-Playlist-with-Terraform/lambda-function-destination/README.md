# Lambda async success destination → existing SNS topic

This stack creates a Lambda and configures **asynchronous invocation** so **successful** invokes send a record to an **existing** SNS topic named `mysampletopic` (override with `sns_topic_name`).

## Prerequisites

- SNS topic `mysampletopic` must already exist in the chosen region.

## Test (must use **Event** = async invocation)

**AWS CLI v2.22+** treats `--payload` as base64 by default, so **raw JSON must use** `--cli-binary-format raw-in-base64-out` (otherwise you get `InvalidRequestContentException` / JSON parse errors):

```bash
aws lambda invoke \
  --function-name "$(terraform output -raw function_name)" \
  --invocation-type Event \
  --cli-binary-format raw-in-base64-out \
  --payload '{"a":2,"b":3}' \
  /tmp/out.json
```

Alternative: `printf '%s' '{"a":2,"b":3}' >/tmp/payload.json` and use `--payload file:///tmp/payload.json` with the same `--cli-binary-format raw-in-base64-out`.

Synchronous `RequestResponse` invokes do **not** use this destination. Check your SNS topic for JSON messages with the invocation / response payload.

## Apply

```bash
terraform init && terraform validate && terraform plan && terraform apply
```
