# Lambda + alias + provisioned concurrency (Terraform)

## Apply

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

## Provisioned concurrency and quotas

If `terraform apply` fails with:

`UnreservedConcurrentExecution below its minimum value of [10]`

your account’s **Lambda concurrent execution** limit is too low for provisioned (or reserved) concurrency on this function. Options:

1. **Leave defaults** — `provisioned_concurrency` defaults to `0` (no provisioned config); the function and `live` alias still deploy.
2. **Raise quota** — In AWS Console: **Service Quotas** → **AWS Lambda** → **Concurrent executions** → request increase (e.g. 100+), then set `provisioned_concurrency` in `terraform.tfvars` and re-apply.

## Optional `terraform.tfvars`

```hcl
region                   = "ap-south-1"
reserved_concurrency     = 0   # omit on Lambda when 0; set >0 only if quota allows
provisioned_concurrency  = 1   # enable after quota allows
```
