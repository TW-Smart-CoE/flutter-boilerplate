#!/usr/bin/env bash

set -euo pipefail

COVERAGE_THRESHOLD=20  # Minimum coverage percentage required (increase as tests grow)
EXCLUDE_PATTERNS=(
  '**/*.g.dart'
  '**/generated/*'
  '**/model/*'
  '**/model_*.dart'
  'lib/res/*'
  'lib/dev_menu/*'
)

LCOV_FILE="coverage/lcov.info"
FILTERED_LCOV="coverage/lcov_filtered.info"

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BOLD='\033[1m'
NC='\033[0m'

has_command() {
  command -v "$1" &> /dev/null
}

run_tests() {
  echo -e "${YELLOW}=== Running Tests with Coverage ===${NC}"

  if ! flutter test --coverage --no-test-assets; then
    echo -e "${RED}=== Tests failed ===${NC}"
    exit 1
  fi

  echo -e "${YELLOW}Finished running tests${NC}"
  echo

  if [[ ! -f "$LCOV_FILE" ]]; then
    echo -e "${RED}Error:${NC} $LCOV_FILE not found"
    exit 1
  fi
}

filter_coverage() {
  if has_command lcov; then
    lcov --remove "$LCOV_FILE" \
      "${EXCLUDE_PATTERNS[@]}" \
      -o "$FILTERED_LCOV" \
      --quiet
    echo -e "${YELLOW}Filtered generated files and res/ from coverage report${NC}"
  else
    local awk_conditions=""
    for pattern in "${EXCLUDE_PATTERNS[@]}"; do
      local regex="${pattern//\*\*/.*}"
      regex="${regex//\*/[^/]*}"
      regex="${regex//./\\.}"
      [[ -n "$awk_conditions" ]] && awk_conditions="$awk_conditions || "
      awk_conditions+="\$0 ~ /$regex/"
    done

    awk "
      /^SF:/ {
        skip = 0
        if ($awk_conditions) skip = 1
      }
      !skip { print }
    " "$LCOV_FILE" > "$FILTERED_LCOV"
    echo -e "${YELLOW}Filtered generated files and res/ from coverage report (without lcov)${NC}"
  fi

  LCOV_FILE="$FILTERED_LCOV"
}

calculate_coverage() {
  local total_lines=0
  local hit_lines=0

  while IFS= read -r line; do
    if [[ "$line" == LF:* ]]; then
      total_lines=$((total_lines + ${line#LF:}))
    elif [[ "$line" == LH:* ]]; then
      hit_lines=$((hit_lines + ${line#LH:}))
    fi
  done < "$LCOV_FILE"

  if [[ "$total_lines" -eq 0 ]]; then
    echo -e "${RED}Error:${NC} No lines found in coverage report"
    exit 1
  fi

  local coverage
  coverage=$(awk "BEGIN { printf \"%.2f\", ($hit_lines / $total_lines) * 100 }")

  echo "----------------------------------------"
  echo "  Lines:     $hit_lines / $total_lines"
  echo -e "  Coverage:  ${BOLD}${coverage}%${NC}"
  echo "  Threshold: ${COVERAGE_THRESHOLD}%"
  echo "----------------------------------------"

  local pass
  pass=$(awk "BEGIN { print ($coverage >= $COVERAGE_THRESHOLD) ? 1 : 0 }")

  if [[ "$pass" -eq 1 ]]; then
    echo -e "${GREEN}✅ Coverage check passed!${NC}"
  else
    echo -e "${RED}❌ Coverage ($coverage%) is below threshold ($COVERAGE_THRESHOLD%)${NC}"
    exit 1
  fi
}

generate_html_report() {
  if has_command lcov && has_command genhtml; then
    genhtml "$LCOV_FILE" -o coverage/html --quiet
    echo -e "${YELLOW}HTML report generated at coverage/html/index.html${NC}"
  fi
}

main() {
  run_tests
  filter_coverage
  calculate_coverage
  generate_html_report
}

main
