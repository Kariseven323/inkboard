#!/usr/bin/env python3
import re
from pathlib import Path

EXCLUDE_PATTERNS = [
    re.compile(r"\.g\.dart$"),
    re.compile(r"^linux/flutter/generated_.*\.(?:cc|cmake)$"),
    re.compile(r"^macos/Flutter/GeneratedPluginRegistrant\.swift$"),
    re.compile(r"^windows/flutter/generated_.*\.(?:cc|cmake)$"),
    re.compile(r"^android/.*/GeneratedPluginRegistrant\.(?:java|kt)$"),
    re.compile(r"^ios/Runner/GeneratedPluginRegistrant\.[mh]$"),
]

def should_exclude(sf_path: str) -> bool:
    for pat in EXCLUDE_PATTERNS:
        if pat.search(sf_path):
            return True
    return False

def filter_lcov(src: Path, dst: Path) -> None:
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
            keep = not should_exclude(current_sf)
            if keep:
                block.append(line)
        else:
            if keep:
                block.append(line)
    flush()
    dst.parent.mkdir(parents=True, exist_ok=True)
    dst.write_text('\n'.join(out) + '\n', encoding='utf-8')

if __name__ == '__main__':
    src = Path('coverage/lcov.info')
    dst = Path('coverage/lcov.filtered.info')
    if not src.exists():
        raise SystemExit('coverage/lcov.info not found')
    filter_lcov(src, dst)
    print('Filtered LCOV written to', dst)

