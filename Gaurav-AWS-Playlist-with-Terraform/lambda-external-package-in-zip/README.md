# Lambda with `requests` bundled in the deployment zip

AWS Lambda does not include third-party packages. This example vendors **`requests`** (and its dependencies) into **`requests_in_zip.zip`** and deploys that zip.

## Build the zip (required before Terraform)

From this directory:

```bash
chmod +x build_package.sh
./build_package.sh
```

This creates `lambda_bundle/` (ignored by git) and `requests_in_zip.zip`.

- By default the script installs **manylinux x86_64** wheels so the zip runs on **standard (x86_64) Lambda**. For **Graviton (arm64)** functions, run `LAMBDA_ARCH=arm64 ./build_package.sh`.
- You can also use the **Docker** one-liner in `build_package.sh` for an Amazon Linux build environment.

## Deploy

```bash
terraform init
terraform apply
```

## Test

Invoke the function in the console or with AWS CLI; the handler calls `https://httpbin.org/get` using `requests`.
