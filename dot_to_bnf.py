#!/usr/bin/env python3
"""
Dot-to-BNF Grammar Inference Tool
================================
This script walks a directory tree, loads every Graphviz .dot file it finds and
extracts *string literals* (text surrounded by double quotes) that appear inside
node labels.  These literals are treated as **terminal symbols** and are used to
create naïve Backus–Naur Form (BNF) production rules.

The inference heuristic is intentionally simple so that it can operate on any
collection of control-flow graphs:

1.  Each input DOT file corresponds to *one* non-terminal. Its name (without the
    ".dot" extension) is used as the **left-hand side** (LHS) of the rule.
2.  Every distinct string literal found in the file becomes a terminal on the
    **right-hand side** (RHS) of that rule, laid out in a deterministic order.
3.  If desired, the script can produce additional helper rules that alias long
    string literals to shorter symbolic names for readability.

Because real grammar inference is an undecidable problem, this tool focuses on
providing a *starting point* that you can later refine by hand.

Usage
-----
```
python dot_to_bnf.py /path/to/dot/folder [-o OUTPUT] [--alias]
```

Arguments
~~~~~~~~~
* **path**         Root directory to search for ``*.dot`` files.
* ``-o / --output``  Optional output file.  If omitted, the grammar is printed
                     to *stdout*.
* ``--alias``        Generate extra alias rules that map long terminal strings
                     to symbolic names like ``<T1>``, ``<T2>``, …

Dependencies
------------
``pydot`` is required for parsing Graphviz DOT files. Install via:
```
pip install pydot
```
"""
from __future__ import annotations

import argparse
import os
import re
import sys
from pathlib import Path
from typing import Dict, List, Sequence

try:
    import pydot  # type: ignore
except ImportError as exc:
    sys.exit(
        "[ERROR] pydot is not installed. Install it with `pip install pydot` and try again."  # noqa: E501
    )

# ----------------------------------------------------------------------------
# Helper functions
# ----------------------------------------------------------------------------
_STRING_LITERAL_RE = re.compile(r"\"(.*?)\"")


def extract_literals(dot_file: Path) -> List[str]:
    """Return a list of *unique* string literals found in node labels of *dot_file*.

    The order is stable (first occurrence wins).
    """
    literals: List[str] = []
    seen = set()

    graphs = pydot.graph_from_dot_file(str(dot_file))
    if not graphs:
        return literals

    # ``graph_from_dot_file`` can return multiple graphs (rare). Iterate all.
    for graph in graphs:
        for node in graph.get_nodes():
            # The Graphviz parser sometimes returns a single empty node representing
            # the graph itself; skip those.
            attrs = node.get_attributes() or {}
            label = attrs.get("label")
            if not label:
                continue

            for match in _STRING_LITERAL_RE.finditer(label):
                literal = match.group(1)
                if literal not in seen:
                    seen.add(literal)
                    literals.append(literal)
    return literals


# ----------------------------------------------------------------------------
# Grammar building
# ----------------------------------------------------------------------------

def build_rules(dot_files: Sequence[Path]) -> Dict[str, List[str]]:
    """Map *rule name* → *ordered list of terminal literals*."""
    rules: Dict[str, List[str]] = {}
    for file in dot_files:
        lhs = file.stem  # filename without extension
        rhs = extract_literals(file)
        if rhs:
            rules[lhs] = rhs
    return rules


def generate_aliases(rules: Dict[str, List[str]]) -> Dict[str, str]:
    """Return mapping *terminal literal* → *alias name* (e.g., <T1>)."""
    aliases: Dict[str, str] = {}
    counter = 1
    for rhs in rules.values():
        for lit in rhs:
            if lit not in aliases:
                aliases[lit] = f"<T{counter}>"
                counter += 1
    return aliases


# ----------------------------------------------------------------------------
# Rendering
# ----------------------------------------------------------------------------

def render_bnf(rules: Dict[str, List[str]], *, alias: bool = False) -> str:
    """Convert *rules* to a BNF-formatted string."""
    lines: List[str] = []

    if alias:
        alias_map = generate_aliases(rules)
        # Alias definitions first
        for lit, name in alias_map.items():
            lines.append(f"{name} ::= \"{lit}\"")
        lines.append("")  # blank line
    else:
        alias_map = {}

    for lhs, rhs in sorted(rules.items()):
        if not rhs:
            continue  # skip empty productions
        mapped_rhs = [alias_map.get(token, f'"{token}"') for token in rhs]
        production = " ".join(mapped_rhs)
        lines.append(f"<{lhs}> ::= {production}")
    return "\n".join(lines)


# ----------------------------------------------------------------------------
# CLI entry point
# ----------------------------------------------------------------------------

def main(argv: Sequence[str] | None = None) -> None:  # noqa: D401
    """Command-line interface."""
    parser = argparse.ArgumentParser(
        description="Infer a naïve BNF grammar from Graphviz .dot control-flow graphs.",
    )
    parser.add_argument("path", help="Root directory containing .dot files")
    parser.add_argument(
        "-o",
        "--output",
        help="Write grammar to this file instead of stdout",
    )
    parser.add_argument(
        "--alias",
        action="store_true",
        help="Replace long literals with symbolic aliases (<T1>, <T2>, …) for readability",
    )

    args = parser.parse_args(argv)

    root = Path(args.path)
    if not root.exists():
        sys.exit(f"[ERROR] Path not found: {root}")

    dot_files = sorted(root.rglob("*.dot"))
    if not dot_files:
        sys.exit("[ERROR] No .dot files were found under the specified path.")

    rules = build_rules(dot_files)
    if not rules:
        sys.exit("[ERROR] No string literals discovered; cannot create grammar.")

    grammar = render_bnf(rules, alias=args.alias)

    if args.output:
        Path(args.output).write_text(grammar, encoding="utf-8")
        print(f"[OK] Grammar written to {args.output}")
    else:
        print(grammar)


if __name__ == "__main__":
    main() 