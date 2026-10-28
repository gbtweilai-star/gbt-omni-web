#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
PYTHONPATH=src python -m gbt_omni_web info
PYTHONPATH=src python -m gbt_omni_web check --payload '{"op": "path"}'
PYTHONPATH=src python -m gbt_omni_web run   --payload '{"op": "path"}'
