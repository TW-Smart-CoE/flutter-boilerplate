#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Unit tests + Coverage check
bash "$SCRIPT_DIR/check-coverage.sh"
if [ $? -ne 0 ]; then
  exit 1
fi

