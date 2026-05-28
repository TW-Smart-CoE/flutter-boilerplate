#!/usr/bin/env bash

PROJECT_DIR="$(git rev-parse --show-toplevel)"

# Unit tests + Coverage check
bash "$PROJECT_DIR/scripts/check-coverage.sh"
if [ $? -ne 0 ]; then
  exit 1
fi

