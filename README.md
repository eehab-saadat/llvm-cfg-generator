# LLVM-IR to Context-Free Grammar Generator

A powerful Python tool that converts LLVM Intermediate Representation (LLVM-IR) code into context-free grammars optimized for fuzzing applications. This tool analyzes control flow structures in compiled programs and generates grammar rules that capture all possible execution paths, making it ideal for systematic testing and fuzzing.

## 🎯 Overview

This tool bridges the gap between low-level program analysis and high-level fuzzing by:

- **Parsing LLVM-IR** from compiled programs
- **Building Control Flow Graphs (CFGs)** to understand program structure  
- **Generating Context-Free Grammars** that capture all execution paths
- **Optimizing for fuzzing** with choice points, loop patterns, and path alternatives

## 🚀 Key Features

- **Unified Grammar Generation**: No artificial distinctions between control flow types
- **Fuzzing-Optimized**: Grammar rules designed for effective test case generation
- **Comprehensive Coverage**: Captures sequential flows, conditional branches, and loops
- **Choice Point Detection**: Identifies critical decision points for path exploration
- **Loop Pattern Recognition**: Automatic detection and grammar generation for iterative structures
- **Instruction Abstraction**: LLVM instructions mapped to meaningful grammar terminals

## 📋 Requirements

- Python 3.7+
- No external dependencies (uses only Python standard library)

## 🔧 Installation

1. Clone the repository:
```bash
git clone https://github.com/eehab-saadat/llvm-cfg-generator.git
cd llvm-cfg-generator
```

2. The tool is ready to use - no additional installation required!

### Project Structure
```
llvm-cfg-generator/
├── llvm_cfg_generator.py      # Core grammar generation engine
├── llvm_file_processor.py     # File processing with analytics
├── llvm_grammar_extractor.py  # Simple raw grammar extraction
├── example.ll                 # Sample LLVM-IR file for testing
├── README.md                  # This documentation
└── LICENSE                    # MIT license
```

## 📖 Usage

### File Processing (Recommended)

The easiest way to use the tool is to process LLVM-IR files directly:

```python
from llvm_file_processor import process_llvm_file

# Process an LLVM-IR file (.ll, .bc, or .txt)
result = process_llvm_file("path/to/your/program.ll")

if result.success:
    print(f"📁 Processed: {result.file_path}")
    print(f"🔢 Functions: {result.functions_processed}")
    print(f"📋 Grammar Rules: {result.total_grammar_rules}")
    print(f"🔀 Choice Points: {result.total_choice_points}")
    print(f"🎯 Fuzzing Score: {result.overall_fuzzing_score:.1f}/10.0")
    
    # Access detailed analytics for each function
    for func_name, analytics in result.analytics.items():
        print(f"\n📊 {func_name}:")
        print(f"   Fuzzing Score: {analytics.fuzzing_readiness_score}/10.0")
        print(f"   Control Flow: {', '.join(analytics.control_flow_patterns)}")
        print(f"   Instructions: {', '.join(analytics.instruction_types_covered)}")
        
        # Access the generated context-free grammar
        grammar = result.grammars[func_name]
        print(f"   Grammar Rules: {len(grammar.rules)}")
        print(f"   Start Symbol: {grammar.start_symbol}")
else:
    print(f"❌ Error: {result.error_message}")
```

### Raw Grammar Extraction (Simple)

For cases where you only need the context-free grammar without analytics:

```python
from llvm_grammar_extractor import extract_grammar_from_file

# Extract raw grammars from file
grammars = extract_grammar_from_file("program.ll")

for func_name, grammar in grammars.items():
    print(f"Function: {func_name}")
    print(f"Rules: {len(grammar.rules)}")
    print(f"Start: {grammar.start_symbol}")
    # Access grammar.rules, grammar.terminals, grammar.non_terminals
```

### Direct String Processing

You can also process LLVM-IR code directly as strings:

```python
from llvm_cfg_generator import llvm_ir_to_context_free_grammar

# Your LLVM-IR code
llvm_code = """
define i32 @example_function(i32 %x, i32 %y) {
entry:
    %cmp = icmp sgt i32 %x, %y
    br i1 %cmp, label %if_true, label %if_false

if_true:
    %result1 = add i32 %x, %y
    br label %end

if_false:
    %result2 = sub i32 %x, %y
    br label %end

end:
    %final = phi i32 [%result1, %if_true], [%result2, %if_false]
    ret i32 %final
}
"""

# Generate grammars
grammars = llvm_ir_to_context_free_grammar(llvm_code)

# Access results
for func_name, grammar in grammars.items():
    print(f"Function: {func_name}")
    print(f"Grammar rules: {len(grammar.rules)}")
    for rule in grammar.rules:
        print(f"  {rule}")
```

### Command Line Usage

```bash
# Process a single file with complete analytics and grammar display
python llvm_file_processor.py program.ll

# Try the provided example
python llvm_file_processor.py example.ll

# Extract raw grammars only (no analytics)
python llvm_grammar_extractor.py example.ll

# Extract grammar for a specific function
python llvm_grammar_extractor.py example.ll simple_function

# Process the example LLVM-IR generator
python llvm_cfg_generator.py
```

**Output includes:**
- 📊 **Comprehensive Analytics**: Fuzzing scores, choice points, loop patterns, complexity metrics
- 📋 **Context-Free Grammars**: Complete production rules, terminals, non-terminals
- 🎯 **Practical Insights**: Control flow patterns and fuzzing strategy recommendations

### Running Tests

```bash
python llvm_cfg_generator.py
```

This runs comprehensive tests with various LLVM-IR examples demonstrating:
- Sequential execution patterns
- Conditional branching (if-then-else)
- Loop structures
- Complex nested control flows

## 🏗️ Architecture

### Core Components

```
LLVM-IR File → LLVMFileProcessor → LLVMIRParser → Control Flow Graph → CFGToGrammarConverter → Context-Free Grammar + Analytics
```

#### 1. **LLVMFileProcessor** ⭐ (New)
- High-level file processing interface
- Handles file I/O and validation
- Generates comprehensive analytics
- Calculates fuzzing readiness scores
- Provides detailed metrics and interpretations

#### 2. **LLVMIRParser**
- Parses LLVM-IR text input
- Extracts function definitions
- Builds Control Flow Graphs
- Identifies basic blocks and control flow edges

#### 3. **ControlFlowGraph**
- Represents program structure as nodes (basic blocks) and edges (control flow)
- Tracks predecessors and successors for each block
- Identifies entry points and exit blocks

#### 4. **CFGToGrammarConverter**
- Converts CFG structure to grammar rules
- Generates choice points for conditional flows
- Detects and handles loop patterns
- Creates instruction sequence rules

#### 5. **ContextFreeGrammar**
- Stores production rules, terminals, and non-terminals
- Provides grammar analysis capabilities
- Optimized for fuzzing applications

#### 6. **GrammarAnalytics** ⭐ (New)
- Comprehensive analytics engine
- Calculates complexity metrics
- Identifies control flow patterns
- Provides fuzzing optimization insights

## 🔄 Code Flow

### 1. Parsing Phase
```python
parser = LLVMIRParser()
function_cfgs = parser.parse_llvm_ir(llvm_code)
```

**Process:**
- Split input into individual functions
- Parse each function into basic blocks
- Identify control flow edges (branches, jumps)
- Build CFG representation

### 2. Analysis Phase
```python
converter = CFGToGrammarConverter()
```

**Process:**
- Analyze CFG structure
- Detect loop headers using back-edge analysis
- Identify choice points (conditional branches)
- Map instructions to abstract terminals

### 3. Grammar Generation Phase
```python
grammar = converter.convert_cfg_to_grammar(cfg, func_name)
```

**Process:**
- Generate block content rules
- Create transition rules for control flow
- Add choice points for fuzzing exploration
- Generate loop and alternative path rules

## 📝 Grammar Structure

### Generated Rule Types

#### **Block Rules**
```
FUNC_EXAMPLE -> BLOCK_ENTRY
BLOCK_ENTRY -> INSTRUCTION_SEQ
```

#### **Choice Points (Critical for Fuzzing)**
```
CHOICE_POINT -> BLOCK_IF_TRUE
CHOICE_POINT -> BLOCK_IF_FALSE
CHOICE_POINT -> BLOCK_IF_TRUE BLOCK_IF_FALSE  # Alternative exploration
```

#### **Loop Patterns**
```
LOOP_HEADER -> BLOCK_HEADER
LOOP_HEADER -> BLOCK_HEADER LOOP_HEADER  # Iteration
```

#### **Instruction Sequences**
```
INSTRUCTION_SEQ -> ADD
INSTRUCTION_SEQ -> INSTRUCTION_SEQ MUL  # Sequential composition
```

#### **Path Variations**
```
OPT_BLOCK -> BLOCK_NAME     # Normal execution
OPT_BLOCK -> EPSILON        # Optional execution for fuzzing
```

## 🎯 Fuzzing Optimization Features

### Choice Points
- **Purpose**: Enable systematic exploration of different execution paths
- **Implementation**: Multiple grammar rules for each conditional branch
- **Benefit**: Comprehensive path coverage in fuzzing

### Loop Detection
- **Method**: Back-edge analysis in CFG
- **Rules Generated**: Iteration patterns and termination conditions
- **Fuzzing Value**: Tests both loop entry/exit and iteration behaviors

### Instruction Abstraction
- **LLVM Instructions**: `add`, `sub`, `mul`, `load`, `store`, `br`, etc.
- **Abstract Terminals**: `ADD`, `SUB`, `MUL`, `LOAD`, `STORE`, `BRANCH`
- **Benefit**: Higher-level grammar rules for meaningful test generation

### Alternative Paths
- **Optional Execution**: Rules with `EPSILON` alternatives
- **Interleaving**: Cross-product rules for complex flows
- **Repetition**: Additional iteration patterns for loops

## 📊 Analytics & Interpretation

The tool provides comprehensive analytics to help you understand the fuzzing potential of your LLVM-IR code. Here's what each metric means and implies:

### Core Metrics

#### **Fuzzing Readiness Score (0-10.0)**
- **What it is**: Overall assessment of how well-suited the grammar is for fuzzing
- **Scoring factors**:
  - Choice Points (0-3 pts): Critical decision points in program flow
  - Loop Patterns (0-2 pts): Iterative structures for repetition testing
  - Path Alternatives (0-2 pts): Alternative execution paths
  - Basic Block Coverage (0-2 pts): Completeness of code coverage
  - Complex Patterns (0-1 pt): Advanced control flow structures

**Interpretation:**
- **8.0-10.0**: Excellent fuzzing potential with rich control flow
- **6.0-7.9**: Good fuzzing target with multiple paths to explore
- **4.0-5.9**: Moderate complexity, suitable for basic fuzzing
- **2.0-3.9**: Limited branching, simpler fuzzing scenarios
- **0.0-1.9**: Linear code with minimal fuzzing opportunities

#### **Choice Points**
- **What it is**: Number of conditional branches where execution can take different paths
- **Why it matters**: Each choice point doubles the potential execution paths
- **Fuzzing implication**: More choice points = exponentially more test scenarios

**Example:** 4 choice points = 2⁴ = 16 possible path combinations

#### **Loop Patterns**
- **What it is**: Number of detected iterative structures (for, while, do-while loops)
- **Why it matters**: Loops can execute 0 to infinite times, creating edge cases
- **Fuzzing implication**: Test loop boundaries, early exits, and iteration counts

#### **Basic Blocks**
- **What it is**: Discrete code sections with single entry/exit points
- **Why it matters**: Indicates code complexity and coverage requirements
- **Fuzzing implication**: Each block should be reachable by fuzzing inputs

### Control Flow Patterns

The tool identifies five key control flow patterns:

1. **Sequential Execution**: Straight-line code execution
2. **Conditional Branching**: If-then-else structures
3. **Iterative Loops**: For/while loop structures  
4. **Control Flow Convergence**: Multiple paths joining at merge points
5. **Complex Flow Interleaving**: Advanced patterns with multiple interconnected paths

### Complexity Metrics

#### **Branching Factor**
- **What it is**: Average number of alternative rules per non-terminal
- **Interpretation**:
  - **< 2.0**: Simple, linear grammar
  - **2.0-4.0**: Moderate complexity with good alternatives
  - **> 4.0**: High complexity with many rule alternatives

#### **Grammar Depth**
- **What it is**: Maximum levels of rule derivation from start symbol
- **Interpretation**:
  - **1-3**: Shallow grammar, simple programs
  - **4-7**: Medium depth, typical applications
  - **8+**: Deep grammar, complex applications

#### **Path Alternatives**
- **What it is**: Total number of alternative execution paths
- **Includes**: Choice points + optional executions + repetition patterns
- **Fuzzing value**: Higher numbers indicate more comprehensive path exploration

### Example Output Analysis

```
📊 Function: complex_function
Grammar Rules: 84
Choice Points: 8
Loop Patterns: 0  
Basic Blocks: 6
Fuzzing Score: 7.0/10.0
Control Flow Patterns: Conditional Branching, Sequential Execution, Complex Flow Interleaving
Instruction Types: ADD, BRANCH, ICMP, MUL, PHI, RETURN, SUB
Branching Factor: 3.82
Grammar Depth: 6
```

**Interpretation:**
- **Excellent fuzzing target** (score 7.0/10.0) due to rich conditional branching
- **8 choice points** provide 2⁸ = 256 potential execution paths
- **High branching factor** (3.82) offers good rule alternatives for input variation
- **Medium depth** (6) indicates well-structured complexity
- **No loops** means focus on conditional path exploration rather than iteration testing
- **Complex flow interleaving** suggests sophisticated control patterns worth exploring

### Practical Fuzzing Implications

#### High Choice Points (6+ points)
- **Strategy**: Focus on input combinations that trigger different conditional paths
- **Tools**: Use constraint solvers to generate inputs reaching specific branches
- **Testing**: Verify edge cases around comparison boundaries

#### Loop Patterns Present
- **Strategy**: Test loop boundaries (0, 1, max iterations)
- **Edge cases**: Loop variable overflow, early termination conditions
- **Performance**: Monitor for infinite loops or performance degradation

#### Low Fuzzing Score (< 4.0)
- **Implication**: Limited control flow variation
- **Strategy**: Focus on input validation and data type edge cases
- **Approach**: Use property-based testing rather than path-based fuzzing

## 🧪 Testing

The tool includes comprehensive tests covering:

### Test Cases
1. **Sequential Example**: Straight-line code execution
2. **Conditional Example**: If-then-else structures
3. **Loop Example**: Iterative patterns with conditions
4. **Complex Control Flow**: Nested conditionals and multiple paths

### Test Metrics
- Grammar rule generation
- Choice point identification
- Loop pattern detection
- Instruction sequence coverage

## 🔍 Implementation Details

### LLVM-IR Parsing
- **Regex-based parsing** for function definitions and basic blocks
- **Instruction pattern matching** for control flow identification
- **Edge detection** for branches and jumps

### Control Flow Analysis
- **Depth-First Search** for back-edge detection (loops)
- **Predecessor/Successor tracking** for block relationships
- **Reachability analysis** for complex flow patterns

### Grammar Generation Strategy
- **Bottom-up approach**: Start with individual instructions
- **Compositional rules**: Build complex patterns from simple ones
- **Fuzzing-first design**: Prioritize rules useful for test generation

## 🚀 Advanced Usage

### Custom Instruction Mapping
```python
converter = CFGToGrammarConverter()
# Extend instruction abstraction
converter.instruction_abstraction['custom_op'] = 'CUSTOM_TERMINAL'
```

### Grammar Analysis
```python
# Analyze generated grammar
print(f"Start symbol: {grammar.start_symbol}")
print(f"Terminals: {grammar.terminals}")
print(f"Non-terminals: {grammar.non_terminals}")

# Count specific pattern types
choice_rules = [r for r in grammar.rules if 'CHOICE_POINT' in str(r)]
loop_rules = [r for r in grammar.rules if 'LOOP_' in str(r)]
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📚 References

- [LLVM Language Reference Manual](https://llvm.org/docs/LangRef.html)
- [Control Flow Graph Analysis](https://en.wikipedia.org/wiki/Control-flow_graph)
- [Context-Free Grammars for Fuzzing](https://www.fuzzingbook.org/html/Grammars.html)

---