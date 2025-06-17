; Example LLVM-IR file for demonstrating the CFG grammar generator
; This file contains functions with different control flow patterns

define i32 @simple_function(i32 %x) {
entry:
    %result = add i32 %x, 42
    ret i32 %result
}

define i32 @conditional_function(i32 %a, i32 %b) {
entry:
    %cmp = icmp sgt i32 %a, %b
    br i1 %cmp, label %if_greater, label %if_less_equal

if_greater:
    %result1 = mul i32 %a, 2
    br label %end

if_less_equal:
    %result2 = add i32 %a, %b
    br label %end

end:
    %final = phi i32 [%result1, %if_greater], [%result2, %if_less_equal]
    ret i32 %final
}

define i32 @loop_function(i32 %n) {
entry:
    %sum = alloca i32
    store i32 0, i32* %sum
    %i = alloca i32
    store i32 0, i32* %i
    br label %loop_check

loop_check:
    %current_i = load i32, i32* %i
    %cmp = icmp slt i32 %current_i, %n
    br i1 %cmp, label %loop_body, label %loop_exit

loop_body:
    %current_sum = load i32, i32* %sum
    %new_sum = add i32 %current_sum, %current_i
    store i32 %new_sum, i32* %sum
    %next_i = add i32 %current_i, 1
    store i32 %next_i, i32* %i
    br label %loop_check

loop_exit:
    %final_sum = load i32, i32* %sum
    ret i32 %final_sum
} 