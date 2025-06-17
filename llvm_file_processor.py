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
    """Comprehensive analytics for a generated context-free grammar"""
    
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
    """Result of processing an LLVM-IR file"""
    
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
    """High-level processor for LLVM-IR files with comprehensive analytics"""
    
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
    """
    Convenience function to process a single LLVM-IR file.
    
    Args:
        file_path: Path to the LLVM-IR file
        
    Returns:
        FileProcessingResult with grammars and comprehensive analytics
    """
    processor = LLVMFileProcessor()
    return processor.process_file(file_path)

def process_multiple_files(file_paths: List[str]) -> Dict[str, FileProcessingResult]:
    """
    Process multiple LLVM-IR files and return results for each.
    
    Args:
        file_paths: List of paths to LLVM-IR files
        
    Returns:
        Dictionary mapping file paths to their processing results
    """
    processor = LLVMFileProcessor()
    results = {}
    
    for file_path in file_paths:
        results[file_path] = processor.process_file(file_path)
    
    return results

def generate_batch_report(results: Dict[str, FileProcessingResult]) -> str:
    """
    Generate a comprehensive report for batch processing results.
    
    Args:
        results: Dictionary of file processing results
        
    Returns:
        Formatted report string
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

if __name__ == "__main__":
    # Example usage
    import sys
    
    if len(sys.argv) < 2:
        print("Usage: python llvm_file_processor.py <llvm_file_path>")
        sys.exit(1)
    
    file_path = sys.argv[1]
    result = process_llvm_file(file_path)
    
    print(f"✅ Successfully processed: {result.file_path}")
    print(f"Functions: {result.functions_processed}")
    print(f"Total Rules: {result.total_grammar_rules}")
    print(f"Choice Points: {result.total_choice_points}")
    print(f"Fuzzing Score: {result.overall_fuzzing_score:.1f}/10")
    
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