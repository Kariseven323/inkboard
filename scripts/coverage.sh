#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
EXCLUDE_FILE="$ROOT_DIR/coverage_exclude.lst"
LCOV="$ROOT_DIR/coverage/lcov.info"
FILTERED="$ROOT_DIR/coverage/lcov.filtered.info"

usage() {
  cat <<USAGE
Usage: $(basename "$0") [--filter-only]

Options:
  --filter-only    仅对现有 coverage/lcov.info 执行过滤与阈值校验，不运行测试。

环境变量：
  ALLOW_TEST_FAILURES   默认 1。为 1 时忽略测试失败，仅用于关注覆盖率。
  COVERAGE_THRESHOLD    覆盖率门槛（%）。若未设置，则回退 MIN_COVERAGE 或 90。
  MIN_COVERAGE          兼容旧变量名，若 COVERAGE_THRESHOLD 未设置则使用此值；默认 90。
USAGE
}

FILTER_ONLY=0
if [[ "${1:-}" == "--filter-only" ]]; then
  FILTER_ONLY=1
fi

if [[ "$FILTER_ONLY" == "0" ]]; then
  echo "[coverage] Running flutter tests with coverage..."
  : "${ALLOW_TEST_FAILURES:=1}"
  if [[ "$ALLOW_TEST_FAILURES" == "1" ]]; then
    flutter test --coverage || true
  else
    flutter test --coverage
  fi
else
  echo "[coverage] Filter-only mode: skip running tests"
fi

if [[ ! -f "$LCOV" ]]; then
  echo "[coverage] ERROR: $LCOV not found. Did tests run?" >&2
  exit 1
fi

echo "[coverage] Filtering LCOV via Python script (includes built-in platform/generated excludes)"
python3 "$ROOT_DIR/scripts/filter_lcov.py"

calc() {
  awk 'BEGIN{LF=0;LH=0} /^LF:/ {LF+=substr($0,4)} /^LH:/ {LH+=substr($0,4)} END{ if (LF==0) {print 0} else {printf "%.2f", (LH/LF)*100 } }' "$1"
}

TOTAL=$(calc "$LCOV")
FILTERED_PCT=$(calc "$FILTERED")

echo "[coverage] Unfiltered: ${TOTAL}%"
echo "[coverage] Filtered:   ${FILTERED_PCT}%"

# 覆盖率阈值检查（默认 90%）；兼容 CI 的 COVERAGE_THRESHOLD
MIN_COVERAGE="${COVERAGE_THRESHOLD:-${MIN_COVERAGE:-90}}"
awk -v pct="$FILTERED_PCT" -v min="$MIN_COVERAGE" 'BEGIN{ if (pct+0 < min+0) { exit 1 } }' || {
  echo "[coverage] ERROR: Filtered coverage ${FILTERED_PCT}% is below threshold ${MIN_COVERAGE}%" >&2
  exit 1
}
echo "[coverage] OK: Filtered coverage >= ${MIN_COVERAGE}%"
