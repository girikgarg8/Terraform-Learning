# Lambda ↔ RDS connectivity (minimal / faster apply)

Creates a **small single-AZ MySQL 8.0** instance (`db.t4g.micro`, 20 GiB `gp3`, **no backups**), a **minimal VPC** (one NAT, two private subnets for the RDS subnet group), and a **Lambda in private subnets** that proves connectivity with a **TCP socket** to port `3306` (no extra Python dependencies).

## Apply

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

**Timing:** NAT and RDS often take **several minutes**; RDS is usually the slowest step.

## Test

After apply, open the **Lambda function URL** from outputs (or `curl` it):

```bash
curl -s "$(terraform output -raw lambda_function_url)"
```

Expect JSON with `"ok": true` if security groups and routing are correct.

Get DB password (sensitive):

```bash
terraform output -raw db_master_password
```

## Function URL returns `403 Forbidden`

That response is from **Lambda (before your handler runs)** — usually **auth** or **account policy**.

1. **Confirm URL auth type is NONE** (IAM would require SigV4 signing):

   ```bash
   aws lambda get-function-url-config \
     --function-name "$(terraform output -raw lambda_function_name)" \
     --region "$(terraform output -raw region)"
   ```

   `AuthType` must be **`NONE`**.

2. **Confirm resource-based policy** includes `lambda:InvokeFunctionUrl` (and public invoke if you added it):

   ```bash
   aws lambda get-policy \
     --function-name "$(terraform output -raw lambda_function_name)" \
     --region "$(terraform output -raw region)"
   ```

3. **Account “Block public access” for Lambda** (if enabled, public Function URLs can be denied). Check **Lambda → Account-level settings** in the console and AWS docs for your region.

4. Re-apply after Terraform adds `depends_on` on the Function URL + permissions:

   ```bash
   terraform apply
   ```

## Notes

- **RDS** is **not** publicly accessible; only the Lambda security group can reach MySQL.
- **Function URL is public** — fine for learning; remove or add auth for anything real.
- **Destroy:** `skip_final_snapshot = true` so teardown is simple.
- To run **real SQL**, add a MySQL client library to the deployment package (e.g. `pymysql`) or use **RDS Proxy** + **IAM DB auth** in a follow-up.

## Requirements

- **ARM** instance class `db.t4g.micro` — if your account/region lacks capacity, change to `db.t3.micro` in `rds.tf`.
