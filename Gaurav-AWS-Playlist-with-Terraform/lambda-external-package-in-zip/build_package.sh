#!/usr/bin/env bash
# Build a Lambda deployment zip with lambda_function.py + pip dependencies (requests).
# Run from this directory before: terraform plan / apply
#
# Default: pip installs manylinux x86_64 wheels so the zip works on standard Lambda (x86_64).
# For ARM (Graviton) Lambda, set LAMBDA_ARCH=arm64 and adjust --platform to manylinux2014_aarch64.
#
# Alternative: Docker (always matches Lambda Amazon Linux):
#   docker run --rm -v "$(pwd)":/opt -w /opt public.ecr.aws/lambda/python:3.12 \
#     bash -lc "pip install -r requirements.txt -t lambda_bundle && cp lambda_src/lambda_function.py lambda_bundle/ && cd lambda_bundle && zip -r ../requests_in_zip.zip ."

set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

LAMBDA_ARCH="${LAMBDA_ARCH:-x86_64}"
if [[ "$LAMBDA_ARCH" == "arm64" ]]; then
  PIP_PLATFORM="manylinux2014_aarch64"
else
  PIP_PLATFORM="manylinux2014_x86_64"
fi

rm -rf lambda_bundle requests_in_zip.zip
mkdir -p lambda_bundle
cp lambda_src/lambda_function.py lambda_bundle/

# Linux-compatible wheels for AWS Lambda (avoid macOS/Windows .so in the zip)
python3 -m pip install -r requirements.txt -t lambda_bundle/ --upgrade \
  --platform "${PIP_PLATFORM}" \
  --implementation cp \
  --python-version 3.12 \
  --only-binary=:all:

(
  cd lambda_bundle
  zip -r ../requests_in_zip.zip . -x "*.pyc" -x "*__pycache__/*"
)

echo "Built $ROOT/requests_in_zip.zip ($(wc -c < requests_in_zip.zip) bytes) for Lambda ${LAMBDA_ARCH}"
