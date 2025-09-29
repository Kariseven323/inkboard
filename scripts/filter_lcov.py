#!/usr/bin/env python3
import os
import re
from pathlib import Path


def _builtin_exclude_patterns():
    return [
        re.compile(r"\.g\.dart$"),
        re.compile(r"^linux/flutter/generated_.*\.(?:cc|cmake)$"),
        re.compile(r"^macos/Flutter/GeneratedPluginRegistrant\.swift$"),
        re.compile(r"^windows/flutter/generated_.*\.(?:cc|cmake)$"),
        re.compile(r"^android/.*/GeneratedPluginRegistrant\.(?:java|kt)$"),
        re.compile(r"^ios/Runner/GeneratedPluginRegistrant\.[mh]$"),
    ]


def _load_excludes_from_list(file: Path):
    patterns = []
    if not file.exists():
        return patterns
    for raw in file.read_text(encoding="utf-8").splitlines():
        line = raw.strip()
        if not line or line.startswith("#"):
            continue
        try:
            patterns.append(re.compile(line))
        except re.error:
            # 忽略无效正则，尽量不阻断 CI
            pass
    return patterns


def _collect_exclude_patterns(root: Path):
    patterns = []
    patterns.extend(_builtin_exclude_patterns())
    patterns.extend(_load_excludes_from_list(root / "coverage_exclude.lst"))
    return patterns

def should_exclude(sf_path: str, patterns) -> bool:
    for pat in patterns:
        if pat.search(sf_path):
            return True
    return False

def filter_lcov(src: Path, dst: Path, patterns) -> None:
    lines = src.read_text(encoding='utf-8').splitlines()
    out = []
    keep = True
    current_sf = None
    block = []
    def flush():
        if block:
            out.extend(block)
            block.clear()
    for line in lines:
        if line.startswith('SF:'):
            # flush previous block
            flush()
            current_sf = line[3:]
            keep = not should_exclude(current_sf, patterns)
            if keep:
                block.append(line)
        else:
            if keep:
                block.append(line)
    flush()
    dst.parent.mkdir(parents=True, exist_ok=True)
    dst.write_text('\n'.join(out) + '\n', encoding='utf-8')

if __name__ == '__main__':
    root = Path(os.getcwd())
    src = Path('coverage/lcov.info')
    dst = Path('coverage/lcov.filtered.info')
    if not src.exists():
        raise SystemExit('coverage/lcov.info not found')
    patterns = _collect_exclude_patterns(root)
    filter_lcov(src, dst, patterns)
    print('Filtered LCOV written to', dst, f"(patterns={len(patterns)})")
