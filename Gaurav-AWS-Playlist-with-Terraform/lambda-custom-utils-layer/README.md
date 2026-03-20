# Custom Python utils in a Lambda layer

- **`layer_content/python/myutils/`** — your shared module (packaged under `python/` as AWS requires for Python layers).
- **`index.py`** — function code only; **`from myutils import ...`** resolves via the layer.

No separate build step: Terraform **`archive_file`** zips `layer_content/` (so the zip contains `python/myutils/...`) and zips `index.py` for the function.

```bash
terraform init && terraform apply
```

Invoke **`custom-layer-demo`**; the response includes **`greeting`** from **`greet()`** and **`sum`** from **`add()`** in the layer.
