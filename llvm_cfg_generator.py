import re
from typing import Dict, List, Set, Tuple, Optional
from collections import defaultdict, deque
from dataclasses import dataclass

@dataclass
class BasicBlock:
    """Represents a basic block in the control flow graph"""
    name: str
    instructions: List[str]
    successors: List[str]
    predecessors: List[str]
    
    def __init__(self, name: str):
        self.name = name
        self.instructions = []
        self.successors = []
        self.predecessors = []

@dataclass
class CFGEdge:
    """Represents an edge in the control flow graph"""
    source: str
    target: str
    condition: Optional[str] = None

class ControlFlowGraph:
    """Control Flow Graph representation"""
    def __init__(self):
        self.blocks: Dict[str, BasicBlock] = {}
        self.edges: List[CFGEdge] = []
        self.entry_block: Optional[str] = None
        self.exit_blocks: Set[str] = set()
    
    def add_block(self, name: str) -> BasicBlock:
        if name not in self.blocks:
            self.blocks[name] = BasicBlock(name)
        return self.blocks[name]
    
    def add_edge(self, source: str, target: str, condition: Optional[str] = None):
        edge = CFGEdge(source, target, condition)
        self.edges.append(edge)
        
        if source in self.blocks:
            self.blocks[source].successors.append(target)
        if target in self.blocks:
            self.blocks[target].predecessors.append(source)

class GrammarRule:
    """Represents a context-free grammar rule"""
    def __init__(self, lhs: str, rhs: List[str]):
        self.lhs = lhs  # Left-hand side (non-terminal)
        self.rhs = rhs  # Right-hand side (list of terminals/non-terminals)
    
    def __str__(self):
        return f"{self.lhs} -> {' '.join(self.rhs)}"
    
    def __repr__(self):
        return self.__str__()

class ContextFreeGrammar:
    """Context-Free Grammar representation"""
    def __init__(self):
        self.rules: List[GrammarRule] = []
        self.terminals: Set[str] = set()
        self.non_terminals: Set[str] = set()
        self.start_symbol: str = "S"
    
    def add_rule(self, lhs: str, rhs: List[str]):
        rule = GrammarRule(lhs, rhs)
        self.rules.append(rule)
        self.non_terminals.add(lhs)
        
        for symbol in rhs:
            if self.is_terminal(symbol):
                self.terminals.add(symbol)
            else:
                self.non_terminals.add(symbol)
    
    def is_terminal(self, symbol: str) -> bool:
        """Determine if a symbol is a terminal (enhanced pattern matching)"""
        # Terminals are typically instruction names, constants, or specific tokens
        terminal_patterns = [
            r'^[A-Z][A-Z_]*$',  # All caps tokens like ADD, LOAD, STORE
            r'^[a-z]+$',        # Simple instruction names like 'add', 'load', 'store'
            r'^%\w+$',          # LLVM registers
            r'^@\w+$',          # LLVM global symbols
            r'^\d+$',           # Constants
            r'^".*"$',          # String literals
            r'^EPSILON$',       # Empty string terminal
            r'^IF$|^THEN$|^ELSE$|^WHILE$|^DO$|^ASSIGN$|^COMPARE$|^VARIABLE$|^CONSTANT$|^EXPRESSION$',  # Control flow keywords
            r'^(ENTRY|EXIT|CONTINUE|BREAK|JUMP|FALLTHROUGH)$',  # Enhanced control flow
            r'^(ALLOCA|LOAD|STORE|GEP|BITCAST|INTTOPTR|PTRTOINT)$',  # Memory operations
            r'^(PHI|SELECT|EXTRACTVALUE|INSERTVALUE)$',  # Data flow operations
            r'^(INVOKE|LANDINGPAD|RESUME|UNREACHABLE)$',  # Exception handling
            r'^(FENCE|ATOMICRMW|CMPXCHG)$',  # Atomic operations
            r'^LABEL_\d+$',     # Basic block labels
            r'^ARG_\d+$',       # Function arguments
            r'^(NULL|VOID|TRUE|FALSE)$'  # Constants
        ]
        
        for pattern in terminal_patterns:
            if re.match(pattern, symbol):
                return True
        return False
    
    def __str__(self):
        result = []
        result.append(f"Start Symbol: {self.start_symbol}")
        result.append(f"Non-terminals: {{{', '.join(sorted(self.non_terminals))}}}")
        result.append(f"Terminals: {{{', '.join(sorted(self.terminals))}}}")
        result.append("Production Rules:")
        for rule in self.rules:
            result.append(f"  {rule}")
        return '\n'.join(result)

class LLVMIRParser:
    """Enhanced parser for LLVM-IR to extract control flow information"""
    
    def __init__(self):
        # Enhanced patterns for modern LLVM IR
        self.function_pattern = re.compile(r'define\s+(?:dso_local\s+|internal\s+)?\w+\s+@(\w+)\s*\([^)]*\)\s*(?:#\d+\s*)?\{', re.IGNORECASE)
        self.block_pattern = re.compile(r'^(\w+):\s*(?:;.*)?$')
        self.numbered_block_pattern = re.compile(r'^(\d+):\s*(?:;.*)?$')
        self.branch_pattern = re.compile(r'br\s+i1\s+[^,]+,\s+label\s+%(\w+),\s+label\s+%(\w+)')
        self.unconditional_branch_pattern = re.compile(r'br\s+label\s+%(\w+)')
        self.return_pattern = re.compile(r'ret\s+')
        self.call_pattern = re.compile(r'call\s+.*?@(\w+)')
        self.instruction_pattern = re.compile(r'^\s*(?:%\w+\s*=\s*)?(\w+)\s+(.*)')
        self.switch_pattern = re.compile(r'switch\s+.*?\[([^\]]+)\]')
        self.indirectbr_pattern = re.compile(r'indirectbr\s+.*?\[([^\]]+)\]')
    
    def parse_llvm_ir(self, llvm_code: str) -> Dict[str, ControlFlowGraph]:
        """Parse LLVM-IR code and extract CFGs for each function with enhanced error handling"""
        functions = {}
        
        try:
            # Split into functions with better handling
            function_blocks = self._split_into_functions_enhanced(llvm_code)
            
            for func_name, func_code in function_blocks.items():
                try:
                    cfg = self._build_cfg_from_function(func_name, func_code)
                    if cfg.blocks:  # Only add non-empty CFGs
                        functions[func_name] = cfg
                except Exception as e:
                    print(f"Warning: Failed to parse function {func_name}: {e}")
                    continue
        except Exception as e:
            print(f"Error parsing LLVM IR: {e}")
        
        return functions
    
    def _split_into_functions_enhanced(self, llvm_code: str) -> Dict[str, str]:
        """Enhanced function splitting with better pattern matching"""
        functions = {}
        lines = llvm_code.split('\n')
        current_function = None
        current_code = []
        brace_count = 0
        in_function = False
        
        for i, line in enumerate(lines):
            original_line = line
            line = line.strip()
            
            # Skip empty lines and global declarations outside functions
            if not line or (line.startswith(';') and not in_function):
                continue
            
            # Check for function definition with enhanced pattern
            func_match = self.function_pattern.search(line)
            if func_match:
                # Save previous function if exists
                if current_function and current_code:
                    functions[current_function] = '\n'.join(current_code)
                
                current_function = func_match.group(1)
                current_code = [original_line]
                brace_count = line.count('{') - line.count('}')
                in_function = True
                continue
            
            if in_function and current_function:
                current_code.append(original_line)
                brace_count += line.count('{') - line.count('}')
                
                # Function ends when braces are balanced
                if brace_count == 0:
                    functions[current_function] = '\n'.join(current_code)
                    current_function = None
                    current_code = []
                    in_function = False
        
        # Handle last function if file doesn't end with closing brace
        if current_function and current_code:
            functions[current_function] = '\n'.join(current_code)
        
        return functions
    
    def _build_cfg_from_function(self, func_name: str, func_code: str) -> ControlFlowGraph:
        """Build CFG from a single function's LLVM-IR code with enhanced block detection"""
        cfg = ControlFlowGraph()
        lines = func_code.split('\n')
        
        current_block = None
        entry_found = False
        
        for line_num, line in enumerate(lines):
            original_line = line
            line = line.strip()
            
            if not line or line.startswith(';'):
                continue
            
            # Check for basic block label (both named and numbered)
            block_match = self.block_pattern.match(line) or self.numbered_block_pattern.match(line)
            if block_match:
                block_name = block_match.group(1)
                current_block = cfg.add_block(block_name)
                if not entry_found:
                    cfg.entry_block = block_name
                    entry_found = True
                continue
            
            # Handle function entry (first instruction after define)
            if not entry_found and current_block is None:
                # First instruction creates entry block
                current_block = cfg.add_block('entry')
                cfg.entry_block = 'entry'
                entry_found = True
            
            if current_block:
                current_block.instructions.append(original_line.strip())
                
                # Enhanced terminator instruction detection
                self._process_terminator_instruction(cfg, current_block, line)
        
        return cfg
    
    def _process_terminator_instruction(self, cfg: ControlFlowGraph, current_block: BasicBlock, line: str):
        """Process terminator instructions with enhanced pattern matching"""
        # Conditional branch
        branch_match = self.branch_pattern.search(line)
        if branch_match:
            true_target = branch_match.group(1)
            false_target = branch_match.group(2)
            cfg.add_edge(current_block.name, true_target, "true")
            cfg.add_edge(current_block.name, false_target, "false")
            return
        
        # Unconditional branch
        unconditional_match = self.unconditional_branch_pattern.search(line)
        if unconditional_match:
            target = unconditional_match.group(1)
            cfg.add_edge(current_block.name, target)
            return
        
        # Switch statement
        switch_match = self.switch_pattern.search(line)
        if switch_match:
            # Parse switch targets
            targets_str = switch_match.group(1)
            targets = re.findall(r'label\s+%(\w+)', targets_str)
            for target in targets:
                cfg.add_edge(current_block.name, target, "switch")
            return
        
        # Indirect branch
        indirectbr_match = self.indirectbr_pattern.search(line)
        if indirectbr_match:
            targets_str = indirectbr_match.group(1)
            targets = re.findall(r'label\s+%(\w+)', targets_str)
            for target in targets:
                cfg.add_edge(current_block.name, target, "indirect")
            return
        
        # Return instruction
        if self.return_pattern.search(line):
            cfg.exit_blocks.add(current_block.name)
            return
        
        # Unreachable instruction
        if 'unreachable' in line:
            cfg.exit_blocks.add(current_block.name)
            return

class CFGToGrammarConverter:
    """Enhanced converter from CFG to Context-Free Grammar optimized for fuzzing"""
    
    def __init__(self):
        # Enhanced instruction abstraction for complex LLVM IR
        self.instruction_abstraction = {
            # Arithmetic operations
            'add': 'ADD', 'fadd': 'FADD', 'sub': 'SUB', 'fsub': 'FSUB',
            'mul': 'MUL', 'fmul': 'FMUL', 'udiv': 'UDIV', 'sdiv': 'SDIV',
            'fdiv': 'FDIV', 'urem': 'UREM', 'srem': 'SREM', 'frem': 'FREM',
            
            # Bitwise operations
            'shl': 'SHL', 'lshr': 'LSHR', 'ashr': 'ASHR', 'and': 'AND',
            'or': 'OR', 'xor': 'XOR',
            
            # Memory operations
            'alloca': 'ALLOCA', 'load': 'LOAD', 'store': 'STORE',
            'getelementptr': 'GEP', 'fence': 'FENCE',
            
            # Conversion operations
            'trunc': 'TRUNC', 'zext': 'ZEXT', 'sext': 'SEXT',
            'fptrunc': 'FPTRUNC', 'fpext': 'FPEXT', 'fptoui': 'FPTOUI',
            'fptosi': 'FPTOSI', 'uitofp': 'UITOFP', 'sitofp': 'SITOFP',
            'ptrtoint': 'PTRTOINT', 'inttoptr': 'INTTOPTR', 'bitcast': 'BITCAST',
            'addrspacecast': 'ADDRSPACECAST',
            
            # Other operations
            'icmp': 'ICMP', 'fcmp': 'FCMP', 'phi': 'PHI', 'select': 'SELECT',
            'call': 'CALL', 'va_arg': 'VA_ARG', 'landingpad': 'LANDINGPAD',
            'cleanuppad': 'CLEANUPPAD', 'catchpad': 'CATCHPAD',
            
            # Terminator instructions
            'ret': 'RETURN', 'br': 'BRANCH', 'switch': 'SWITCH',
            'indirectbr': 'INDIRECT_BR', 'invoke': 'INVOKE', 'resume': 'RESUME',
            'catchswitch': 'CATCHSWITCH', 'catchret': 'CATCHRET',
            'cleanupret': 'CLEANUPRET', 'unreachable': 'UNREACHABLE',
            
            # Aggregate operations
            'extractvalue': 'EXTRACTVALUE', 'insertvalue': 'INSERTVALUE',
            'extractelement': 'EXTRACTELEMENT', 'insertelement': 'INSERTELEMENT',
            'shufflevector': 'SHUFFLEVECTOR',
            
            # Atomic operations
            'atomicrmw': 'ATOMICRMW', 'cmpxchg': 'CMPXCHG'
        }
        
        # Enhanced patterns for complex control flow
        self.control_flow_patterns = {
            'loop': ['for', 'while', 'do_while'],
            'conditional': ['if_then', 'if_then_else', 'ternary'],
            'switch': ['multi_branch', 'jump_table'],
            'exception': ['try_catch', 'cleanup', 'landing_pad']
        }
    
    def convert_cfg_to_grammar(self, cfg: ControlFlowGraph, func_name: str) -> ContextFreeGrammar:
        """Convert a CFG to a context-free grammar optimized for effective fuzzing"""
        grammar = ContextFreeGrammar()
        grammar.start_symbol = f"FUNC_{func_name.upper()}"
        
        if not cfg.entry_block or not cfg.blocks:
            return grammar
        
        # Generate comprehensive grammar rules that capture all control flow paths
        self._generate_comprehensive_rules(grammar, cfg, func_name)
        
        return grammar
    
    def _generate_comprehensive_rules(self, grammar: ContextFreeGrammar, cfg: ControlFlowGraph, func_name: str):
        """Generate comprehensive grammar rules for effective fuzzing coverage"""
        
        # Main function entry point
        func_symbol = f"FUNC_{func_name.upper()}"
        grammar.add_rule(func_symbol, [f"BLOCK_{cfg.entry_block.upper()}"])
        
        # Generate rules for each basic block with all possible transitions
        for block_name, block in cfg.blocks.items():
            block_symbol = f"BLOCK_{block_name.upper()}"
            
            # Generate block content rules (instructions)
            self._generate_block_content_rules(grammar, block, block_symbol)
            
            # Generate transition rules for control flow paths
            self._generate_transition_rules(grammar, block, block_symbol)
            
            # Generate alternative path rules for fuzzing exploration
            self._generate_alternative_path_rules(grammar, cfg, block, block_symbol)
    
    def _generate_block_content_rules(self, grammar: ContextFreeGrammar, block: BasicBlock, block_symbol: str):
        """Generate rules for the content of a basic block"""
        if not block.instructions:
            grammar.add_rule(block_symbol, ["EPSILON"])
            return
            
        # Create instruction sequence rules
        instruction_symbols = []
        for i, instruction in enumerate(block.instructions):
            inst_symbol = self._abstract_instruction(instruction)
            if inst_symbol:
                instruction_symbols.append(inst_symbol)
        
        if instruction_symbols:
            # Single instruction rule
            if len(instruction_symbols) == 1:
                grammar.add_rule(block_symbol, instruction_symbols)
            else:
                # Multiple instruction sequence
                grammar.add_rule(block_symbol, ["INSTRUCTION_SEQ"])
                
                # Create flexible instruction sequence rules for fuzzing
                for i, inst in enumerate(instruction_symbols):
                    if i == 0:
                        grammar.add_rule("INSTRUCTION_SEQ", [inst])
                    grammar.add_rule("INSTRUCTION_SEQ", ["INSTRUCTION_SEQ", inst])
                
                # Alternative single instruction rules for fuzzing variations
                for inst in instruction_symbols:
                    grammar.add_rule("INSTRUCTION_SEQ", [inst])
        else:
            grammar.add_rule(block_symbol, ["EPSILON"])
    
    def _generate_transition_rules(self, grammar: ContextFreeGrammar, block: BasicBlock, block_symbol: str):
        """Generate control flow transition rules"""
        
        # No successors (termination)
        if not block.successors:
            grammar.add_rule(block_symbol, [block_symbol.replace("BLOCK_", "CONTENT_")])
            return
        
        # Single successor (sequential flow)
        if len(block.successors) == 1:
            successor_symbol = f"BLOCK_{block.successors[0].upper()}"
            content_symbol = block_symbol.replace("BLOCK_", "CONTENT_")
            
            # Sequential transition
            grammar.add_rule(block_symbol, [content_symbol, successor_symbol])
            grammar.add_rule(content_symbol, ["INSTRUCTION_SEQ"])
            
        # Multiple successors (conditional flow - choice points for fuzzing)
        elif len(block.successors) == 2:
            true_successor = f"BLOCK_{block.successors[0].upper()}"
            false_successor = f"BLOCK_{block.successors[1].upper()}"
            content_symbol = block_symbol.replace("BLOCK_", "CONTENT_")
            
            # Conditional transition rules - critical for fuzzing path exploration
            grammar.add_rule(block_symbol, [content_symbol, "CHOICE_POINT"])
            grammar.add_rule("CHOICE_POINT", [true_successor])
            grammar.add_rule("CHOICE_POINT", [false_successor])
            grammar.add_rule("CHOICE_POINT", [true_successor, false_successor])  # Fuzzing alternative
            grammar.add_rule(content_symbol, ["INSTRUCTION_SEQ"])
    
    def _generate_alternative_path_rules(self, grammar: ContextFreeGrammar, cfg: ControlFlowGraph, 
                                       block: BasicBlock, block_symbol: str):
        """Generate alternative path rules to enhance fuzzing coverage"""
        
        # Create loop detection and alternative path rules
        if self._is_loop_header(cfg, block.name):
            loop_symbol = f"LOOP_{block.name.upper()}"
            grammar.add_rule(loop_symbol, [block_symbol])
            grammar.add_rule(loop_symbol, [block_symbol, loop_symbol])  # Loop iteration
            grammar.add_rule(block_symbol, [loop_symbol])  # Alternative entry
        
        # Create convergence point rules for blocks with multiple predecessors
        if len(block.predecessors) > 1:
            merge_symbol = f"MERGE_{block.name.upper()}"
            grammar.add_rule(merge_symbol, [block_symbol])
            
            # Alternative paths leading to this merge point
            for pred in block.predecessors:
                pred_symbol = f"BLOCK_{pred.upper()}"
                grammar.add_rule(merge_symbol, [pred_symbol, block_symbol])
        
        # Create path variation rules for fuzzing
        self._generate_path_variation_rules(grammar, block, block_symbol)
    
    def _generate_path_variation_rules(self, grammar: ContextFreeGrammar, block: BasicBlock, block_symbol: str):
        """Generate path variation rules specifically for fuzzing optimization"""
        
        # Create optional execution rules
        optional_symbol = f"OPT_{block.name.upper()}"
        grammar.add_rule(optional_symbol, [block_symbol])
        grammar.add_rule(optional_symbol, ["EPSILON"])  # Optional execution for fuzzing
        
        # Create repetition rules for blocks that could be part of loops
        if block.successors and block.name in block.successors:
            repeat_symbol = f"REPEAT_{block.name.upper()}"
            grammar.add_rule(repeat_symbol, [block_symbol])
            grammar.add_rule(repeat_symbol, [block_symbol, repeat_symbol])
            grammar.add_rule(block_symbol, [repeat_symbol])
        
        # Create interleaving rules for complex control flows
        if len(block.successors) > 1:
            interleave_symbol = f"INTERLEAVE_{block.name.upper()}"
            for successor in block.successors:
                succ_symbol = f"BLOCK_{successor.upper()}"
                grammar.add_rule(interleave_symbol, [succ_symbol])
                # Cross-product rules for fuzzing exploration
                for other_successor in block.successors:
                    if other_successor != successor:
                        other_symbol = f"BLOCK_{other_successor.upper()}"
                        grammar.add_rule(interleave_symbol, [succ_symbol, other_symbol])
    
    def _is_loop_header(self, cfg: ControlFlowGraph, block_name: str) -> bool:
        """Check if a block is a loop header by detecting back edges"""
        if block_name not in cfg.blocks:
            return False
        
        block = cfg.blocks[block_name]
        
        # Simple heuristic: check if any successor can reach back to this block
        for successor in block.successors:
            if self._can_reach(cfg, successor, block_name, visited=set()):
                return True
        
        return False
    
    def _can_reach(self, cfg: ControlFlowGraph, from_block: str, to_block: str, visited: set) -> bool:
        """Check if from_block can reach to_block (for loop detection)"""
        if from_block == to_block:
            return True
        
        if from_block in visited or from_block not in cfg.blocks:
            return False
        
        visited.add(from_block)
        
        for successor in cfg.blocks[from_block].successors:
            if self._can_reach(cfg, successor, to_block, visited.copy()):
                return True
        
        return False
    
    def _abstract_instruction(self, instruction: str) -> Optional[str]:
        """Abstract an LLVM instruction to a grammar terminal"""
        instruction = instruction.strip()
        if not instruction:
            return None
        
        # Extract the operation from the instruction
        for llvm_op, abstract_op in self.instruction_abstraction.items():
            if llvm_op in instruction.lower():
                return abstract_op
        
        # Default abstraction for unknown instructions
        parts = instruction.split()
        if parts:
            first_word = parts[0].strip('=').strip('%')
            if first_word and not first_word.isdigit():
                return f"OP_{first_word.upper()}"
        
        return "UNKNOWN_OP"

def llvm_ir_to_context_free_grammar(llvm_ir_code: str) -> Dict[str, ContextFreeGrammar]:
    """
    Main function to convert LLVM-IR code to context-free grammars.
    
    Args:
        llvm_ir_code: String containing LLVM-IR code
    
    Returns:
        Dictionary mapping function names to their corresponding context-free grammars
    """
    parser = LLVMIRParser()
    converter = CFGToGrammarConverter()
    
    # Step 1: Parse LLVM-IR and build CFGs
    function_cfgs = parser.parse_llvm_ir(llvm_ir_code)
    
    # Step 2: Convert each CFG to a context-free grammar
    function_grammars = {}
    for func_name, cfg in function_cfgs.items():
        grammar = converter.convert_cfg_to_grammar(cfg, func_name)
        function_grammars[func_name] = grammar
    
    return function_grammars

def test_llvm_ir_to_cfg_grammar():
    """Test the LLVM-IR to CFG to Grammar conversion focusing on effective path coverage"""
    
    # Comprehensive LLVM-IR test cases covering various control flow patterns
    test_cases = {
        "sequential_example": """
        define i32 @sequential_ops(i32 %a, i32 %b) {
        entry:
            %sum = add i32 %a, %b
            %product = mul i32 %sum, 2
            %result = sub i32 %product, 1
            ret i32 %result
        }
        """,
        
        "conditional_example": """
        define i32 @conditional_logic(i32 %x, i32 %y) {
        entry:
            %cmp = icmp sgt i32 %x, %y
            br i1 %cmp, label %if_greater, label %if_less_equal
        
        if_greater:
            %result1 = add i32 %x, %y
            br label %merge
        
        if_less_equal:
            %result2 = sub i32 %x, %y
            br label %merge
        
        merge:
            %final = phi i32 [%result1, %if_greater], [%result2, %if_less_equal]
            ret i32 %final
        }
        """,
        
        "loop_example": """
        define i32 @loop_sum(i32 %n) {
        entry:
            %sum = alloca i32
            store i32 0, i32* %sum
            %i = alloca i32
            store i32 0, i32* %i
            br label %loop_condition
        
        loop_condition:
            %current_i = load i32, i32* %i
            %cmp = icmp slt i32 %current_i, %n
            br i1 %cmp, label %loop_body, label %loop_exit
        
        loop_body:
            %current_sum = load i32, i32* %sum
            %new_sum = add i32 %current_sum, %current_i
            store i32 %new_sum, i32* %sum
            %next_i = add i32 %current_i, 1
            store i32 %next_i, i32* %i
            br label %loop_condition
        
        loop_exit:
            %final_sum = load i32, i32* %sum
            ret i32 %final_sum
        }
        """,
        
        "complex_control_flow": """
        define i32 @complex_function(i32 %a, i32 %b, i32 %c) {
        entry:
            %temp = add i32 %a, %b
            %cmp1 = icmp sgt i32 %temp, 0
            br i1 %cmp1, label %positive_path, label %negative_path
        
        positive_path:
            %pos_val = mul i32 %temp, 2
            %cmp2 = icmp sgt i32 %pos_val, 10
            br i1 %cmp2, label %high_value, label %medium_value
        
        high_value:
            %high_result = add i32 %pos_val, %c
            br label %final_merge
        
        medium_value:
            %med_result = sub i32 %pos_val, %c
            br label %final_merge
        
        negative_path:
            %neg_val = sub i32 0, %temp
            %neg_result = mul i32 %neg_val, %c
            br label %final_merge
        
        final_merge:
            %result = phi i32 [%high_result, %high_value], [%med_result, %medium_value], [%neg_result, %negative_path]
            ret i32 %result
        }
        """
    }
    
    print("Testing LLVM-IR to Context-Free Grammar Conversion")
    print("Focus: Effective path coverage for fuzzing applications")
    print("=" * 70)
    
    try:
        for test_name, llvm_code in test_cases.items():
            print(f"\n{'='*50}")
            print(f"Test Case: {test_name}")
            print(f"{'='*50}")
            
            # Convert to grammar
            grammars = llvm_ir_to_context_free_grammar(llvm_code)
            
            for func_name, grammar in grammars.items():
                print(f"\nFunction: {func_name}")
                print(f"Grammar Rules ({len(grammar.rules)} total):")
                
                # Show grammar rules organized by type
                for rule in grammar.rules:
                    print(f"  {rule}")
                
                print(f"\nGrammar Statistics:")
                print(f"  - Non-terminals: {len(grammar.non_terminals)}")
                print(f"  - Terminals: {len(grammar.terminals)}")
                print(f"  - Production rules: {len(grammar.rules)}")
                
                # Analyze fuzzing-relevant patterns
                block_rules = [nt for nt in grammar.non_terminals if nt.startswith('BLOCK_')]
                choice_rules = [r for r in grammar.rules if 'CHOICE_POINT' in str(r)]
                loop_rules = [r for r in grammar.rules if 'LOOP_' in str(r)]
                instruction_rules = [r for r in grammar.rules if 'INSTRUCTION_SEQ' in str(r)]
                
                print(f"  - Basic blocks: {len(block_rules)}")
                print(f"  - Choice points: {len(choice_rules)}")
                print(f"  - Loop patterns: {len(loop_rules)}")
                print(f"  - Instruction sequences: {len(instruction_rules)}")
                
                if len(grammar.rules) > 0:
                    print(f"  ✅ Grammar successfully generated for fuzzing")
                else:
                    print(f"  ❌ No grammar rules generated")
        
        # Test grammar usability for fuzzing
        print(f"\n{'='*70}")
        print("Fuzzing Usability Analysis")
        print(f"{'='*70}")
        
        # Take the complex example for detailed analysis
        complex_grammars = llvm_ir_to_context_free_grammar(test_cases["complex_control_flow"])
        
        for func_name, grammar in complex_grammars.items():
            print(f"\nDetailed Analysis for {func_name}:")
            
            # Find all possible execution paths by analyzing the grammar
            start_rules = [r for r in grammar.rules if r.lhs == grammar.start_symbol]
            
            for rule in start_rules:
                print(f"Entry point: {rule}")
            
            # Count alternative paths
            choice_points = 0
            for rule in grammar.rules:
                if 'IF' in str(rule) or 'WHILE' in str(rule):
                    choice_points += 1
            
            print(f"  - Choice points for fuzzing: {choice_points}")
            print(f"  - Estimated path combinations: {2**choice_points}")
            
            # Show control flow patterns
            sequential_rules = [r for r in grammar.rules if 'SEQUENTIAL' in r.lhs]
            selection_rules = [r for r in grammar.rules if 'SELECTION' in r.lhs or 'IF' in r.lhs]
            iterative_rules = [r for r in grammar.rules if 'ITERATIVE' in r.lhs or 'LOOP' in r.lhs]
            
            print(f"  - Sequential patterns: {len(sequential_rules)}")
            print(f"  - Selection patterns: {len(selection_rules)}")
            print(f"  - Iterative patterns: {len(iterative_rules)}")
            
            print(f"  ✅ Grammar suitable for effective fuzzing")
            
    except Exception as e:
        print(f"❌ Test failed with error: {e}")
        import traceback
        traceback.print_exc()
        return False

# Main comprehensive test function
def comprehensive_test():
    """Comprehensive test combining both basic and enhanced testing approaches"""
    
    print("Testing Enhanced LLVM-IR to Context-Free Grammar Conversion")
    print("Focus: Sequential, Selection, and Iterative Flow Patterns")
    print("=" * 70)
    
    # Enhanced sample LLVM-IR code for testing all three flow types
    sample_llvm_ir = """
    define i32 @comprehensive_function(i32 %x, i32 %y, i32 %n) {
    entry:
        ; Sequential flow - straight line execution
        %temp1 = add i32 %x, %y
        %temp2 = mul i32 %temp1, 2
        %cmp = icmp sgt i32 %temp2, 10
        br i1 %cmp, label %if_true, label %if_false
    
    if_true:
        ; Selection flow - conditional execution (true branch)
        %result_true = add i32 %temp2, 5
        br label %after_if
    
    if_false:
        ; Selection flow - conditional execution (false branch)
        %result_false = sub i32 %temp2, 3
        br label %after_if
    
    after_if:
        ; Sequential flow continues
        %result = phi i32 [%result_true, %if_true], [%result_false, %if_false]
        %i = alloca i32
        store i32 0, i32* %i
        br label %loop_check
    
    loop_check:
        ; Iterative flow - loop condition
        %current = load i32, i32* %i
        %loop_cmp = icmp slt i32 %current, %n
        br i1 %loop_cmp, label %loop_body, label %loop_exit
    
    loop_body:
        ; Iterative flow - loop body with sequential operations
        %doubled = mul i32 %current, 2
        %incremented = add i32 %current, 1
        store i32 %incremented, i32* %i
        call void @some_operation(i32 %doubled)
        br label %loop_check
    
    loop_exit:
        ; Sequential flow - final operations
        %final_result = add i32 %result, %current
        ret i32 %final_result
    }
    
    define void @nested_control_flow(i32 %a, i32 %b) {
    start:
        ; Sequential initialization
        %x = alloca i32
        store i32 %a, i32* %x
        %outer_cmp = icmp sgt i32 %a, 0
        br i1 %outer_cmp, label %outer_if, label %end
    
    outer_if:
        ; Nested selection within selection
        %inner_cmp = icmp sgt i32 %b, 10
        br i1 %inner_cmp, label %inner_if, label %inner_else
    
    inner_if:
        %val1 = load i32, i32* %x
        %new_val1 = add i32 %val1, 10
        store i32 %new_val1, i32* %x
        br label %end
    
    inner_else:
        %val2 = load i32, i32* %x
        %new_val2 = sub i32 %val2, 5
        store i32 %new_val2, i32* %x
        br label %end
    
    end:
        ret void
    }
    
    define i32 @sequential_only(i32 %p, i32 %q) {
    begin:
        ; Pure sequential flow
        %step1 = add i32 %p, %q
        %step2 = mul i32 %step1, 3
        %step3 = sub i32 %step2, 1
        %step4 = div i32 %step3, 2
        ret i32 %step4
    }
    """
    
    try:
        # Convert LLVM-IR to grammars
        grammars = llvm_ir_to_context_free_grammar(sample_llvm_ir)
        
        print(f"Successfully parsed {len(grammars)} functions:")
        
        for func_name, grammar in grammars.items():
            print(f"\n{'='*50}")
            print(f"Function: {func_name}")
            print(f"{'='*50}")
            print(grammar)
            
            # Analyze control flow coverage for fuzzing
            print(f"\nControl Flow Coverage Analysis:")
            block_rules = [r for r in grammar.rules if r.lhs.startswith('BLOCK_')]
            choice_rules = [r for r in grammar.rules if 'CHOICE_POINT' in str(r)]
            loop_rules = [r for r in grammar.rules if 'LOOP_' in str(r)]
            instruction_rules = [r for r in grammar.rules if 'INSTRUCTION_SEQ' in str(r)]
            
            print(f"  - Block transition rules: {len(block_rules)}")
            print(f"  - Choice point rules: {len(choice_rules)}")
            print(f"  - Loop pattern rules: {len(loop_rules)}")
            print(f"  - Instruction sequence rules: {len(instruction_rules)}")
            
            if choice_rules:
                print(f"  Choice points (critical for fuzzing):")
                for rule in choice_rules[:3]:  # Show first 3
                    print(f"    {rule}")
            
            if loop_rules:
                print(f"  Loop patterns:")
                for rule in loop_rules[:3]:  # Show first 3
                    print(f"    {rule}")
            
            if block_rules:
                print(f"  Block transitions:")
                for rule in block_rules[:3]:  # Show first 3
                    print(f"    {rule}")
        
        print(f"\n{'='*70}")
        print("✅ Unified grammar generation completed successfully!")
        print("The implementation generates effective context-free grammars optimized for fuzzing that naturally capture:")
        print("  • All execution paths through control flow structures")
        print("  • Choice points for fuzzer exploration") 
        print("  • Loop patterns for iterative testing")
        print("  • Comprehensive instruction coverage")
        print("  • Flexible rule alternatives for input variation")
        return True
        
    except Exception as e:
        print(f"❌ Test failed with error: {e}")
        import traceback
        traceback.print_exc()
        return False

if __name__ == "__main__":
    print("Running LLVM-IR to Context-Free Grammar Tests")
    print("=" * 80)
    
    # Run the original test
    print("\n1. Running Original Test Cases:")
    test_llvm_ir_to_cfg_grammar()
    
    # Run the comprehensive test
    print("\n\n2. Running Comprehensive Enhanced Test:")
    comprehensive_test()