#!/usr/bin/env bash
# Build a Lambda layer zip: dependencies under python/ (required by AWS for Python layers).
# Run before: terraform plan / apply
#
# Default: manylinux x86_64 wheels for standard Lambda. For arm64: LAMBDA_ARCH=arm64 ./build_layer.sh

set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

LAMBDA_ARCH="${LAMBDA_ARCH:-x86_64}"
if [[ "$LAMBDA_ARCH" == "arm64" ]]; then
  PIP_PLATFORM="manylinux2014_aarch64"
else
  PIP_PLATFORM="manylinux2014_x86_64"
fi

rm -rf layer_build requests_layer.zip
mkdir -p layer_build/python

python3 -m pip install -r requirements.txt -t layer_build/python/ --upgrade \
  --platform "${PIP_PLATFORM}" \
  --implementation cp \
  --python-version 3.12 \
  --only-binary=:all:

(
  cd layer_build
  zip -r ../requests_layer.zip python -x "*.pyc" -x "*__pycache__/*"
)

echo "Built $ROOT/requests_layer.zip ($(wc -c < requests_layer.zip) bytes) for Lambda ${LAMBDA_ARCH}"
