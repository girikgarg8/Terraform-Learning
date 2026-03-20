# Lambda versions, aliases, and function URLs

- **`publish = true`** — each code change creates a new numeric version (1, 2, 3, …).
- **`test` alias** — either tracks **latest** only, or **splits traffic** between two published versions (see below).
- **`prod` alias** — pinned with `var.prod_alias_version`.

Two function URLs (HTTP), one per alias.

## Create v2 (Terraform)

1. **First `terraform apply`** — publishes **version 1** (and aliases/URLs).
2. Change **`build_tag`** and/or **`index.py`**, then **`terraform apply` again** — Lambda publishes **version 2**.  
   `prod` can stay on `"1"` until you promote.

## 50/50 traffic on `test` (v1 + v2) in Terraform

After **v1** and **v2** both exist:

In **`terraform.tfvars`** (or CLI `-var`):

```hcl
test_traffic_split_enabled      = true
test_traffic_primary_version    = "1"
test_traffic_secondary_version = "2"
test_traffic_secondary_weight   = 0.5   # 50% to v2, 50% to v1
```

Then **`terraform apply`**.

- With split **on**, `test` no longer auto-follows latest; it uses the two version numbers you set.
- Turn split **off** again with `test_traffic_split_enabled = false` to go back to “test = latest only”.

## Promote prod

Set `prod_alias_version = "2"` (or whatever) and apply.
