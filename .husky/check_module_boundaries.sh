#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="${1:-.}"
LIB_DIR="$ROOT_DIR/lib"
PACKAGE_NAME=""

ERROR_COUNT=0

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

fail() {
  local file="$1"
  local import_path="$2"
  local reason="$3"
  local suggestion="$4"

  ERROR_COUNT=$((ERROR_COUNT + 1))

  echo -e "${RED}Module boundary violation #$ERROR_COUNT${NC}"
  echo -e "  File:       ${BLUE}$file${NC}"
  echo -e "  Import:     ${YELLOW}$import_path${NC}"
  echo -e "  Reason:     $reason"
  echo -e "  Suggestion: $suggestion"
  echo
}

normalize_path() {
  # Remove ./, resolve simple path format without requiring target to exist.
  python3 - "$1" <<'PY'
import os
import sys
print(os.path.normpath(sys.argv[1]))
PY
}

is_generated_file() {
  local file="$1"

  [[ "$file" == *.g.dart ]] && return 0
  [[ "$file" == *.mocks.dart ]] && return 0
  [[ "$file" == *.freezed.dart ]] && return 0
  [[ "$file" == *.gen.dart ]] && return 0
  [[ "$file" == */generated/* ]] && return 0

  return 1
}

is_test_file() {
  local file="$1"
  [[ "$file" == "$ROOT_DIR/test/"* ]] && return 0
  [[ "$file" == test/* ]] && return 0
  return 1
}

read_package_name() {
  local pubspec="$ROOT_DIR/pubspec.yaml"

  if [[ ! -f "$pubspec" ]]; then
    echo ""
    return
  fi

  grep -E '^name:' "$pubspec" | head -n 1 | sed -E 's/^name:[[:space:]]*//'
}

to_lib_path_from_import() {
  local current_file="$1"
  local import_uri="$2"

  # package:first_demo/features/auth/index.dart
  if [[ "$import_uri" == package:"$PACKAGE_NAME"/* ]]; then
    local relative="${import_uri#package:$PACKAGE_NAME/}"
    echo "$LIB_DIR/$relative"
    return
  fi

  # relative import
  if [[ "$import_uri" != package:* ]] && [[ "$import_uri" != dart:* ]]; then
    local current_dir
    current_dir="$(dirname "$current_file")"
    normalize_path "$current_dir/$import_uri"
    return
  fi

  echo ""
}

is_module_dir() {
  local dir="$1"
  [[ -f "$dir/index.dart" ]]
}

find_nearest_module_dir() {
  local path="$1"

  if [[ -f "$path" ]]; then
    path="$(dirname "$path")"
  fi

  while [[ "$path" == "$LIB_DIR"* ]] || [[ "$path" == lib* ]]; do
    if is_module_dir "$path"; then
      echo "$path"
      return
    fi

    local parent
    parent="$(dirname "$path")"

    if [[ "$parent" == "$path" ]]; then
      break
    fi

    path="$parent"
  done

  echo ""
}

is_under_dir() {
  local path="$1"
  local dir="$2"

  [[ "$path" == "$dir" ]] && return 0
  [[ "$path" == "$dir/"* ]] && return 0

  return 1
}

relative_to_dir() {
  local path="$1"
  local dir="$2"

  if [[ "$path" == "$dir" ]]; then
    echo ""
  else
    echo "${path#$dir/}"
  fi
}

path_depth() {
  local path="$1"

  if [[ -z "$path" ]]; then
    echo 0
    return
  fi

  awk -F'/' '{print NF}' <<<"$path"
}

direct_child_module_of() {
  local parent_module="$1"
  local target_module="$2"

  is_under_dir "$target_module" "$parent_module" || return 1

  local rel
  rel="$(relative_to_dir "$target_module" "$parent_module")"

  [[ -z "$rel" ]] && return 1

  local depth
  depth="$(path_depth "$rel")"

  [[ "$depth" -eq 1 ]]
}

is_ancestor_module_of() {
  local ancestor="$1"
  local descendant="$2"

  [[ "$ancestor" == "$descendant" ]] && return 1
  is_under_dir "$descendant" "$ancestor"
}

is_direct_parent_module_of() {
  local parent="$1"
  local child="$2"

  direct_child_module_of "$parent" "$child"
}

import_lines_from_file() {
  local file="$1"

  # 支持：
  # import 'xxx';
  # import "xxx";
  # 不处理 export，当前只检查 import 依赖方向。
  grep -nE "^[[:space:]]*import[[:space:]]+['\"][^'\"]+['\"]" "$file" || true
}

extract_import_uri() {
  local line="$1"

  sed -E "s/^[^'\"]*['\"]([^'\"]+)['\"].*$/\1/" <<<"$line"
}

check_import() {
  local source_file="$1"
  local import_uri="$2"

  # 忽略 Dart SDK、第三方 package。
  if [[ "$import_uri" == dart:* ]]; then
    return
  fi

  if [[ "$import_uri" == package:* ]] && [[ "$import_uri" != package:"$PACKAGE_NAME"/* ]]; then
    return
  fi

  local target_file
  target_file="$(to_lib_path_from_import "$source_file" "$import_uri")"

  if [[ -z "$target_file" ]]; then
    return
  fi

  # 只检查 lib 下的目标文件。
  if [[ "$target_file" != "$LIB_DIR"/* ]]; then
    return
  fi

  # 目标文件不存在时不处理，让 analyzer 负责。
  if [[ ! -f "$target_file" ]]; then
    return
  fi

  if is_generated_file "$target_file"; then
    return
  fi

  local source_module
  local target_module

  source_module="$(find_nearest_module_dir "$source_file")"
  target_module="$(find_nearest_module_dir "$target_file")"

  # 目标不在任何模块内时，不检查（无边界可执行）。
  if [[ -z "$target_module" ]]; then
    return
  fi

  local target_is_index=false
  if [[ "$target_file" == "$target_module/index.dart" ]]; then
    target_is_index=true
  fi

  # 源文件不在任何模块内时，视为模块外部，只能访问目标模块的 index.dart。
  if [[ -z "$source_module" ]]; then
    if [[ "$target_is_index" == true ]]; then
      return
    fi

    local target_rel="${target_module#$LIB_DIR/}"
    fail \
      "$source_file" \
      "$import_uri" \
      "模块外部不能直接访问目标模块的内部文件。" \
      "请改为 import 'package:$PACKAGE_NAME/$target_rel/index.dart'，并在目标模块 index.dart 中显式 export 需要暴露的成员。"
    return
  fi

  # 规则 1：同一模块内部可以直接互相 import。
  if [[ "$source_module" == "$target_module" ]]; then
    return
  fi

  # 规则 2：模块访问直接子模块时，只能访问子模块 index.dart。
  if direct_child_module_of "$source_module" "$target_module"; then
    if [[ "$target_is_index" == true ]]; then
      return
    fi

    local target_rel="${target_module#$LIB_DIR/}"
    fail \
      "$source_file" \
      "$import_uri" \
      "父模块不能越过直接子模块的 index.dart 访问子模块内部文件。" \
      "请改为 import 'package:$PACKAGE_NAME/$target_rel/index.dart'，并在子模块 index.dart 中显式 export 需要暴露的成员。"
    return
  fi

  # 规则 3：模块不允许越级访问孙模块或更深层模块。
  if is_ancestor_module_of "$source_module" "$target_module"; then
    fail \
      "$source_file" \
      "$import_uri" \
      "模块不允许越级访问孙模块或更深层模块。" \
      "请先依赖直接子模块的 index.dart，再由直接子模块决定是否继续暴露下层能力。"
    return
  fi

  # 规则 4：模块可以访问任意祖先模块的 index.dart。
  if is_ancestor_module_of "$target_module" "$source_module"; then
    if [[ "$target_is_index" == true ]]; then
      return
    fi

    # 规则 5：允许访问直系父模块内部文件，protected 语义。
    if is_direct_parent_module_of "$target_module" "$source_module"; then
      return
    fi

    fail \
      "$source_file" \
      "$import_uri" \
      "模块不能直接访问非直系祖先模块的内部文件。" \
      "请改为 import 祖先模块的 index.dart，或将需要的能力通过直系父模块逐层暴露。"
    return
  fi

  # 规则 6：兄弟模块或其他外部模块，只能访问目标模块 index.dart。
  if [[ "$target_is_index" == true ]]; then
    return
  fi

  local target_rel="${target_module#$LIB_DIR/}"
  fail \
    "$source_file" \
    "$import_uri" \
    "模块外部不能直接访问目标模块的内部文件。" \
    "请改为 import 'package:$PACKAGE_NAME/$target_rel/index.dart'，并在目标模块 index.dart 中显式 export 需要暴露的成员。"
}

main() {
  if [[ ! -d "$LIB_DIR" ]]; then
    echo -e "${RED}Error:${NC} cannot find lib directory: $LIB_DIR"
    exit 1
  fi

  PACKAGE_NAME="$(read_package_name)"

  if [[ -z "$PACKAGE_NAME" ]]; then
    echo -e "${RED}Error:${NC} cannot read package name from pubspec.yaml"
    exit 1
  fi

  echo -e "${BLUE}Checking module boundaries...${NC}"
  echo "Root:    $ROOT_DIR"
  echo "Package: $PACKAGE_NAME"
  echo

  while IFS= read -r file; do
    if is_test_file "$file"; then
      continue
    fi

    if is_generated_file "$file"; then
      continue
    fi

    while IFS= read -r import_line; do
      local line_content
      line_content="${import_line#*:}"

      local import_uri
      import_uri="$(extract_import_uri "$line_content")"

      check_import "$file" "$import_uri"
    done < <(import_lines_from_file "$file")

  done < <(find "$LIB_DIR" -type f -name "*.dart" | sort)

  if [[ "$ERROR_COUNT" -gt 0 ]]; then
    echo -e "${RED}Module boundary check failed with $ERROR_COUNT violation(s).${NC}"
    exit 1
  fi

  echo -e "${GREEN}Module boundary check passed.${NC}"
}

main "$@"
