已统一：
1) scripts/coverage.sh 现在支持 --filter-only，并统一阈值变量优先级：COVERAGE_THRESHOLD > MIN_COVERAGE > 90；输出 Unfiltered 与 Filtered 覆盖率，再按过滤后覆盖率判定失败。
2) .github/workflows/flutter_ci.yml 的阈值检查步会同时打印未过滤与过滤后覆盖率，再用过滤后覆盖率与 COVERAGE_THRESHOLD 比较。