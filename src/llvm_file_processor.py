"""
LLVM-IR File Processor with Analytics

This module provides high-level functions to process LLVM-IR files and generate 
comprehensive analytics about the resulting context-free grammars for fuzzing optimization.
"""

import os
from typing import Dict, List, Tuple, Optional
from dataclasses import dataclass
from llvm_cfg_generator import llvm_ir_to_context_free_grammar, ContextFreeGrammar

@dataclass
class GrammarAnalytics:
    """
    Post-processing data structure that distills *quantitative* properties from
    a freshly generated :pyclass:`llvm_cfg_generator.ContextFreeGrammar`.

    The collected metrics fall into four broad categories:

    1. **Structural** – number of rules, branching factor, derivation depth.
    2. **Control-flow** – basic blocks, choice points, loop patterns.
    3. **Fuzzing-oriented** – path alternatives, optional/repetition rules.
    4. **Coverage / Semantics** – instruction types and high-level flow
       patterns present in the grammar.

    A higher-level orchestrator (CLI, notebook, GUI) can serialise instances of
    this dataclass into human-readable reports or feed them into downstream
    optimisation heuristics that decide which functions are *worth* fuzzing.
    """
    
    # Basic Grammar Metrics
    function_name: str
    total_rules: int
    non_terminals_count: int
    terminals_count: int
    start_symbol: str
    
    # Control Flow Metrics
    basic_blocks_count: int
    choice_points_count: int
    loop_patterns_count: int
    instruction_sequences_count: int
    
    # Fuzzing Optimization Metrics
    path_alternatives_count: int
    optional_execution_rules: int
    repetition_patterns: int
    interleaving_rules: int
    merge_points: int
    
    # Complexity Metrics
    max_rule_length: int
    avg_rule_length: float
    branching_factor: float
    depth_estimation: int
    
    # Coverage Metrics
    instruction_types_covered: List[str]
    control_flow_patterns: List[str]
    fuzzing_readiness_score: float
    
    def __str__(self) -> str:
        return f"""
Grammar Analytics for {self.function_name}:
========================================

Basic Metrics:
- Production Rules: {self.total_rules}
- Non-terminals: {self.non_terminals_count}
- Terminals: {self.terminals_count}
- Start Symbol: {self.start_symbol}

Control Flow Coverage:
- Basic Blocks: {self.basic_blocks_count}
- Choice Points: {self.choice_points_count}
- Loop Patterns: {self.loop_patterns_count}
- Instruction Sequences: {self.instruction_sequences_count}

Fuzzing Optimization:
- Path Alternatives: {self.path_alternatives_count}
- Optional Executions: {self.optional_execution_rules}
- Repetition Patterns: {self.repetition_patterns}
- Interleaving Rules: {self.interleaving_rules}
- Merge Points: {self.merge_points}

Complexity Analysis:
- Max Rule Length: {self.max_rule_length}
- Avg Rule Length: {self.avg_rule_length:.2f}
- Branching Factor: {self.branching_factor:.2f}
- Estimated Depth: {self.depth_estimation}

Coverage Details:
- Instruction Types: {len(self.instruction_types_covered)} ({', '.join(self.instruction_types_covered[:5])}{'...' if len(self.instruction_types_covered) > 5 else ''})
- Control Flow Patterns: {', '.join(self.control_flow_patterns)}
- Fuzzing Readiness Score: {self.fuzzing_readiness_score:.2f}/10.0

"""

@dataclass
class FileProcessingResult:
    """
    Container returned by :pyfunc:`LLVMFileProcessor.process_file` and the
    helper wrappers such as :pyfunc:`process_llvm_file`.

    It captures both **high-level status** (success flag, aggregated metrics)
    and the **detailed artefacts** (per-function grammars + analytics).

    Having a single object makes it easier to forward data between batch
    processing helpers and report generators without having to juggle several
    loosely-coupled variables.
    """
    
    file_path: str
    success: bool
    error_message: Optional[str]
    grammars: Dict[str, ContextFreeGrammar]
    analytics: Dict[str, GrammarAnalytics]
    
    # File-level metrics
    functions_processed: int
    total_grammar_rules: int
    total_choice_points: int
    total_loop_patterns: int
    overall_fuzzing_score: float
    
    def __str__(self) -> str:
        if not self.success:
            return f"❌ Failed to process {self.file_path}: {self.error_message}"
        
        result = f"""
✅ Successfully processed: {self.file_path}
=============================================

File Summary:
- Functions Processed: {self.functions_processed}
- Total Grammar Rules: {self.total_grammar_rules}
- Total Choice Points: {self.total_choice_points}
- Total Loop Patterns: {self.total_loop_patterns}
- Overall Fuzzing Score: {self.overall_fuzzing_score:.2f}/10.0

Function Details:
"""
        
        for func_name, analytics in self.analytics.items():
            result += f"\n📊 {func_name}:"
            result += f"\n   Rules: {analytics.total_rules} | Choice Points: {analytics.choice_points_count} | Score: {analytics.fuzzing_readiness_score:.1f}/10"
        
        return result

class LLVMFileProcessor:
    """
    Facade that orchestrates *reading*, *parsing*, *grammar generation*, and
    *analytics* for **one** LLVM-IR file at a time.

    The class deliberately hides all the gritty details so that command-line
    interfaces and GUIs can perform complex processing with a single method
    call.
    """
    
    def __init__(self):
        self.supported_extensions = ['.ll', '.bc', '.txt']
    
    def process_file(self, file_path: str) -> FileProcessingResult:
        """
        Process an LLVM-IR file and generate comprehensive analytics.
        
        Args:
            file_path: Path to the LLVM-IR file
            
        Returns:
            FileProcessingResult with grammars and detailed analytics
        """
        
        # Validate file path
        if not os.path.exists(file_path):
            return FileProcessingResult(
                file_path=file_path,
                success=False,
                error_message=f"File not found: {file_path}",
                grammars={},
                analytics={},
                functions_processed=0,
                total_grammar_rules=0,
                total_choice_points=0,
                total_loop_patterns=0,
                overall_fuzzing_score=0.0
            )
        
        # Check file extension
        _, ext = os.path.splitext(file_path)
        if ext not in self.supported_extensions:
            return FileProcessingResult(
                file_path=file_path,
                success=False,
                error_message=f"Unsupported file extension: {ext}. Supported: {', '.join(self.supported_extensions)}",
                grammars={},
                analytics={},
                functions_processed=0,
                total_grammar_rules=0,
                total_choice_points=0,
                total_loop_patterns=0,
                overall_fuzzing_score=0.0
            )
        
        try:
            # Read LLVM-IR content
            with open(file_path, 'r', encoding='utf-8') as f:
                llvm_ir_content = f.read()
            
            # Generate grammars
            grammars = llvm_ir_to_context_free_grammar(llvm_ir_content)
            
            if not grammars:
                return FileProcessingResult(
                    file_path=file_path,
                    success=False,
                    error_message="No functions found in LLVM-IR file",
                    grammars={},
                    analytics={},
                    functions_processed=0,
                    total_grammar_rules=0,
                    total_choice_points=0,
                    total_loop_patterns=0,
                    overall_fuzzing_score=0.0
                )
            
            # Generate analytics for each grammar
            analytics = {}
            total_rules = 0
            total_choice_points = 0
            total_loop_patterns = 0
            total_score = 0.0
            
            for func_name, grammar in grammars.items():
                func_analytics = self._analyze_grammar(func_name, grammar)
                analytics[func_name] = func_analytics
                
                total_rules += func_analytics.total_rules
                total_choice_points += func_analytics.choice_points_count
                total_loop_patterns += func_analytics.loop_patterns_count
                total_score += func_analytics.fuzzing_readiness_score
            
            overall_score = total_score / len(grammars) if grammars else 0.0
            
            return FileProcessingResult(
                file_path=file_path,
                success=True,
                error_message=None,
                grammars=grammars,
                analytics=analytics,
                functions_processed=len(grammars),
                total_grammar_rules=total_rules,
                total_choice_points=total_choice_points,
                total_loop_patterns=total_loop_patterns,
                overall_fuzzing_score=overall_score
            )
            
        except Exception as e:
            return FileProcessingResult(
                file_path=file_path,
                success=False,
                error_message=f"Error processing file: {str(e)}",
                grammars={},
                analytics={},
                functions_processed=0,
                total_grammar_rules=0,
                total_choice_points=0,
                total_loop_patterns=0,
                overall_fuzzing_score=0.0
            )
    
    def _analyze_grammar(self, func_name: str, grammar: ContextFreeGrammar) -> GrammarAnalytics:
        """Generate comprehensive analytics for a context-free grammar"""
        
        # Basic metrics
        total_rules = len(grammar.rules)
        non_terminals_count = len(grammar.non_terminals)
        terminals_count = len(grammar.terminals)
        
        # Control flow metrics
        basic_blocks = [nt for nt in grammar.non_terminals if nt.startswith('BLOCK_')]
        choice_rules = [r for r in grammar.rules if 'CHOICE_POINT' in str(r)]
        loop_rules = [r for r in grammar.rules if 'LOOP_' in str(r)]
        instruction_rules = [r for r in grammar.rules if 'INSTRUCTION_SEQ' in str(r)]
        
        # Fuzzing optimization metrics
        optional_rules = [r for r in grammar.rules if 'OPT_' in str(r)]
        repetition_rules = [r for r in grammar.rules if 'REPEAT_' in str(r)]
        interleaving_rules = [r for r in grammar.rules if 'INTERLEAVE_' in str(r)]
        merge_rules = [r for r in grammar.rules if 'MERGE_' in str(r)]
        
        # Calculate path alternatives
        path_alternatives = len(choice_rules) + len(optional_rules) + len(repetition_rules)
        
        # Complexity metrics
        rule_lengths = [len(rule.rhs) for rule in grammar.rules]
        max_rule_length = max(rule_lengths) if rule_lengths else 0
        avg_rule_length = sum(rule_lengths) / len(rule_lengths) if rule_lengths else 0
        
        # Calculate branching factor
        branching_factor = self._calculate_branching_factor(grammar)
        
        # Estimate grammar depth
        depth_estimation = self._estimate_grammar_depth(grammar)
        
        # Identify instruction types and patterns
        instruction_types = self._extract_instruction_types(grammar)
        control_flow_patterns = self._identify_control_flow_patterns(grammar)
        
        # Calculate fuzzing readiness score
        fuzzing_score = self._calculate_fuzzing_score(
            choice_rules, loop_rules, optional_rules, 
            repetition_rules, interleaving_rules, basic_blocks
        )
        
        return GrammarAnalytics(
            function_name=func_name,
            total_rules=total_rules,
            non_terminals_count=non_terminals_count,
            terminals_count=terminals_count,
            start_symbol=grammar.start_symbol,
            basic_blocks_count=len(basic_blocks),
            choice_points_count=len(choice_rules),
            loop_patterns_count=len(loop_rules),
            instruction_sequences_count=len(instruction_rules),
            path_alternatives_count=path_alternatives,
            optional_execution_rules=len(optional_rules),
            repetition_patterns=len(repetition_rules),
            interleaving_rules=len(interleaving_rules),
            merge_points=len(merge_rules),
            max_rule_length=max_rule_length,
            avg_rule_length=avg_rule_length,
            branching_factor=branching_factor,
            depth_estimation=depth_estimation,
            instruction_types_covered=instruction_types,
            control_flow_patterns=control_flow_patterns,
            fuzzing_readiness_score=fuzzing_score
        )
    
    def _calculate_branching_factor(self, grammar: ContextFreeGrammar) -> float:
        """Calculate the average branching factor of the grammar"""
        nt_alternatives = {}
        
        for rule in grammar.rules:
            if rule.lhs not in nt_alternatives:
                nt_alternatives[rule.lhs] = 0
            nt_alternatives[rule.lhs] += 1
        
        if not nt_alternatives:
            return 0.0
        
        return sum(nt_alternatives.values()) / len(nt_alternatives)
    
    def _estimate_grammar_depth(self, grammar: ContextFreeGrammar) -> int:
        """Estimate the maximum derivation depth of the grammar"""
        dependencies = {}
        
        for rule in grammar.rules:
            dependencies[rule.lhs] = [symbol for symbol in rule.rhs if symbol in grammar.non_terminals]
        
        def max_depth(symbol, visited=None):
            if visited is None:
                visited = set()
            if symbol in visited or symbol not in dependencies:
                return 0
            
            visited.add(symbol)
            max_child_depth = 0
            
            for child in dependencies[symbol]:
                max_child_depth = max(max_child_depth, max_depth(child, visited.copy()))
            
            return 1 + max_child_depth
        
        return max_depth(grammar.start_symbol)
    
    def _extract_instruction_types(self, grammar: ContextFreeGrammar) -> List[str]:
        """Extract the types of instructions covered by the grammar"""
        instruction_types = set()
        
        for terminal in grammar.terminals:
            if terminal in ['ADD', 'SUB', 'MUL', 'DIV', 'LOAD', 'STORE', 'BRANCH', 
                          'ICMP', 'FCMP', 'ALLOCA', 'PHI', 'CALL', 'RETURN']:
                instruction_types.add(terminal)
        
        return sorted(list(instruction_types))
    
    def _identify_control_flow_patterns(self, grammar: ContextFreeGrammar) -> List[str]:
        """Identify control flow patterns present in the grammar"""
        patterns = []
        
        rule_strings = [str(rule) for rule in grammar.rules]
        
        if any('CHOICE_POINT' in rule_str for rule_str in rule_strings):
            patterns.append('Conditional Branching')
        
        if any('LOOP_' in rule_str for rule_str in rule_strings):
            patterns.append('Iterative Loops')
        
        if any('INSTRUCTION_SEQ' in rule_str for rule_str in rule_strings):
            patterns.append('Sequential Execution')
        
        if any('MERGE_' in rule_str for rule_str in rule_strings):
            patterns.append('Control Flow Convergence')
        
        if any('INTERLEAVE_' in rule_str for rule_str in rule_strings):
            patterns.append('Complex Flow Interleaving')
        
        return patterns
    
    def _calculate_fuzzing_score(self, choice_rules, loop_rules, optional_rules, 
                                repetition_rules, interleaving_rules, basic_blocks) -> float:
        """
        Calculate a fuzzing readiness score (0-10) based on grammar characteristics.
        
        Higher scores indicate better suitability for fuzzing applications.
        """
        score = 0.0
        
        # Choice points are critical for fuzzing (0-3 points)
        choice_score = min(3.0, len(choice_rules) * 0.5)
        score += choice_score
        
        # Loop patterns enable iterative testing (0-2 points)
        loop_score = min(2.0, len(loop_rules) * 0.3)
        score += loop_score
        
        # Path alternatives provide fuzzing flexibility (0-2 points)
        alternatives_score = min(2.0, (len(optional_rules) + len(repetition_rules)) * 0.2)
        score += alternatives_score
        
        # Basic block coverage indicates completeness (0-2 points)
        block_score = min(2.0, len(basic_blocks) * 0.2)
        score += block_score
        
        # Complex flow patterns add fuzzing value (0-1 point)
        complexity_score = min(1.0, len(interleaving_rules) * 0.1)
        score += complexity_score
        
        return round(score, 2)

def process_llvm_file(file_path: str) -> FileProcessingResult:
    """Thin wrapper around :pyclass:`LLVMFileProcessor` for one-off calls.

    This helper exists mostly for backwards compatibility and quick REPL
    experimentation.
    """
    processor = LLVMFileProcessor()
    return processor.process_file(file_path)

def process_multiple_files(file_paths: List[str]) -> Dict[str, FileProcessingResult]:
    """Apply :pyfunc:`process_llvm_file` to every path in *file_paths*.

    The function collects the individual :pyclass:`FileProcessingResult`
    objects in a dictionary so that callers can inspect successes and failures
    side-by-side.
    """
    processor = LLVMFileProcessor()
    results = {}
    
    for file_path in file_paths:
        results[file_path] = processor.process_file(file_path)
    
    return results

def generate_batch_report(results: Dict[str, FileProcessingResult]) -> str:
    """Human-readable summary for a whole *batch* of processed files.

    The returned string is already formatted for terminal output and therefore
    does **not** require additional pretty-printing.
    """
    successful_files = [r for r in results.values() if r.success]
    failed_files = [r for r in results.values() if not r.success]
    
    if not results:
        return "No files processed."
    
    report = f"""
Batch Processing Report
======================

Summary:
- Total Files: {len(results)}
- Successful: {len(successful_files)}
- Failed: {len(failed_files)}

"""
    
    if successful_files:
        total_functions = sum(r.functions_processed for r in successful_files)
        total_rules = sum(r.total_grammar_rules for r in successful_files)
        total_choice_points = sum(r.total_choice_points for r in successful_files)
        avg_score = sum(r.overall_fuzzing_score for r in successful_files) / len(successful_files)
        
        report += f"""
Aggregate Statistics:
- Functions Processed: {total_functions}
- Grammar Rules Generated: {total_rules}
- Total Choice Points: {total_choice_points}
- Average Fuzzing Score: {avg_score:.2f}/10.0

Successful Files:
"""
        for result in successful_files:
            report += f"  ✅ {result.file_path} ({result.functions_processed} functions, score: {result.overall_fuzzing_score:.1f})\n"
    
    if failed_files:
        report += f"\nFailed Files:\n"
        for result in failed_files:
            report += f"  ❌ {result.file_path}: {result.error_message}\n"
    
    return report

def dump_grammars_to_file(
    grammars: Dict[str, ContextFreeGrammar],
    output_path: str,
    analytics: Dict[str, GrammarAnalytics] | None = None,
) -> bool:
    """Serialise a set of grammars (plus optional analytics) into a text file.

    The resulting *dump* is aimed at researchers who prefer to inspect the
    grammar in a plain editor instead of loading the notebook / Python
    objects.
    """
    try:
        with open(output_path, 'w', encoding='utf-8') as f:
            f.write("="*80 + "\n")
            f.write("COMPREHENSIVE CONTEXT-FREE GRAMMAR DUMP\n")
            f.write("="*80 + "\n")
            f.write(f"Generated from LLVM-IR analysis\n")
            f.write(f"Total Functions: {len(grammars)}\n")
            f.write(f"Timestamp: {__import__('datetime').datetime.now()}\n")
            f.write("="*80 + "\n\n")
            
            # Summary statistics
            total_rules = sum(len(g.rules) for g in grammars.values())
            total_non_terminals = sum(len(g.non_terminals) for g in grammars.values())
            total_terminals = sum(len(g.terminals) for g in grammars.values())
            
            f.write("SUMMARY STATISTICS\n")
            f.write("-"*50 + "\n")
            f.write(f"Total Production Rules: {total_rules}\n")
            f.write(f"Total Non-terminals: {total_non_terminals}\n")
            f.write(f"Total Terminals: {total_terminals}\n")
            f.write(f"Average Rules per Function: {total_rules/len(grammars):.2f}\n\n")
            
            # If analytics available, show fuzzing readiness overview
            if analytics:
                avg_fuzzing_score = sum(a.fuzzing_readiness_score for a in analytics.values()) / len(analytics)
                total_choice_points = sum(a.choice_points_count for a in analytics.values())
                total_loops = sum(a.loop_patterns_count for a in analytics.values())
                
                f.write("FUZZING READINESS OVERVIEW\n")
                f.write("-"*50 + "\n")
                f.write(f"Average Fuzzing Score: {avg_fuzzing_score:.2f}/10.0\n")
                f.write(f"Total Choice Points: {total_choice_points}\n")
                f.write(f"Total Loop Patterns: {total_loops}\n")
                f.write(f"Functions with High Fuzzing Score (>7.0): {sum(1 for a in analytics.values() if a.fuzzing_readiness_score > 7.0)}\n\n")
            
            # Detailed grammar dump for each function
            for i, (func_name, grammar) in enumerate(grammars.items(), 1):
                f.write("="*80 + "\n")
                f.write(f"FUNCTION {i}: {func_name}\n")
                f.write("="*80 + "\n\n")
                
                # Basic grammar information
                f.write("GRAMMAR OVERVIEW\n")
                f.write("-"*40 + "\n")
                f.write(f"Start Symbol: {grammar.start_symbol}\n")
                f.write(f"Production Rules: {len(grammar.rules)}\n")
                f.write(f"Non-terminals: {len(grammar.non_terminals)}\n")
                f.write(f"Terminals: {len(grammar.terminals)}\n\n")
                
                # Analytics if available
                if analytics and func_name in analytics:
                    anal = analytics[func_name]
                    f.write("FUZZING ANALYTICS\n")
                    f.write("-"*40 + "\n")
                    f.write(f"Fuzzing Readiness Score: {anal.fuzzing_readiness_score:.2f}/10.0\n")
                    f.write(f"Basic Blocks: {anal.basic_blocks_count}\n")
                    f.write(f"Choice Points: {anal.choice_points_count}\n")
                    f.write(f"Loop Patterns: {anal.loop_patterns_count}\n")
                    f.write(f"Path Alternatives: {anal.path_alternatives_count}\n")
                    f.write(f"Branching Factor: {anal.branching_factor:.2f}\n")
                    f.write(f"Estimated Depth: {anal.depth_estimation}\n")
                    f.write(f"Instruction Types: {', '.join(anal.instruction_types_covered[:10])}\n")
                    if len(anal.instruction_types_covered) > 10:
                        f.write(f"... and {len(anal.instruction_types_covered) - 10} more\n")
                    f.write(f"Control Flow Patterns: {', '.join(anal.control_flow_patterns)}\n\n")
                
                # Non-terminals
                f.write("NON-TERMINALS\n")
                f.write("-"*40 + "\n")
                sorted_nts = sorted(grammar.non_terminals)
                for j in range(0, len(sorted_nts), 8):
                    f.write("  " + ", ".join(sorted_nts[j:j+8]) + "\n")
                f.write("\n")
                
                # Terminals
                f.write("TERMINALS\n")
                f.write("-"*40 + "\n")
                sorted_ts = sorted(grammar.terminals)
                for j in range(0, len(sorted_ts), 10):
                    f.write("  " + ", ".join(sorted_ts[j:j+10]) + "\n")
                f.write("\n")
                
                # Production rules organized by categories
                f.write("PRODUCTION RULES\n")
                f.write("-"*40 + "\n")
                
                # Group rules by left-hand side
                rules_by_lhs = {}
                for rule in grammar.rules:
                    if rule.lhs not in rules_by_lhs:
                        rules_by_lhs[rule.lhs] = []
                    rules_by_lhs[rule.lhs].append(rule.rhs)
                
                # Show rules in organized categories
                categories = {
                    'Function Entry': ['FUNC_', 'ENTRY_'],
                    'Basic Blocks': ['BLOCK_', 'BB_'],
                    'Control Flow': ['CHOICE_POINT', 'BRANCH_', 'CONDITIONAL_'],
                    'Loops': ['LOOP_', 'WHILE_', 'FOR_', 'REPEAT_'],
                    'Instructions': ['INSTRUCTION_SEQ', 'INST_', 'OP_'],
                    'Data Flow': ['PHI_', 'SELECT_', 'ASSIGN_'],
                    'Memory Operations': ['LOAD_', 'STORE_', 'ALLOCA_'],
                    'Paths & Alternatives': ['PATH_', 'ALT_', 'OPT_', 'CHOICE_'],
                    'Other': []
                }
                
                for category, patterns in categories.items():
                    category_rules = []
                    for lhs in sorted(rules_by_lhs.keys()):
                        if patterns and any(pattern in lhs for pattern in patterns):
                            category_rules.append(lhs)
                        elif not patterns:  # 'Other' category
                            if not any(any(p in lhs for p in pats) for pats in list(categories.values())[:-1]):
                                category_rules.append(lhs)
                    
                    if category_rules:
                        f.write(f"\n{category} Rules:\n")
                        for lhs in category_rules[:15]:  # Limit to first 15 rules per category
                            alternatives = rules_by_lhs[lhs]
                            f.write(f"{lhs} ->")
                            for k, rhs in enumerate(alternatives[:3]):  # Show up to 3 alternatives
                                connector = " |" if k > 0 else ""
                                rhs_str = ' '.join(rhs) if rhs else 'EPSILON'
                                if len(rhs_str) > 80:
                                    rhs_str = rhs_str[:77] + "..."
                                f.write(f"{connector} {rhs_str}\n")
                                if k == 0:
                                    f.write("     ")
                            if len(alternatives) > 3:
                                f.write(f"      | ... and {len(alternatives) - 3} more alternatives\n")
                        
                        if len(category_rules) > 15:
                            f.write(f"... and {len(category_rules) - 15} more {category.lower()} rules\n")
                
                f.write("\n" + "-"*80 + "\n\n")
            
            f.write("="*80 + "\n")
            f.write("END OF GRAMMAR DUMP\n")
            f.write("="*80 + "\n")
        
        return True
        
    except Exception as e:
        print(f"Error writing grammar dump to {output_path}: {e}")
        return False

def dump_grammars_from_file(llvm_file_path: str, output_path: str | None = None) -> bool:
    """Utility that combines :pyfunc:`process_llvm_file` **and**
    :pyfunc:`dump_grammars_to_file` for one stop *CLI* convenience.
    """
    # Auto-generate output path if not provided
    if output_path is None:
        base_name = os.path.splitext(os.path.basename(llvm_file_path))[0]
        output_path = f"{base_name}_grammar_dump.txt"
    
    # Process the LLVM file
    result = process_llvm_file(llvm_file_path)
    
    if not result.success:
        print(f"❌ Failed to process {llvm_file_path}: {result.error_message}")
        return False
    
    if not result.grammars:
        print(f"❌ No grammars generated from {llvm_file_path}")
        return False
    
    # Dump grammars to file
    success = dump_grammars_to_file(result.grammars, output_path, result.analytics)
    
    if success:
        print(f"✅ Grammar dump saved to: {output_path}")
        print(f"📊 Processed {result.functions_processed} functions")
        print(f"📝 Generated {result.total_grammar_rules} grammar rules")
        print(f"🎯 Overall fuzzing score: {result.overall_fuzzing_score:.1f}/10.0")
    else:
        print(f"❌ Failed to save grammar dump to {output_path}")
    
    return success

if __name__ == "__main__":
    # Enhanced example usage with grammar dumping capability
    import sys
    
    if len(sys.argv) < 2:
        print("Usage: python llvm_file_processor.py <llvm_file_path> [--dump-grammar] [--output-path <path>]")
        print("  --dump-grammar: Save complete grammar to text file")
        print("  --output-path: Specify custom output path for grammar dump")
        sys.exit(1)
    
    file_path = sys.argv[1]
    dump_grammar = "--dump-grammar" in sys.argv
    
    # Check for custom output path
    output_path = None
    if "--output-path" in sys.argv:
        try:
            output_idx = sys.argv.index("--output-path")
            if output_idx + 1 < len(sys.argv):
                output_path = sys.argv[output_idx + 1]
        except (ValueError, IndexError):
            print("Error: --output-path requires a path argument")
            sys.exit(1)
    
    result = process_llvm_file(file_path)
    
    if not result.success:
        print(f"❌ Failed to process {file_path}: {result.error_message}")
        sys.exit(1)
    
    print(f"✅ Successfully processed: {result.file_path}")
    print(f"Functions: {result.functions_processed}")
    print(f"Total Rules: {result.total_grammar_rules}")
    print(f"Choice Points: {result.total_choice_points}")
    print(f"Fuzzing Score: {result.overall_fuzzing_score:.1f}/10")
    
    # Dump grammar to file if requested
    if dump_grammar or output_path:
        print(f"\n📝 Generating grammar dump...")
        success = dump_grammars_from_file(file_path, output_path)
        if not success:
            print("❌ Failed to generate grammar dump")
    
    if result.success:
        print("\n" + "="*60)
        print("DETAILED ANALYTICS AND GRAMMARS")
        print("="*60)
        
        for func_name, analytics in result.analytics.items():
            print(analytics)
            
            # Show the generated context-free grammar
            grammar = result.grammars[func_name]
            print(f"\n📋 Context-Free Grammar for {func_name}:")
            print("="*50)
            print(f"Start Symbol: {grammar.start_symbol}")
            print(f"Total Rules: {len(grammar.rules)}")
            
            # Show terminals and non-terminals in a more compact format
            terminals_list = sorted(grammar.terminals)
            non_terminals_list = sorted(grammar.non_terminals)
            
            print(f"Non-terminals ({len(non_terminals_list)}): {', '.join(non_terminals_list[:8])}{'...' if len(non_terminals_list) > 8 else ''}")
            print(f"Terminals ({len(terminals_list)}): {', '.join(terminals_list[:8])}{'...' if len(terminals_list) > 8 else ''}")
            
            print("\n🔧 Key Production Rules (Sample):")
            
            # Group rules by left-hand side for better readability
            rules_by_lhs = {}
            for rule in grammar.rules:
                if rule.lhs not in rules_by_lhs:
                    rules_by_lhs[rule.lhs] = []
                rules_by_lhs[rule.lhs].append(rule.rhs)
            
            # Show the most important rules first
            important_patterns = ['FUNC_', 'BLOCK_', 'CHOICE_POINT', 'LOOP_', 'INSTRUCTION_SEQ']
            shown_rules = 0
            max_rules_to_show = 15
            
            for pattern in important_patterns:
                matching_lhs = [lhs for lhs in sorted(rules_by_lhs.keys()) if pattern in lhs]
                for lhs in matching_lhs[:3]:  # Show up to 3 rules per pattern
                    if shown_rules >= max_rules_to_show:
                        break
                    print(f"\n{lhs} ->")
                    for i, rhs in enumerate(rules_by_lhs[lhs][:3]):  # Show up to 3 alternatives per rule
                        connector = "  |" if i > 0 else "   "
                        rhs_str = ' '.join(rhs) if rhs else 'EPSILON'
                        print(f"{connector} {rhs_str}")
                    if len(rules_by_lhs[lhs]) > 3:
                        print(f"  | ... and {len(rules_by_lhs[lhs]) - 3} more alternatives")
                    shown_rules += 1
                if shown_rules >= max_rules_to_show:
                    break
            
            total_rules = len(grammar.rules)
            if total_rules > shown_rules:
                print(f"\n... and {total_rules - shown_rules} more production rules")
            
            print("\n" + "-"*60) 