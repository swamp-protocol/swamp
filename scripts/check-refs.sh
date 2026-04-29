#!/usr/bin/env python3
"""
check-refs.sh — verify that cross-document §N references carry titles.

Convention (see AGENTS.md): in every file in this repo OTHER than SPEC.md,
a reference to a SPEC section uses the form `§N.M Title` (e.g. `§4.6 Signature`)
rather than bare `§N.M`. The same titled-form convention extends to refs
to non-SPEC repo docs (e.g. `IMPLEMENTATION.md §1 generate a did:key`).
SPEC.md's own internal refs stay bare. Placeholder refs (`§7.x`, `§4.x`)
stay bare. The titled form makes stale references findable when section
numbers shift.

This script:
  1. Extracts the current section-title map from SPEC.md headings.
  2. Walks every cross-doc file (any *.md or *.sh outside SPEC.md).
  3. For each `§N(.M)*` reference, checks that what follows starts with
     the SPEC heading's first significant word (allowing shortened forms).
  4. For non-SPEC cross-doc refs (`SOMEDOC.md §N`), only checks that
     *some* title text follows — section titles in those files are not
     mapped, so we don't validate the title content.
  5. Flags bare refs and mismatches.

Usage:
  scripts/check-refs.sh [REPO_ROOT [SPEC_PATH]]

REPO_ROOT defaults to the parent of this script. SPEC_PATH defaults to
REPO_ROOT/SPEC.md. If you point this at swamp-frog or swamp-correspondence,
pass the swamp/ SPEC.md as the second arg.

Exits non-zero if any flag is raised.
"""

from __future__ import annotations

import os
import re
import sys
from pathlib import Path

HEADING_RE = re.compile(r"^#{2,4}\s+(\d+(?:\.\d+)*)\.?\s+(.+?)\s*$")
# §N or §N.M or §N.M.O, with optional space between § and digit.
# Followed by optional title text. Captures: (number, trailing).
REF_RE = re.compile(
    r"§\s*(\d+(?:\.\d+)*)([^a-zA-Z`(]?)"  # number, then a separator char
    r"(.{0,80})",                          # up to 80 chars of trailing text
)
# Placeholder forms like §7.x or §4.x — these are intentionally numberless
# and stay bare per the convention.
PLACEHOLDER_RE = re.compile(r"§\s*\d+\.x\b")


def build_map(spec_path: Path) -> dict[str, str]:
    out: dict[str, str] = {}
    for raw in spec_path.read_text(encoding="utf-8").splitlines():
        m = HEADING_RE.match(raw)
        if m:
            out[m.group(1)] = m.group(2)
    return out


def first_significant(title: str) -> str:
    """Return the first significant word/token of a SPEC title."""
    # Strip leading non-alpha-or-backtick.
    t = title.lstrip(" `(:.,")
    # Take up to first whitespace.
    word = re.split(r"\s", t, maxsplit=1)[0]
    # Strip trailing punctuation.
    word = word.rstrip(":,.;`)")
    return word


def shorten(title: str) -> str:
    """Drop content after first ':' or '(' for matching."""
    cut = re.split(r"[:(]", title, maxsplit=1)[0]
    return cut.strip()


def walk_files(root: Path):
    skip_dirs = {".git", "node_modules", "tmp", "out", "known"}
    for dirpath, dirnames, filenames in os.walk(root):
        dirnames[:] = [d for d in dirnames if d not in skip_dirs]
        for name in filenames:
            if name == "SPEC.md":
                continue
            if name.startswith("LICENSE"):
                continue
            if name.endswith((".md", ".sh", ".go")):
                yield Path(dirpath) / name


def check_file(path: Path, spec_map: dict[str, str], flags: list[str]) -> None:
    try:
        text = path.read_text(encoding="utf-8")
    except (UnicodeDecodeError, OSError):
        return

    # Match §N refs immediately preceded by a *.md filename (other than SPEC.md).
    # Those are cross-refs to non-SPEC docs.
    other_doc_ref = re.compile(
        r"\b(?!SPEC\.md\b)[A-Za-z][A-Za-z0-9_-]*\.md\s*§\s*\d+(?:\.\d+)*"
    )
    # Variant that also captures up to 40 trailing chars, so we can verify
    # the convention's titled form holds for non-SPEC cross-doc refs too.
    other_doc_ref_with_trailing = re.compile(
        r"\b(?!SPEC\.md\b)([A-Za-z][A-Za-z0-9_-]*\.md)\s*§\s*(\d+(?:\.\d+)*)(.{0,40})"
    )

    for lineno, line in enumerate(text.splitlines(), start=1):
        # Per-line opt-out: a line carrying `<!-- check-refs:skip -->` is
        # exempt from the title convention. Useful for dialogue files
        # whose refs point at sections that have since been renumbered or
        # removed — historical accuracy beats convention there.
        if "check-refs:skip" in line:
            continue
        # Skip placeholder refs entirely (they don't get titles).
        scan_line = PLACEHOLDER_RE.sub("", line)
        # Flag bare non-SPEC cross-doc refs before subbing them out.
        for m in other_doc_ref_with_trailing.finditer(scan_line):
            fname, num, trailing = m.group(1), m.group(2), m.group(3)
            window = trailing.lstrip(" `(:.,;")
            if not window or not re.match(r"[A-Za-z`]", window):
                flags.append(
                    f"{path}:{lineno}: bare §{num} on cross-doc ref to "
                    f"{fname} (convention: §N Title); "
                    f"line: {line.strip()[:120]}"
                )
        # Strip out refs that name a non-SPEC doc, so we don't try to match
        # them against SPEC headings.
        scan_line = other_doc_ref.sub("", scan_line)

        for match in REF_RE.finditer(scan_line):
            num = match.group(1)
            sep = match.group(2)
            trailing = match.group(3)

            if num not in spec_map:
                # Not a known SPEC section. Could be stale; flag it.
                flags.append(
                    f"{path}:{lineno}: §{num} not found in SPEC.md headings; "
                    f"line: {line.strip()[:120]}"
                )
                continue

            expected = spec_map[num]
            expected_short = shorten(expected)
            expected_first = first_significant(expected)

            # Build a "trailing window" that starts where the title would.
            # The matched separator is one non-alpha char (or empty).
            window = (sep + trailing).lstrip(" `(:.,")
            # Strip backticks for comparison.
            window_norm = window.replace("`", "").lstrip()
            expected_norm = expected_short.replace("`", "").strip()
            first_norm = expected_first.replace("`", "")

            if not window_norm:
                flags.append(
                    f"{path}:{lineno}: bare §{num} "
                    f"(expected '§{num} {expected_short}'); "
                    f"line: {line.strip()[:120]}"
                )
                continue

            # Acceptable if window starts with the expected first word
            # OR the full short title.
            if window_norm.startswith(first_norm) or window_norm.startswith(expected_norm):
                continue

            # Mismatch.
            flags.append(
                f"{path}:{lineno}: §{num} title mismatch "
                f"(saw '{window_norm[:40]}', expected '{expected_short}'); "
                f"line: {line.strip()[:120]}"
            )


def main() -> int:
    here = Path(__file__).resolve().parent
    repo_root = Path(sys.argv[1]).resolve() if len(sys.argv) > 1 else here.parent
    spec_path = (
        Path(sys.argv[2]).resolve() if len(sys.argv) > 2 else repo_root / "SPEC.md"
    )

    if not spec_path.is_file():
        print(f"check-refs: SPEC.md not found at {spec_path}", file=sys.stderr)
        print(
            "Pass the path to the swamp repo's SPEC.md as the second arg.",
            file=sys.stderr,
        )
        return 2

    spec_map = build_map(spec_path)
    if not spec_map:
        print(f"check-refs: extracted no headings from {spec_path}", file=sys.stderr)
        return 2

    flags: list[str] = []
    for f in walk_files(repo_root):
        check_file(f, spec_map, flags)

    if flags:
        for fl in flags:
            print(f"FLAG: {fl}")
        print()
        print(f"check-refs: {len(flags)} flag(s) raised.")
        return 1

    print("check-refs: OK")
    return 0


if __name__ == "__main__":
    sys.exit(main())
