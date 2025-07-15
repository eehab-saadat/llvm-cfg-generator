"""
LLVM Grammar Extractor

Simple utility to extract raw context-free grammars from LLVM-IR files
without analytics or formatting - just the pure grammar rules.
"""

import os
from typing import Dict, List, Optional
from llvm_cfg_generator import llvm_ir_to_context_free_grammar, ContextFreeGrammar

def extract_grammar_from_file(llvm_file_path: str) -> Dict[str, ContextFreeGrammar]:
    """High-level helper that loads *llvm_file_path* and converts it into
    grammars using the core pipeline from :pymod:`llvm_cfg_generator`.

    This is the *lowest* layer in the extractor module; every other utility
    eventually calls it.
    """
    
    # Validate file exists
    if not os.path.exists(llvm_file_path):
        raise FileNotFoundError(f"LLVM-IR file not found: {llvm_file_path}")
    
    try:
        # Read file content
        with open(llvm_file_path, 'r', encoding='utf-8') as f:
            llvm_ir_content = f.read()
        
        # Generate grammars
        grammars = llvm_ir_to_context_free_grammar(llvm_ir_content)
        
        if not grammars:
            raise ValueError("No functions found in LLVM-IR file")
        
        return grammars
        
    except IOError as e:
        raise IOError(f"Error reading file {llvm_file_path}: {e}")
    except Exception as e:
        raise ValueError(f"Error processing LLVM-IR: {e}")

def extract_single_function_grammar(llvm_file_path: str, function_name: str) -> Optional[ContextFreeGrammar]:
    """Thin convenience wrapper around :pyfunc:`extract_grammar_from_file`.

    It simply returns ``grammars.get(function_name)`` so that callers do not
    have to perform the dictionary look-up in two lines of code.
    """
    
    grammars = extract_grammar_from_file(llvm_file_path)
    return grammars.get(function_name)

def extract_grammar_from_string(llvm_ir_code: str) -> Dict[str, ContextFreeGrammar]:
    """Like :pyfunc:`extract_grammar_from_file` but works on an in-memory
    string instead of reading from disk.
    """
    
    if not llvm_ir_code or not llvm_ir_code.strip():
        raise ValueError("Empty LLVM-IR code provided")
    
    try:
        grammars = llvm_ir_to_context_free_grammar(llvm_ir_code)
        
        if not grammars:
            raise ValueError("No functions found in LLVM-IR code")
        
        return grammars
        
    except Exception as e:
        raise ValueError(f"Error processing LLVM-IR: {e}")

if __name__ == "__main__":
    # Example usage
    import sys
    
    if len(sys.argv) < 2:
        print("Usage: python llvm_grammar_extractor.py <llvm_file_path> [function_name]")
        sys.exit(1)
    
    file_path = sys.argv[1]
    function_name = sys.argv[2] if len(sys.argv) > 2 else None
    
    try:
        if function_name:
            # Extract specific function
            grammar = extract_single_function_grammar(file_path, function_name)
            if grammar:
                print(f"Grammar for function '{function_name}':")
                print(grammar)
            else:
                print(f"Function '{function_name}' not found in file")
        else:
            # Extract all functions
            grammars = extract_grammar_from_file(file_path)
            for func_name, grammar in grammars.items():
                print(f"Grammar for function '{func_name}':")
                print(grammar)
                print("\n" + "="*50 + "\n")
                
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1) 