# Default C sources (override on the command-line: make SRC="file1.c file2.c")
SRC ?= $(wildcard *.c)

# Output base name (override with: make OUT=myprog)
OUT ?= final

# Derived file names
BC_FILES := $(SRC:.c=.bc)
BC_LINK  := $(OUT).bc
LL_FILE  := $(OUT).ll

# Tools (override if needed)
CLANG    ?= clang
LLVM_LINK?= llvm-link
LLVM_DIS ?= llvm-dis
OPT      ?= opt

.PHONY: all cfg clean

# Build everything by default
all: $(LL_FILE)

# Rule: .c -> .bc
%.bc: %.c
	$(CLANG) -emit-llvm -c $< -o $@

# Link all .bc into one bitcode module
$(BC_LINK): $(BC_FILES)
	$(LLVM_LINK) $^ -o $@

# Convert linked bitcode to human-readable LLVM IR
$(LL_FILE): $(BC_LINK)
	$(LLVM_DIS) $< -o $@

# Generate control-flow graph (CFG) DOT files from the LLVM IR
cfg: $(LL_FILE)
	$(OPT) -disable-output -print-module-scope -passes="dot-cfg" $<

# Remove generated files
clean:
	rm -f $(BC_FILES) $(BC_LINK) $(LL_FILE) *.dot 