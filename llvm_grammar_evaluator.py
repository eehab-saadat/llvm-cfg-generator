import os
import argparse
import random
from typing import Dict, Set, Tuple, List, Optional

from llvm_cfg_generator import llvm_ir_to_context_free_grammar, ContextFreeGrammar


def grammar_to_rule_set(grammar: ContextFreeGrammar) -> Set[str]:
    """Convert a ContextFreeGrammar object to a set of unique rule strings."""
    return {f"{rule.lhs} -> {' '.join(rule.rhs)}" for rule in grammar.rules}


def aggregate_rule_sets(grammars: Dict[str, ContextFreeGrammar]) -> Set[str]:
    """Aggregate rule strings from a dict of grammars (across all functions)."""
    rule_set: Set[str] = set()
    for g in grammars.values():
        rule_set.update(grammar_to_rule_set(g))
    return rule_set


def compute_precision_recall_f1(predicted: Set[str], reference: Set[str]) -> Tuple[float, float, float]:
    """Compute precision, recall, and F1-score given two rule sets."""
    true_positive = len(predicted & reference)
    false_positive = len(predicted - reference)
    false_negative = len(reference - predicted)

    precision = true_positive / (true_positive + false_positive) if (true_positive + false_positive) else 0.0
    recall = true_positive / (true_positive + false_negative) if (true_positive + false_negative) else 0.0
    f1 = (2 * precision * recall / (precision + recall)) if (precision + recall) else 0.0
    return precision, recall, f1


# ---------------------------------------------------------------------------
# Simple random sampler for ContextFreeGrammar (producer role)
# ---------------------------------------------------------------------------

class GrammarSampler:
    """Generate random terminal sequences from a ContextFreeGrammar."""

    def __init__(self, grammar: ContextFreeGrammar, max_depth: int = 12):
        self.grammar = grammar
        self.max_depth = max_depth
        # Build mapping lhs -> list[rhs]
        self.rule_map: Dict[str, List[List[str]]] = {}
        for rule in grammar.rules:
            self.rule_map.setdefault(rule.lhs, []).append(rule.rhs)

    def sample(self) -> List[str]:
        return self._expand(self.grammar.start_symbol, depth=0)

    # ---------------------------------------------------------------------
    # Internal helpers
    # ---------------------------------------------------------------------

    def _expand(self, symbol: str, depth: int) -> List[str]:
        # Terminal symbol
        if symbol not in self.grammar.non_terminals or symbol == "EPSILON":
            return [] if symbol == "EPSILON" else [symbol]

        rules = self.rule_map.get(symbol, [])
        if not rules:
            return [symbol]  # unknown non-terminal -> treat as literal

        # If max depth reached, keep only rules that yield purely terminals
        if depth >= self.max_depth:
            terminal_rules = [rhs for rhs in rules if self._rhs_is_terminal(rhs)]
            if terminal_rules:
                rules = terminal_rules
        chosen_rhs = random.choice(rules)

        generated: List[str] = []
        for sym in chosen_rhs:
            generated.extend(self._expand(sym, depth + 1))
        return generated

    def _rhs_is_terminal(self, rhs: List[str]) -> bool:
        """Check if an RHS consists of only terminals (or EPSILON)."""
        return all(s not in self.grammar.non_terminals or s == "EPSILON" for s in rhs)


# ---------------------------------------------------------------------------
# Simple membership tester (acceptor role)
# ---------------------------------------------------------------------------

class GrammarAcceptor:
    """Naïve top-down parser with memoisation to decide membership of a token
    list in the language of a ContextFreeGrammar.  Works well for moderately
    sized samples and bounded recursion; returns True/False. *Not* suitable
    for very large inputs or highly ambiguous grammars but adequate for the
    evaluation sampling purpose (≤ few thousand short strings).
    """

    def __init__(self, grammar: ContextFreeGrammar, recursion_limit: int = 64):
        self.grammar = grammar
        self.recursion_limit = recursion_limit
        self.rule_map: Dict[str, List[List[str]]] = {}
        for rule in grammar.rules:
            self.rule_map.setdefault(rule.lhs, []).append(rule.rhs)
        # Memoisation cache: (symbol, pos) -> set(end positions)
        self._memo: Dict[Tuple[str, int], Set[int]] = {}

    # Public ----------------------------------------------------------------

    def accepts(self, tokens: List[str]) -> bool:
        self._memo.clear()
        end_positions = self._match_symbol(self.grammar.start_symbol, tokens, 0, depth=0)
        return len(tokens) in end_positions

    # Internal --------------------------------------------------------------

    def _match_symbol(self, symbol: str, tokens: List[str], pos: int, depth: int) -> Set[int]:
        # Depth guard
        if depth > self.recursion_limit:
            return set()

        key = (symbol, pos)
        if key in self._memo:
            return self._memo[key]

        result: Set[int] = set()

        # Terminal symbol
        if symbol not in self.grammar.non_terminals or symbol == "EPSILON":
            if symbol == "EPSILON":
                result.add(pos)
            elif pos < len(tokens) and tokens[pos] == symbol:
                result.add(pos + 1)
            # else: no match
            self._memo[key] = result
            return result

        # Non-terminal: try all rules
        for rhs in self.rule_map.get(symbol, []):
            positions: Set[int] = {pos}
            for part in rhs:
                next_positions: Set[int] = set()
                for p in positions:
                    next_positions.update(self._match_symbol(part, tokens, p, depth + 1))
                positions = next_positions
                if not positions:
                    break  # early exit – this rhs cannot work
            result.update(positions)

        self._memo[key] = result
        return result


# ---------------------------------------------------------------------------
# Sampling-based precision / recall evaluation
# ---------------------------------------------------------------------------

def evaluate_via_sampling(target_grammars: Dict[str, ContextFreeGrammar],
                           reference_grammars: Dict[str, ContextFreeGrammar],
                           samples: int = 1000,
                           max_depth: int = 12) -> Tuple[float, float, float]:
    """Compute (precision, recall, F1) using random sampling as discussed in
    https://rahul.gopinath.org/post/2021/01/28/grammar-inference/ ."""

    # Aggregate grammars by merging functions into a single big grammar each
    def merge_grammars(grammars: Dict[str, ContextFreeGrammar]) -> ContextFreeGrammar:
        merged = ContextFreeGrammar()
        # Keep start symbol of first function encountered
        first_start: Optional[str] = None
        for g in grammars.values():
            if first_start is None:
                first_start = g.start_symbol
            for rule in g.rules:
                merged.add_rule(rule.lhs, rule.rhs)
        if first_start:
            merged.start_symbol = first_start
        return merged

    tgt_grammar = merge_grammars(target_grammars)
    ref_grammar = merge_grammars(reference_grammars)

    tgt_sampler = GrammarSampler(tgt_grammar, max_depth=max_depth)
    ref_sampler = GrammarSampler(ref_grammar, max_depth=max_depth)

    tgt_acceptor = GrammarAcceptor(ref_grammar)
    ref_acceptor = GrammarAcceptor(tgt_grammar)

    # Precision: target as producer, reference as acceptor
    accepted_by_ref = 0
    for _ in range(samples):
        sentence = tgt_sampler.sample()
        if tgt_acceptor.accepts(sentence):
            accepted_by_ref += 1
    precision = accepted_by_ref / samples if samples else 0.0

    # Recall: reference as producer, target as acceptor
    accepted_by_tgt = 0
    for _ in range(samples):
        sentence = ref_sampler.sample()
        if ref_acceptor.accepts(sentence):
            accepted_by_tgt += 1
    recall = accepted_by_tgt / samples if samples else 0.0

    f1 = (2 * precision * recall / (precision + recall)) if (precision + recall) else 0.0
    return precision, recall, f1


# ---------------------------------------------------------------------------
# Top-level evaluation entry
# ---------------------------------------------------------------------------

def evaluate_llvm_grammars(target_path: str,
                           reference_path: str,
                           mode: str = "sample",
                           samples: int = 1000,
                           max_depth: int = 12) -> Tuple[float, float, float]:
    """Evaluate two LLVM-IR files and return precision/recall/F1.

    mode="sample" – sampling-based (default).  mode="rule" – quick rule-set comparison.
    """

    # Validate paths
    if not os.path.exists(target_path):
        raise FileNotFoundError(f"Target LLVM-IR file not found: {target_path}")
    if not os.path.exists(reference_path):
        raise FileNotFoundError(f"Reference LLVM-IR file not found: {reference_path}")

    with open(target_path, "r", encoding="utf-8") as f:
        tgt_ir = f.read()
    with open(reference_path, "r", encoding="utf-8") as f:
        ref_ir = f.read()

    tgt_grammars = llvm_ir_to_context_free_grammar(tgt_ir)
    ref_grammars = llvm_ir_to_context_free_grammar(ref_ir)

    if mode == "rule":
        tgt_rules = aggregate_rule_sets(tgt_grammars)
        ref_rules = aggregate_rule_sets(ref_grammars)
        return compute_precision_recall_f1(tgt_rules, ref_rules)
    elif mode == "sample":
        return evaluate_via_sampling(tgt_grammars, ref_grammars, samples=samples, max_depth=max_depth)
    else:
        raise ValueError("mode must be either 'rule' or 'sample'")


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Evaluate LLVM-IR derived grammars (precision, recall, F1). "
        "Supports fast rule-set comparison or realistic sampling-based metrics.")
    parser.add_argument("target", help="Path to the target LLVM-IR file")
    parser.add_argument("reference", help="Path to the reference (golden) LLVM-IR file")
    parser.add_argument("--mode", choices=["sample", "rule"], default="sample",
                        help="Evaluation strategy: 'sample' (default) or 'rule'.")
    parser.add_argument("--samples", type=int, default=1000,
                        help="Number of sentences to sample per grammar (sample mode)")
    parser.add_argument("--max-depth", type=int, default=12,
                        help="Maximum expansion depth for the sampler (sample mode)")

    args = parser.parse_args()

    precision, recall, f1 = evaluate_llvm_grammars(
        args.target,
        args.reference,
        mode=args.mode,
        samples=args.samples,
        max_depth=args.max_depth,
    )

    print("=== Grammar Evaluation Metrics ===")
    print(f"Target file    : {args.target}")
    print(f"Reference file : {args.reference}")
    print(f"Mode           : {args.mode}")
    if args.mode == "sample":
        print(f"Samples        : {args.samples}")
        print(f"Max depth      : {args.max_depth}")
    print("----------------------------------")
    print(f"Precision: {precision:.4f}")
    print(f"Recall   : {recall:.4f}")
    print(f"F1-Score : {f1:.4f}")

# -----------------------------  RULE-SET UTILS  ----------------------------- 