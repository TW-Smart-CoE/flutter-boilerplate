#!/usr/bin/env bash

# ============================================================
# Unit Test Coverage Check
# - Runs tests with coverage enabled
# - Parses lcov.info to calculate line coverage percentage
# - Fails if coverage is below the defined threshold
# ============================================================

COVERAGE_THRESHOLD=20  # Minimum coverage percentage required (increase as tests grow)

printf "\e[33;1m%s\e[0m\n" "=== Running Tests with Coverage ==="
flutter test --coverage --no-test-assets
if [ $? -ne 0 ]; then
  printf "\e[31;1m%s\e[0m\n" "=== Tests failed ==="
  exit 1
fi
printf "\e[33;1m%s\e[0m\n" "Finished running tests"
printf '%s\n' ""

# Check if lcov.info was generated
LCOV_FILE="coverage/lcov.info"
if [ ! -f "$LCOV_FILE" ]; then
  printf "\e[31;1m%s\e[0m\n" "Error: $LCOV_FILE not found"
  exit 1
fi

# Filter out generated files (*.g.dart, generated/)
FILTERED_LCOV="coverage/lcov_filtered.info"
lcov_available=false
if command -v lcov &> /dev/null; then
  lcov_available=true
fi

if [ "$lcov_available" = true ]; then
  lcov --remove "$LCOV_FILE" \
    '**/*.g.dart' \
    '**/generated/*' \
    '**/model/*' \
    '**/model_*.dart' \
    'lib/res/*' \
    'lib/dev_menu/*' \
    -o "$FILTERED_LCOV" \
    --quiet
  LCOV_FILE="$FILTERED_LCOV"
  printf "\e[33;1m%s\e[0m\n" "Filtered generated files and res/ from coverage report"
else
  # Manual filtering without lcov: remove res/ and *.g.dart entries
  FILTERED_LCOV="coverage/lcov_filtered.info"
  awk '
    /^SF:/ {
      skip = 0
      if ($0 ~ /\/res\// || $0 ~ /\.g\.dart$/ || $0 ~ /\/generated\//) skip = 1
    }
    !skip { print }
  ' "$LCOV_FILE" > "$FILTERED_LCOV"
  LCOV_FILE="$FILTERED_LCOV"
  printf "\e[33;1m%s\e[0m\n" "Filtered generated files and res/ from coverage report (without lcov)"
fi

# Parse lcov.info to calculate coverage
TOTAL_LINES=0
HIT_LINES=0

while IFS= read -r line; do
  if [[ "$line" == LF:* ]]; then
    TOTAL_LINES=$((TOTAL_LINES + ${line#LF:}))
  elif [[ "$line" == LH:* ]]; then
    HIT_LINES=$((HIT_LINES + ${line#LH:}))
  fi
done < "$LCOV_FILE"

if [ "$TOTAL_LINES" -eq 0 ]; then
  printf "\e[31;1m%s\e[0m\n" "Error: No lines found in coverage report"
  exit 1
fi

COVERAGE=$(awk "BEGIN { printf \"%.2f\", ($HIT_LINES / $TOTAL_LINES) * 100 }")

printf '%s\n' "----------------------------------------"
printf "  Lines:   %s / %s\n" "$HIT_LINES" "$TOTAL_LINES"
printf "  Coverage: \e[1m%s%%\e[0m\n" "$COVERAGE"
printf "  Threshold: %s%%\n" "$COVERAGE_THRESHOLD"
printf '%s\n' "----------------------------------------"

# Compare coverage with threshold
PASS=$(awk "BEGIN { print ($COVERAGE >= $COVERAGE_THRESHOLD) ? 1 : 0 }")
if [ "$PASS" -eq 1 ]; then
  printf "\e[32;1m%s\e[0m\n" "✅ Coverage check passed!"
else
  printf "\e[31;1m%s\e[0m\n" "❌ Coverage ($COVERAGE%) is below threshold ($COVERAGE_THRESHOLD%)"
  exit 1
fi

# Generate HTML report if lcov and genhtml are available
if [ "$lcov_available" = true ] && command -v genhtml &> /dev/null; then
  genhtml "$LCOV_FILE" -o coverage/html --quiet
  printf "\e[33;1m%s\e[0m\n" "HTML report generated at coverage/html/index.html"
fi
