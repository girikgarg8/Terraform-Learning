# Lambda with `requests` in a **Lambda layer**

Function deployment package contains only **`index.py`**. **`requests`** (and deps) live in a **layer** built as `requests_layer.zip` with the required **`python/`** layout.

## 1. Build the layer zip

```bash
chmod +x build_layer.sh
./build_layer.sh
```

- Default: **manylinux x86_64** wheels for **x86_64** Lambda.
- **Graviton:** `LAMBDA_ARCH=arm64 ./build_layer.sh`

## 2. Deploy

```bash
terraform init
terraform apply
```

## 3. Test

Invoke **`requests-layer-demo`**; response should include `"requests from layer OK"` and httpbin args.
