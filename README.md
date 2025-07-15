# WHITEBOX-GI GRAMMAR GENERATOR

## 🎯 Project Overview

The WHITEBOX-GI GRAMMAR GENERATOR analyzes LLVM IR files to extract control-flow graphs (CFGs) and automatically infers context-free grammars that model the execution paths through functions. These grammars are specifically designed to be effective for fuzzing applications.

## 🏗️ Architecture & Core Modules

### Core Processing Pipeline (`src/`)

The project consists of five main Python modules:

#### 1. **`llvm_cfg_generator.py`** - Core Grammar Generation Engine
The heart of the system that implements the complete LLVM IR → Context-Free Grammar pipeline:

- **`LLVMIRParser`**: Streaming parser that processes LLVM IR files and recovers control structure using regex-based patterns. Handles modern LLVM IR constructs including:
  - Function definitions with various attributes
  - Basic blocks (named and numbered)
  - Terminator instructions (branches, switches, returns)
  - Exception handling constructs
  - Memory operations and data flow

- **`ControlFlowGraph`**: Adjacency-list representation of intra-procedural control flow with:
  - Basic blocks containing instruction sequences
  - Directed edges with optional condition labels
  - Entry and exit block identification
  - Support for complex control structures

- **`CFGToGrammarConverter`**: Sophisticated converter that synthesizes context-free grammars with:
  - Instruction abstraction mapping (200+ LLVM instructions → terminals)
  - Choice point generation for conditional branches
  - Loop pattern detection and encoding
  - Path alternative generation for fuzzing optimization
  - Comprehensive rule generation for all execution paths

- **`ContextFreeGrammar`**: Grammar representation with:
  - Production rules in BNF notation
  - Terminal/non-terminal classification
  - Enhanced pattern matching for symbol categorization
  - Fuzzing-oriented rule structure

#### 2. **`llvm_file_processor.py`** - High-Level File Processing & Analytics
Provides a comprehensive facade for processing LLVM IR files with detailed analytics:

- **`LLVMFileProcessor`**: Orchestrates the entire processing pipeline with error handling and validation
- **`GrammarAnalytics`**: Quantitative analysis of generated grammars including:
  - Structural metrics (rules, terminals, non-terminals)
  - Control-flow metrics (basic blocks, choice points, loops)
  - Fuzzing optimization metrics (path alternatives, repetition patterns)
  - Complexity analysis (branching factor, depth estimation)
  - Fuzzing readiness scoring (0-10 scale)

- **`FileProcessingResult`**: Comprehensive result container with success/failure tracking and aggregated metrics

#### 3. **`llvm_grammar_extractor.py`** - Lightweight Grammar Extraction
Simplified interface for extracting grammars without analytics overhead:

- **`extract_grammar_from_file()`**: Direct file-to-grammar conversion
- **`extract_single_function_grammar()`**: Target specific functions
- **`extract_grammar_from_string()`**: Process in-memory LLVM IR

#### 4. **`llvm_grammar_evaluator.py`** - Grammar Quality Assessment
Implements sophisticated evaluation metrics for grammar quality:

- **`GrammarSampler`**: Generates random sentences from grammars for testing
- **`GrammarAcceptor`**: Top-down parser with memoization for membership testing
- **Evaluation Methods**:
  - **Rule-set comparison**: Fast structural comparison
  - **Sampling-based evaluation**: Realistic precision/recall/F1 metrics
  - **Cross-grammar validation**: Compare generated vs reference grammars

#### 5. **`dot_to_bnf.py`** - DOT Graph to BNF Conversion
Utility for converting Graphviz DOT files to BNF grammars:

- **`extract_literals()`**: Extracts string literals from DOT node labels
- **`build_rules()`**: Creates BNF production rules from DOT files
- **`generate_aliases()`**: Creates symbolic aliases for readability
- **Directory tree processing**: Batch conversion of multiple DOT files

## 📁 Project Structure

```
llvm-cfg-generator/
├── src/                          # Core Python modules
│   ├── llvm_cfg_generator.py     # Main grammar generation engine
│   ├── llvm_file_processor.py    # File processing & analytics
│   ├── llvm_grammar_extractor.py # Lightweight extraction utilities
│   ├── llvm_grammar_evaluator.py # Grammar quality evaluation
│   ├── dot_to_bnf.py             # DOT to BNF conversion
│   └── llvm-cfg-ig.ipynb         # Jupyter notebook for interactive analysis
├── parsers-llvm/                 # Sample LLVM IR files
├── parsers-raw/                  # Original C source files
│   ├── src/                      # Client applications
│   ├── examples/                 # Input format examples
│   └── sample inputs/            # Test data
├── output/                       # Generated grammar dumps
```

## 🛠️ Installation & Setup

### Prerequisites
- **Python 3.8+** with pip
- **LLVM 18+** toolchain (clang, llvm-link, llvm-dis, opt)
- **Graphviz** for DOT file processing

### Local Installation
```bash
# Clone the repository
git clone <repository-url>
cd llvm-cfg-generator

# Install Python dependencies
pip install pydot

# Install LLVM toolchain (Ubuntu/Debian)
sudo apt update
sudo apt install clang llvm-tools llvm-dev
```

## Usage Examples

### Basic Grammar Generation
```python
from src.llvm_cfg_generator import llvm_ir_to_context_free_grammar

# Load and process LLVM IR file
with open('example.ll', 'r') as f:
    llvm_ir = f.read()

# Generate grammars for all functions
grammars = llvm_ir_to_context_free_grammar(llvm_ir)

# Display results
for func_name, grammar in grammars.items():
    print(f"Function: {func_name}")
    print(f"Rules: {len(grammar.rules)}")
    print(f"Terminals: {len(grammar.terminals)}")
    print(f"Non-terminals: {len(grammar.non_terminals)}")
```

### Comprehensive File Processing with Analytics
```python
from src.llvm_file_processor import process_llvm_file

# Process file with detailed analytics
result = process_llvm_file('parsers-llvm/json/cJson.ll')

if result.success:
    print(f"✅ Processed {result.functions_processed} functions")
    print(f"📊 Fuzzing score: {result.overall_fuzzing_score:.1f}/10")
    
    # Access detailed analytics
    for func_name, analytics in result.analytics.items():
        print(f"\n{func_name}:")
        print(f"  Choice points: {analytics.choice_points_count}")
        print(f"  Loop patterns: {analytics.loop_patterns_count}")
        print(f"  Fuzzing score: {analytics.fuzzing_readiness_score:.1f}/10")
else:
    print(f"❌ Error: {result.error_message}")
```

### Grammar Quality Evaluation
```python
from src.llvm_grammar_evaluator import evaluate_llvm_grammars

# Compare two LLVM IR files
precision, recall, f1 = evaluate_llvm_grammars(
    target_path='target.ll',
    reference_path='reference.ll',
    mode='sample',
    samples=1000
)

print(f"Precision: {precision:.4f}")
print(f"Recall: {recall:.4f}")
print(f"F1-Score: {f1:.4f}")
```

### Grammar Export
```python
from src.llvm_file_processor import dump_grammars_from_file

# Export grammar to text file with analytics
success = dump_grammars_from_file(
    llvm_file_path='input.ll',
    output_path='grammar_dump.txt'
)

if success:
    print("✅ Grammar exported successfully")
```

## 🔧 Command Line Usage

### Process LLVM IR Files
```bash
# Basic processing
python src/llvm_file_processor.py input.ll

# Export grammar dump
python src/llvm_file_processor.py input.ll --dump-grammar

# Custom output path
python src/llvm_file_processor.py input.ll --output-path custom_grammar.txt
```

### Extract Grammars
```bash
# Extract all functions
python src/llvm_grammar_extractor.py input.ll

# Extract specific function
python src/llvm_grammar_extractor.py input.ll function_name
```

### Evaluate Grammar Quality
```bash
# Sampling-based evaluation
python src/llvm_grammar_evaluator.py target.ll reference.ll --mode sample --samples 1000

# Rule-set comparison
python src/llvm_grammar_evaluator.py target.ll reference.ll --mode rule
```

### Convert DOT to BNF
```bash
# Convert DOT files to BNF grammar
python src/dot_to_bnf.py /path/to/dot/files -o output.bnf --alias
```

## 📊 Sample Output

### Grammar Analytics Example
```
Grammar Analytics for cJSON_Parse:
========================================

Basic Metrics:
- Production Rules: 487
- Non-terminals: 89
- Terminals: 67
- Start Symbol: FUNC_CJSON_PARSE

Control Flow Coverage:
- Basic Blocks: 23
- Choice Points: 18
- Loop Patterns: 5
- Instruction Sequences: 31

Fuzzing Optimization:
- Path Alternatives: 42
- Optional Executions: 12
- Repetition Patterns: 8
- Interleaving Rules: 15
- Merge Points: 7

Complexity Analysis:
- Max Rule Length: 8
- Avg Rule Length: 3.24
- Branching Factor: 5.47
- Estimated Depth: 12

Fuzzing Readiness Score: 8.5/10.0
```

### Generated Grammar Rules Example
```
FUNC_CJSON_PARSE -> BLOCK_ENTRY
BLOCK_ENTRY -> INSTRUCTION_SEQ CHOICE_POINT
CHOICE_POINT -> BLOCK_IF_NULL | BLOCK_IF_NOT_NULL
BLOCK_IF_NULL -> RETURN
BLOCK_IF_NOT_NULL -> LOAD CALL STORE BLOCK_LOOP_CHECK
LOOP_CHECK -> CHOICE_POINT
CHOICE_POINT -> BLOCK_LOOP_BODY | BLOCK_LOOP_EXIT
BLOCK_LOOP_BODY -> INSTRUCTION_SEQ BLOCK_LOOP_CHECK
```

## 📄 License

This project is part of ongoing research in automated program analysis and fuzzing. Please cite appropriately if used in academic work.

---

*This tool represents a sophisticated approach to bridging static program analysis and dynamic testing through automated grammar generation from compiled code representations.* 
