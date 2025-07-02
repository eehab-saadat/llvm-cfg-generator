; ModuleID = 'inih.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.ini_data_t = type { [100 x i8], i32, [50 x i8], i32 }
%struct.ini_parse_string_ctx = type { ptr, i64 }

@.str = private unnamed_addr constant [71 x i8] c"[User]\0Aname = Alice\0Aage = 30\0A\0A[Settings]\0Atheme = dark\0Aautosave = true\0A\00", align 1
@.str.1 = private unnamed_addr constant [5 x i8] c"User\00", align 1
@.str.2 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@.str.3 = private unnamed_addr constant [4 x i8] c"age\00", align 1
@.str.4 = private unnamed_addr constant [9 x i8] c"Settings\00", align 1
@.str.5 = private unnamed_addr constant [6 x i8] c"theme\00", align 1
@.str.6 = private unnamed_addr constant [9 x i8] c"autosave\00", align 1
@.str.7 = private unnamed_addr constant [5 x i8] c"true\00", align 1
@.str.8 = private unnamed_addr constant [3 x i8] c";#\00", align 1
@.str.1.9 = private unnamed_addr constant [2 x i8] c"]\00", align 1
@.str.2.10 = private unnamed_addr constant [3 x i8] c"=:\00", align 1
@.str.3.12 = private unnamed_addr constant [2 x i8] c"r\00", align 1
@.str.4.11 = private unnamed_addr constant [2 x i8] c";\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca %struct.ini_data_t, align 4
  %4 = alloca ptr, align 8
  %5 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  store ptr @.str, ptr %2, align 8
  call void @llvm.memset.p0.i64(ptr align 4 %3, i8 0, i64 160, i1 false)
  %6 = load ptr, ptr %2, align 8
  store ptr %6, ptr %4, align 8
  %7 = call i32 @ini_parse_stream(ptr noundef @string_reader, ptr noundef %4, ptr noundef @my_ini_handler, ptr noundef %3)
  store i32 %7, ptr %5, align 4
  %8 = load i32, ptr %5, align 4
  %9 = icmp eq i32 %8, 0
  br i1 %9, label %10, label %33

10:                                               ; preds = %0
  %11 = getelementptr inbounds %struct.ini_data_t, ptr %3, i32 0, i32 0
  %12 = getelementptr inbounds [100 x i8], ptr %11, i64 0, i64 0
  %13 = load i8, ptr %12, align 4
  %14 = icmp ne i8 %13, 0
  br i1 %14, label %15, label %16

15:                                               ; preds = %10
  br label %16

16:                                               ; preds = %15, %10
  %17 = getelementptr inbounds %struct.ini_data_t, ptr %3, i32 0, i32 1
  %18 = load i32, ptr %17, align 4
  %19 = icmp sgt i32 %18, 0
  br i1 %19, label %20, label %21

20:                                               ; preds = %16
  br label %21

21:                                               ; preds = %20, %16
  %22 = getelementptr inbounds %struct.ini_data_t, ptr %3, i32 0, i32 2
  %23 = getelementptr inbounds [50 x i8], ptr %22, i64 0, i64 0
  %24 = load i8, ptr %23, align 4
  %25 = icmp ne i8 %24, 0
  br i1 %25, label %26, label %27

26:                                               ; preds = %21
  br label %27

27:                                               ; preds = %26, %21
  %28 = getelementptr inbounds %struct.ini_data_t, ptr %3, i32 0, i32 3
  %29 = load i32, ptr %28, align 4
  %30 = icmp ne i32 %29, 0
  br i1 %30, label %31, label %32

31:                                               ; preds = %27
  br label %32

32:                                               ; preds = %31, %27
  br label %33

33:                                               ; preds = %32, %0
  ret i32 0
}

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg) #1

; Function Attrs: noinline nounwind optnone uwtable
define internal ptr @string_reader(ptr noundef %0, i32 noundef %1, ptr noundef %2) #0 {
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  %9 = alloca i32, align 4
  store ptr %0, ptr %5, align 8
  store i32 %1, ptr %6, align 4
  store ptr %2, ptr %7, align 8
  %10 = load ptr, ptr %7, align 8
  store ptr %10, ptr %8, align 8
  %11 = load ptr, ptr %8, align 8
  %12 = load ptr, ptr %11, align 8
  %13 = icmp ne ptr %12, null
  br i1 %13, label %14, label %17

14:                                               ; preds = %3
  %15 = load i32, ptr %6, align 4
  %16 = icmp sle i32 %15, 1
  br i1 %16, label %17, label %18

17:                                               ; preds = %14, %3
  store ptr null, ptr %4, align 8
  br label %85

18:                                               ; preds = %14
  store i32 0, ptr %9, align 4
  br label %19

19:                                               ; preds = %44, %18
  %20 = load i32, ptr %9, align 4
  %21 = load i32, ptr %6, align 4
  %22 = sub nsw i32 %21, 1
  %23 = icmp slt i32 %20, %22
  br i1 %23, label %24, label %42

24:                                               ; preds = %19
  %25 = load ptr, ptr %8, align 8
  %26 = load ptr, ptr %25, align 8
  %27 = load i32, ptr %9, align 4
  %28 = sext i32 %27 to i64
  %29 = getelementptr inbounds i8, ptr %26, i64 %28
  %30 = load i8, ptr %29, align 1
  %31 = sext i8 %30 to i32
  %32 = icmp ne i32 %31, 0
  br i1 %32, label %33, label %42

33:                                               ; preds = %24
  %34 = load ptr, ptr %8, align 8
  %35 = load ptr, ptr %34, align 8
  %36 = load i32, ptr %9, align 4
  %37 = sext i32 %36 to i64
  %38 = getelementptr inbounds i8, ptr %35, i64 %37
  %39 = load i8, ptr %38, align 1
  %40 = sext i8 %39 to i32
  %41 = icmp ne i32 %40, 10
  br label %42

42:                                               ; preds = %33, %24, %19
  %43 = phi i1 [ false, %24 ], [ false, %19 ], [ %41, %33 ]
  br i1 %43, label %44, label %57

44:                                               ; preds = %42
  %45 = load ptr, ptr %8, align 8
  %46 = load ptr, ptr %45, align 8
  %47 = load i32, ptr %9, align 4
  %48 = sext i32 %47 to i64
  %49 = getelementptr inbounds i8, ptr %46, i64 %48
  %50 = load i8, ptr %49, align 1
  %51 = load ptr, ptr %5, align 8
  %52 = load i32, ptr %9, align 4
  %53 = sext i32 %52 to i64
  %54 = getelementptr inbounds i8, ptr %51, i64 %53
  store i8 %50, ptr %54, align 1
  %55 = load i32, ptr %9, align 4
  %56 = add nsw i32 %55, 1
  store i32 %56, ptr %9, align 4
  br label %19, !llvm.loop !6

57:                                               ; preds = %42
  %58 = load ptr, ptr %5, align 8
  %59 = load i32, ptr %9, align 4
  %60 = sext i32 %59 to i64
  %61 = getelementptr inbounds i8, ptr %58, i64 %60
  store i8 0, ptr %61, align 1
  %62 = load ptr, ptr %8, align 8
  %63 = load ptr, ptr %62, align 8
  %64 = load i32, ptr %9, align 4
  %65 = sext i32 %64 to i64
  %66 = getelementptr inbounds i8, ptr %63, i64 %65
  %67 = load i8, ptr %66, align 1
  %68 = sext i8 %67 to i32
  %69 = icmp eq i32 %68, 10
  br i1 %69, label %70, label %77

70:                                               ; preds = %57
  %71 = load i32, ptr %9, align 4
  %72 = add nsw i32 %71, 1
  %73 = load ptr, ptr %8, align 8
  %74 = load ptr, ptr %73, align 8
  %75 = sext i32 %72 to i64
  %76 = getelementptr inbounds i8, ptr %74, i64 %75
  store ptr %76, ptr %73, align 8
  br label %83

77:                                               ; preds = %57
  %78 = load i32, ptr %9, align 4
  %79 = load ptr, ptr %8, align 8
  %80 = load ptr, ptr %79, align 8
  %81 = sext i32 %78 to i64
  %82 = getelementptr inbounds i8, ptr %80, i64 %81
  store ptr %82, ptr %79, align 8
  br label %83

83:                                               ; preds = %77, %70
  %84 = load ptr, ptr %5, align 8
  store ptr %84, ptr %4, align 8
  br label %85

85:                                               ; preds = %83, %17
  %86 = load ptr, ptr %4, align 8
  ret ptr %86
}

; Function Attrs: noinline nounwind optnone uwtable
define internal i32 @my_ini_handler(ptr noundef %0, ptr noundef %1, ptr noundef %2, ptr noundef %3) #0 {
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  %9 = alloca ptr, align 8
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  store ptr %0, ptr %5, align 8
  store ptr %1, ptr %6, align 8
  store ptr %2, ptr %7, align 8
  store ptr %3, ptr %8, align 8
  %13 = load ptr, ptr %5, align 8
  store ptr %13, ptr %9, align 8
  %14 = load ptr, ptr %6, align 8
  %15 = call i32 @strcmp_custom(ptr noundef %14, ptr noundef @.str.1)
  %16 = icmp eq i32 %15, 0
  br i1 %16, label %17, label %100

17:                                               ; preds = %4
  %18 = load ptr, ptr %7, align 8
  %19 = call i32 @strcmp_custom(ptr noundef %18, ptr noundef @.str.2)
  %20 = icmp eq i32 %19, 0
  br i1 %20, label %21, label %55

21:                                               ; preds = %17
  store i32 0, ptr %10, align 4
  br label %22

22:                                               ; preds = %46, %21
  %23 = load ptr, ptr %8, align 8
  %24 = load i32, ptr %10, align 4
  %25 = sext i32 %24 to i64
  %26 = getelementptr inbounds i8, ptr %23, i64 %25
  %27 = load i8, ptr %26, align 1
  %28 = sext i8 %27 to i32
  %29 = icmp ne i32 %28, 0
  br i1 %29, label %30, label %33

30:                                               ; preds = %22
  %31 = load i32, ptr %10, align 4
  %32 = icmp slt i32 %31, 99
  br label %33

33:                                               ; preds = %30, %22
  %34 = phi i1 [ false, %22 ], [ %32, %30 ]
  br i1 %34, label %35, label %49

35:                                               ; preds = %33
  %36 = load ptr, ptr %8, align 8
  %37 = load i32, ptr %10, align 4
  %38 = sext i32 %37 to i64
  %39 = getelementptr inbounds i8, ptr %36, i64 %38
  %40 = load i8, ptr %39, align 1
  %41 = load ptr, ptr %9, align 8
  %42 = getelementptr inbounds %struct.ini_data_t, ptr %41, i32 0, i32 0
  %43 = load i32, ptr %10, align 4
  %44 = sext i32 %43 to i64
  %45 = getelementptr inbounds [100 x i8], ptr %42, i64 0, i64 %44
  store i8 %40, ptr %45, align 1
  br label %46

46:                                               ; preds = %35
  %47 = load i32, ptr %10, align 4
  %48 = add nsw i32 %47, 1
  store i32 %48, ptr %10, align 4
  br label %22, !llvm.loop !8

49:                                               ; preds = %33
  %50 = load ptr, ptr %9, align 8
  %51 = getelementptr inbounds %struct.ini_data_t, ptr %50, i32 0, i32 0
  %52 = load i32, ptr %10, align 4
  %53 = sext i32 %52 to i64
  %54 = getelementptr inbounds [100 x i8], ptr %51, i64 0, i64 %53
  store i8 0, ptr %54, align 1
  br label %99

55:                                               ; preds = %17
  %56 = load ptr, ptr %7, align 8
  %57 = call i32 @strcmp_custom(ptr noundef %56, ptr noundef @.str.3)
  %58 = icmp eq i32 %57, 0
  br i1 %58, label %59, label %98

59:                                               ; preds = %55
  %60 = load ptr, ptr %9, align 8
  %61 = getelementptr inbounds %struct.ini_data_t, ptr %60, i32 0, i32 1
  store i32 0, ptr %61, align 4
  store i32 0, ptr %11, align 4
  br label %62

62:                                               ; preds = %80, %59
  %63 = load ptr, ptr %8, align 8
  %64 = load i32, ptr %11, align 4
  %65 = sext i32 %64 to i64
  %66 = getelementptr inbounds i8, ptr %63, i64 %65
  %67 = load i8, ptr %66, align 1
  %68 = sext i8 %67 to i32
  %69 = icmp sge i32 %68, 48
  br i1 %69, label %70, label %78

70:                                               ; preds = %62
  %71 = load ptr, ptr %8, align 8
  %72 = load i32, ptr %11, align 4
  %73 = sext i32 %72 to i64
  %74 = getelementptr inbounds i8, ptr %71, i64 %73
  %75 = load i8, ptr %74, align 1
  %76 = sext i8 %75 to i32
  %77 = icmp sle i32 %76, 57
  br label %78

78:                                               ; preds = %70, %62
  %79 = phi i1 [ false, %62 ], [ %77, %70 ]
  br i1 %79, label %80, label %97

80:                                               ; preds = %78
  %81 = load ptr, ptr %9, align 8
  %82 = getelementptr inbounds %struct.ini_data_t, ptr %81, i32 0, i32 1
  %83 = load i32, ptr %82, align 4
  %84 = mul nsw i32 %83, 10
  %85 = load ptr, ptr %8, align 8
  %86 = load i32, ptr %11, align 4
  %87 = sext i32 %86 to i64
  %88 = getelementptr inbounds i8, ptr %85, i64 %87
  %89 = load i8, ptr %88, align 1
  %90 = sext i8 %89 to i32
  %91 = sub nsw i32 %90, 48
  %92 = add nsw i32 %84, %91
  %93 = load ptr, ptr %9, align 8
  %94 = getelementptr inbounds %struct.ini_data_t, ptr %93, i32 0, i32 1
  store i32 %92, ptr %94, align 4
  %95 = load i32, ptr %11, align 4
  %96 = add nsw i32 %95, 1
  store i32 %96, ptr %11, align 4
  br label %62, !llvm.loop !9

97:                                               ; preds = %78
  br label %98

98:                                               ; preds = %97, %55
  br label %99

99:                                               ; preds = %98, %49
  br label %157

100:                                              ; preds = %4
  %101 = load ptr, ptr %6, align 8
  %102 = call i32 @strcmp_custom(ptr noundef %101, ptr noundef @.str.4)
  %103 = icmp eq i32 %102, 0
  br i1 %103, label %104, label %156

104:                                              ; preds = %100
  %105 = load ptr, ptr %7, align 8
  %106 = call i32 @strcmp_custom(ptr noundef %105, ptr noundef @.str.5)
  %107 = icmp eq i32 %106, 0
  br i1 %107, label %108, label %142

108:                                              ; preds = %104
  store i32 0, ptr %12, align 4
  br label %109

109:                                              ; preds = %133, %108
  %110 = load ptr, ptr %8, align 8
  %111 = load i32, ptr %12, align 4
  %112 = sext i32 %111 to i64
  %113 = getelementptr inbounds i8, ptr %110, i64 %112
  %114 = load i8, ptr %113, align 1
  %115 = sext i8 %114 to i32
  %116 = icmp ne i32 %115, 0
  br i1 %116, label %117, label %120

117:                                              ; preds = %109
  %118 = load i32, ptr %12, align 4
  %119 = icmp slt i32 %118, 49
  br label %120

120:                                              ; preds = %117, %109
  %121 = phi i1 [ false, %109 ], [ %119, %117 ]
  br i1 %121, label %122, label %136

122:                                              ; preds = %120
  %123 = load ptr, ptr %8, align 8
  %124 = load i32, ptr %12, align 4
  %125 = sext i32 %124 to i64
  %126 = getelementptr inbounds i8, ptr %123, i64 %125
  %127 = load i8, ptr %126, align 1
  %128 = load ptr, ptr %9, align 8
  %129 = getelementptr inbounds %struct.ini_data_t, ptr %128, i32 0, i32 2
  %130 = load i32, ptr %12, align 4
  %131 = sext i32 %130 to i64
  %132 = getelementptr inbounds [50 x i8], ptr %129, i64 0, i64 %131
  store i8 %127, ptr %132, align 1
  br label %133

133:                                              ; preds = %122
  %134 = load i32, ptr %12, align 4
  %135 = add nsw i32 %134, 1
  store i32 %135, ptr %12, align 4
  br label %109, !llvm.loop !10

136:                                              ; preds = %120
  %137 = load ptr, ptr %9, align 8
  %138 = getelementptr inbounds %struct.ini_data_t, ptr %137, i32 0, i32 2
  %139 = load i32, ptr %12, align 4
  %140 = sext i32 %139 to i64
  %141 = getelementptr inbounds [50 x i8], ptr %138, i64 0, i64 %140
  store i8 0, ptr %141, align 1
  br label %155

142:                                              ; preds = %104
  %143 = load ptr, ptr %7, align 8
  %144 = call i32 @strcmp_custom(ptr noundef %143, ptr noundef @.str.6)
  %145 = icmp eq i32 %144, 0
  br i1 %145, label %146, label %154

146:                                              ; preds = %142
  %147 = load ptr, ptr %8, align 8
  %148 = call i32 @strcmp_custom(ptr noundef %147, ptr noundef @.str.7)
  %149 = icmp eq i32 %148, 0
  %150 = zext i1 %149 to i64
  %151 = select i1 %149, i32 1, i32 0
  %152 = load ptr, ptr %9, align 8
  %153 = getelementptr inbounds %struct.ini_data_t, ptr %152, i32 0, i32 3
  store i32 %151, ptr %153, align 4
  br label %154

154:                                              ; preds = %146, %142
  br label %155

155:                                              ; preds = %154, %136
  br label %156

156:                                              ; preds = %155, %100
  br label %157

157:                                              ; preds = %156, %99
  ret i32 1
}

; Function Attrs: noinline nounwind optnone uwtable
define internal i32 @strcmp_custom(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  br label %5

5:                                                ; preds = %25, %2
  %6 = load ptr, ptr %3, align 8
  %7 = load i8, ptr %6, align 1
  %8 = sext i8 %7 to i32
  %9 = icmp ne i32 %8, 0
  br i1 %9, label %10, label %23

10:                                               ; preds = %5
  %11 = load ptr, ptr %4, align 8
  %12 = load i8, ptr %11, align 1
  %13 = sext i8 %12 to i32
  %14 = icmp ne i32 %13, 0
  br i1 %14, label %15, label %23

15:                                               ; preds = %10
  %16 = load ptr, ptr %3, align 8
  %17 = load i8, ptr %16, align 1
  %18 = sext i8 %17 to i32
  %19 = load ptr, ptr %4, align 8
  %20 = load i8, ptr %19, align 1
  %21 = sext i8 %20 to i32
  %22 = icmp eq i32 %18, %21
  br label %23

23:                                               ; preds = %15, %10, %5
  %24 = phi i1 [ false, %10 ], [ false, %5 ], [ %22, %15 ]
  br i1 %24, label %25, label %30

25:                                               ; preds = %23
  %26 = load ptr, ptr %3, align 8
  %27 = getelementptr inbounds i8, ptr %26, i32 1
  store ptr %27, ptr %3, align 8
  %28 = load ptr, ptr %4, align 8
  %29 = getelementptr inbounds i8, ptr %28, i32 1
  store ptr %29, ptr %4, align 8
  br label %5, !llvm.loop !11

30:                                               ; preds = %23
  %31 = load ptr, ptr %3, align 8
  %32 = load i8, ptr %31, align 1
  %33 = sext i8 %32 to i32
  %34 = load ptr, ptr %4, align 8
  %35 = load i8, ptr %34, align 1
  %36 = sext i8 %35 to i32
  %37 = sub nsw i32 %33, %36
  ret i32 %37
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @ini_parse_stream(ptr noundef %0, ptr noundef %1, ptr noundef %2, ptr noundef %3) #0 {
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  %9 = alloca [200 x i8], align 16
  %10 = alloca i64, align 8
  %11 = alloca [50 x i8], align 16
  %12 = alloca [50 x i8], align 16
  %13 = alloca i64, align 8
  %14 = alloca ptr, align 8
  %15 = alloca ptr, align 8
  %16 = alloca ptr, align 8
  %17 = alloca ptr, align 8
  %18 = alloca i32, align 4
  %19 = alloca i32, align 4
  %20 = alloca [16 x i8], align 16
  store ptr %0, ptr %5, align 8
  store ptr %1, ptr %6, align 8
  store ptr %2, ptr %7, align 8
  store ptr %3, ptr %8, align 8
  store i64 200, ptr %10, align 8
  call void @llvm.memset.p0.i64(ptr align 16 %11, i8 0, i64 50, i1 false)
  call void @llvm.memset.p0.i64(ptr align 16 %12, i8 0, i64 50, i1 false)
  store i32 0, ptr %18, align 4
  store i32 0, ptr %19, align 4
  br label %21

21:                                               ; preds = %228, %4
  %22 = load ptr, ptr %5, align 8
  %23 = getelementptr inbounds [200 x i8], ptr %9, i64 0, i64 0
  %24 = load i64, ptr %10, align 8
  %25 = trunc i64 %24 to i32
  %26 = load ptr, ptr %6, align 8
  %27 = call ptr %22(ptr noundef %23, i32 noundef %25, ptr noundef %26)
  %28 = icmp ne ptr %27, null
  br i1 %28, label %29, label %229

29:                                               ; preds = %21
  %30 = getelementptr inbounds [200 x i8], ptr %9, i64 0, i64 0
  %31 = call i64 @strlen(ptr noundef %30) #5
  store i64 %31, ptr %13, align 8
  %32 = load i32, ptr %18, align 4
  %33 = add nsw i32 %32, 1
  store i32 %33, ptr %18, align 4
  %34 = load i64, ptr %13, align 8
  %35 = load i64, ptr %10, align 8
  %36 = sub i64 %35, 1
  %37 = icmp eq i64 %34, %36
  br i1 %37, label %38, label %68

38:                                               ; preds = %29
  %39 = load i64, ptr %13, align 8
  %40 = sub i64 %39, 1
  %41 = getelementptr inbounds [200 x i8], ptr %9, i64 0, i64 %40
  %42 = load i8, ptr %41, align 1
  %43 = sext i8 %42 to i32
  %44 = icmp ne i32 %43, 10
  br i1 %44, label %45, label %68

45:                                               ; preds = %38
  br label %46

46:                                               ; preds = %66, %45
  %47 = load ptr, ptr %5, align 8
  %48 = getelementptr inbounds [16 x i8], ptr %20, i64 0, i64 0
  %49 = load ptr, ptr %6, align 8
  %50 = call ptr %47(ptr noundef %48, i32 noundef 16, ptr noundef %49)
  %51 = icmp ne ptr %50, null
  br i1 %51, label %52, label %67

52:                                               ; preds = %46
  %53 = load i32, ptr %19, align 4
  %54 = icmp ne i32 %53, 0
  br i1 %54, label %57, label %55

55:                                               ; preds = %52
  %56 = load i32, ptr %18, align 4
  store i32 %56, ptr %19, align 4
  br label %57

57:                                               ; preds = %55, %52
  %58 = getelementptr inbounds [16 x i8], ptr %20, i64 0, i64 0
  %59 = call i64 @strlen(ptr noundef %58) #5
  %60 = sub i64 %59, 1
  %61 = getelementptr inbounds [16 x i8], ptr %20, i64 0, i64 %60
  %62 = load i8, ptr %61, align 1
  %63 = sext i8 %62 to i32
  %64 = icmp eq i32 %63, 10
  br i1 %64, label %65, label %66

65:                                               ; preds = %57
  br label %67

66:                                               ; preds = %57
  br label %46, !llvm.loop !12

67:                                               ; preds = %65, %46
  br label %68

68:                                               ; preds = %67, %38, %29
  %69 = getelementptr inbounds [200 x i8], ptr %9, i64 0, i64 0
  store ptr %69, ptr %14, align 8
  %70 = load i32, ptr %18, align 4
  %71 = icmp eq i32 %70, 1
  br i1 %71, label %72, label %93

72:                                               ; preds = %68
  %73 = load ptr, ptr %14, align 8
  %74 = getelementptr inbounds i8, ptr %73, i64 0
  %75 = load i8, ptr %74, align 1
  %76 = zext i8 %75 to i32
  %77 = icmp eq i32 %76, 239
  br i1 %77, label %78, label %93

78:                                               ; preds = %72
  %79 = load ptr, ptr %14, align 8
  %80 = getelementptr inbounds i8, ptr %79, i64 1
  %81 = load i8, ptr %80, align 1
  %82 = zext i8 %81 to i32
  %83 = icmp eq i32 %82, 187
  br i1 %83, label %84, label %93

84:                                               ; preds = %78
  %85 = load ptr, ptr %14, align 8
  %86 = getelementptr inbounds i8, ptr %85, i64 2
  %87 = load i8, ptr %86, align 1
  %88 = zext i8 %87 to i32
  %89 = icmp eq i32 %88, 191
  br i1 %89, label %90, label %93

90:                                               ; preds = %84
  %91 = load ptr, ptr %14, align 8
  %92 = getelementptr inbounds i8, ptr %91, i64 3
  store ptr %92, ptr %14, align 8
  br label %93

93:                                               ; preds = %90, %84, %78, %72, %68
  %94 = load ptr, ptr %14, align 8
  %95 = call ptr @ini_lskip(ptr noundef %94)
  %96 = call ptr @ini_rstrip(ptr noundef %95)
  store ptr %96, ptr %14, align 8
  %97 = load ptr, ptr %14, align 8
  %98 = load i8, ptr %97, align 1
  %99 = sext i8 %98 to i32
  %100 = call ptr @strchr(ptr noundef @.str.8, i32 noundef %99) #5
  %101 = icmp ne ptr %100, null
  br i1 %101, label %102, label %103

102:                                              ; preds = %93
  br label %228

103:                                              ; preds = %93
  %104 = getelementptr inbounds [50 x i8], ptr %12, i64 0, i64 0
  %105 = load i8, ptr %104, align 16
  %106 = sext i8 %105 to i32
  %107 = icmp ne i32 %106, 0
  br i1 %107, label %108, label %141

108:                                              ; preds = %103
  %109 = load ptr, ptr %14, align 8
  %110 = load i8, ptr %109, align 1
  %111 = sext i8 %110 to i32
  %112 = icmp ne i32 %111, 0
  br i1 %112, label %113, label %141

113:                                              ; preds = %108
  %114 = load ptr, ptr %14, align 8
  %115 = getelementptr inbounds [200 x i8], ptr %9, i64 0, i64 0
  %116 = icmp ugt ptr %114, %115
  br i1 %116, label %117, label %141

117:                                              ; preds = %113
  %118 = load ptr, ptr %14, align 8
  %119 = call ptr @ini_find_chars_or_comment(ptr noundef %118, ptr noundef null)
  store ptr %119, ptr %15, align 8
  %120 = load ptr, ptr %15, align 8
  %121 = load i8, ptr %120, align 1
  %122 = icmp ne i8 %121, 0
  br i1 %122, label %123, label %125

123:                                              ; preds = %117
  %124 = load ptr, ptr %15, align 8
  store i8 0, ptr %124, align 1
  br label %125

125:                                              ; preds = %123, %117
  %126 = load ptr, ptr %14, align 8
  %127 = call ptr @ini_rstrip(ptr noundef %126)
  %128 = load ptr, ptr %7, align 8
  %129 = load ptr, ptr %8, align 8
  %130 = getelementptr inbounds [50 x i8], ptr %11, i64 0, i64 0
  %131 = getelementptr inbounds [50 x i8], ptr %12, i64 0, i64 0
  %132 = load ptr, ptr %14, align 8
  %133 = call i32 %128(ptr noundef %129, ptr noundef %130, ptr noundef %131, ptr noundef %132)
  %134 = icmp ne i32 %133, 0
  br i1 %134, label %140, label %135

135:                                              ; preds = %125
  %136 = load i32, ptr %19, align 4
  %137 = icmp ne i32 %136, 0
  br i1 %137, label %140, label %138

138:                                              ; preds = %135
  %139 = load i32, ptr %18, align 4
  store i32 %139, ptr %19, align 4
  br label %140

140:                                              ; preds = %138, %135, %125
  br label %227

141:                                              ; preds = %113, %108, %103
  %142 = load ptr, ptr %14, align 8
  %143 = load i8, ptr %142, align 1
  %144 = sext i8 %143 to i32
  %145 = icmp eq i32 %144, 91
  br i1 %145, label %146, label %168

146:                                              ; preds = %141
  %147 = load ptr, ptr %14, align 8
  %148 = getelementptr inbounds i8, ptr %147, i64 1
  %149 = call ptr @ini_find_chars_or_comment(ptr noundef %148, ptr noundef @.str.1.9)
  store ptr %149, ptr %15, align 8
  %150 = load ptr, ptr %15, align 8
  %151 = load i8, ptr %150, align 1
  %152 = sext i8 %151 to i32
  %153 = icmp eq i32 %152, 93
  br i1 %153, label %154, label %161

154:                                              ; preds = %146
  %155 = load ptr, ptr %15, align 8
  store i8 0, ptr %155, align 1
  %156 = getelementptr inbounds [50 x i8], ptr %11, i64 0, i64 0
  %157 = load ptr, ptr %14, align 8
  %158 = getelementptr inbounds i8, ptr %157, i64 1
  %159 = call ptr @ini_strncpy0(ptr noundef %156, ptr noundef %158, i64 noundef 50)
  %160 = getelementptr inbounds [50 x i8], ptr %12, i64 0, i64 0
  store i8 0, ptr %160, align 16
  br label %167

161:                                              ; preds = %146
  %162 = load i32, ptr %19, align 4
  %163 = icmp ne i32 %162, 0
  br i1 %163, label %166, label %164

164:                                              ; preds = %161
  %165 = load i32, ptr %18, align 4
  store i32 %165, ptr %19, align 4
  br label %166

166:                                              ; preds = %164, %161
  br label %167

167:                                              ; preds = %166, %154
  br label %226

168:                                              ; preds = %141
  %169 = load ptr, ptr %14, align 8
  %170 = load i8, ptr %169, align 1
  %171 = icmp ne i8 %170, 0
  br i1 %171, label %172, label %225

172:                                              ; preds = %168
  %173 = load ptr, ptr %14, align 8
  %174 = call ptr @ini_find_chars_or_comment(ptr noundef %173, ptr noundef @.str.2.10)
  store ptr %174, ptr %15, align 8
  %175 = load ptr, ptr %15, align 8
  %176 = load i8, ptr %175, align 1
  %177 = sext i8 %176 to i32
  %178 = icmp eq i32 %177, 61
  br i1 %178, label %184, label %179

179:                                              ; preds = %172
  %180 = load ptr, ptr %15, align 8
  %181 = load i8, ptr %180, align 1
  %182 = sext i8 %181 to i32
  %183 = icmp eq i32 %182, 58
  br i1 %183, label %184, label %218

184:                                              ; preds = %179, %172
  %185 = load ptr, ptr %15, align 8
  store i8 0, ptr %185, align 1
  %186 = load ptr, ptr %14, align 8
  %187 = call ptr @ini_rstrip(ptr noundef %186)
  store ptr %187, ptr %16, align 8
  %188 = load ptr, ptr %15, align 8
  %189 = getelementptr inbounds i8, ptr %188, i64 1
  store ptr %189, ptr %17, align 8
  %190 = load ptr, ptr %17, align 8
  %191 = call ptr @ini_find_chars_or_comment(ptr noundef %190, ptr noundef null)
  store ptr %191, ptr %15, align 8
  %192 = load ptr, ptr %15, align 8
  %193 = load i8, ptr %192, align 1
  %194 = icmp ne i8 %193, 0
  br i1 %194, label %195, label %197

195:                                              ; preds = %184
  %196 = load ptr, ptr %15, align 8
  store i8 0, ptr %196, align 1
  br label %197

197:                                              ; preds = %195, %184
  %198 = load ptr, ptr %17, align 8
  %199 = call ptr @ini_lskip(ptr noundef %198)
  store ptr %199, ptr %17, align 8
  %200 = load ptr, ptr %17, align 8
  %201 = call ptr @ini_rstrip(ptr noundef %200)
  %202 = getelementptr inbounds [50 x i8], ptr %12, i64 0, i64 0
  %203 = load ptr, ptr %16, align 8
  %204 = call ptr @ini_strncpy0(ptr noundef %202, ptr noundef %203, i64 noundef 50)
  %205 = load ptr, ptr %7, align 8
  %206 = load ptr, ptr %8, align 8
  %207 = getelementptr inbounds [50 x i8], ptr %11, i64 0, i64 0
  %208 = load ptr, ptr %16, align 8
  %209 = load ptr, ptr %17, align 8
  %210 = call i32 %205(ptr noundef %206, ptr noundef %207, ptr noundef %208, ptr noundef %209)
  %211 = icmp ne i32 %210, 0
  br i1 %211, label %217, label %212

212:                                              ; preds = %197
  %213 = load i32, ptr %19, align 4
  %214 = icmp ne i32 %213, 0
  br i1 %214, label %217, label %215

215:                                              ; preds = %212
  %216 = load i32, ptr %18, align 4
  store i32 %216, ptr %19, align 4
  br label %217

217:                                              ; preds = %215, %212, %197
  br label %224

218:                                              ; preds = %179
  %219 = load i32, ptr %19, align 4
  %220 = icmp ne i32 %219, 0
  br i1 %220, label %223, label %221

221:                                              ; preds = %218
  %222 = load i32, ptr %18, align 4
  store i32 %222, ptr %19, align 4
  br label %223

223:                                              ; preds = %221, %218
  br label %224

224:                                              ; preds = %223, %217
  br label %225

225:                                              ; preds = %224, %168
  br label %226

226:                                              ; preds = %225, %167
  br label %227

227:                                              ; preds = %226, %140
  br label %228

228:                                              ; preds = %227, %102
  br label %21, !llvm.loop !13

229:                                              ; preds = %21
  %230 = load i32, ptr %19, align 4
  ret i32 %230
}

; Function Attrs: nounwind willreturn memory(read)
declare i64 @strlen(ptr noundef) #2

; Function Attrs: noinline nounwind optnone uwtable
define internal ptr @ini_lskip(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  br label %3

3:                                                ; preds = %22, %1
  %4 = load ptr, ptr %2, align 8
  %5 = load i8, ptr %4, align 1
  %6 = sext i8 %5 to i32
  %7 = icmp ne i32 %6, 0
  br i1 %7, label %8, label %20

8:                                                ; preds = %3
  %9 = call ptr @__ctype_b_loc() #6
  %10 = load ptr, ptr %9, align 8
  %11 = load ptr, ptr %2, align 8
  %12 = load i8, ptr %11, align 1
  %13 = zext i8 %12 to i32
  %14 = sext i32 %13 to i64
  %15 = getelementptr inbounds i16, ptr %10, i64 %14
  %16 = load i16, ptr %15, align 2
  %17 = zext i16 %16 to i32
  %18 = and i32 %17, 8192
  %19 = icmp ne i32 %18, 0
  br label %20

20:                                               ; preds = %8, %3
  %21 = phi i1 [ false, %3 ], [ %19, %8 ]
  br i1 %21, label %22, label %25

22:                                               ; preds = %20
  %23 = load ptr, ptr %2, align 8
  %24 = getelementptr inbounds i8, ptr %23, i32 1
  store ptr %24, ptr %2, align 8
  br label %3, !llvm.loop !14

25:                                               ; preds = %20
  %26 = load ptr, ptr %2, align 8
  ret ptr %26
}

; Function Attrs: noinline nounwind optnone uwtable
define internal ptr @ini_rstrip(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = load ptr, ptr %2, align 8
  %6 = call i64 @strlen(ptr noundef %5) #5
  %7 = getelementptr inbounds i8, ptr %4, i64 %6
  store ptr %7, ptr %3, align 8
  br label %8

8:                                                ; preds = %27, %1
  %9 = load ptr, ptr %3, align 8
  %10 = load ptr, ptr %2, align 8
  %11 = icmp ugt ptr %9, %10
  br i1 %11, label %12, label %25

12:                                               ; preds = %8
  %13 = call ptr @__ctype_b_loc() #6
  %14 = load ptr, ptr %13, align 8
  %15 = load ptr, ptr %3, align 8
  %16 = getelementptr inbounds i8, ptr %15, i32 -1
  store ptr %16, ptr %3, align 8
  %17 = load i8, ptr %16, align 1
  %18 = zext i8 %17 to i32
  %19 = sext i32 %18 to i64
  %20 = getelementptr inbounds i16, ptr %14, i64 %19
  %21 = load i16, ptr %20, align 2
  %22 = zext i16 %21 to i32
  %23 = and i32 %22, 8192
  %24 = icmp ne i32 %23, 0
  br label %25

25:                                               ; preds = %12, %8
  %26 = phi i1 [ false, %8 ], [ %24, %12 ]
  br i1 %26, label %27, label %29

27:                                               ; preds = %25
  %28 = load ptr, ptr %3, align 8
  store i8 0, ptr %28, align 1
  br label %8, !llvm.loop !15

29:                                               ; preds = %25
  %30 = load ptr, ptr %2, align 8
  ret ptr %30
}

; Function Attrs: nounwind willreturn memory(read)
declare ptr @strchr(ptr noundef, i32 noundef) #2

; Function Attrs: noinline nounwind optnone uwtable
define internal ptr @ini_find_chars_or_comment(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  store i32 0, ptr %5, align 4
  br label %6

6:                                                ; preds = %35, %2
  %7 = load ptr, ptr %3, align 8
  %8 = load i8, ptr %7, align 1
  %9 = sext i8 %8 to i32
  %10 = icmp ne i32 %9, 0
  br i1 %10, label %11, label %33

11:                                               ; preds = %6
  %12 = load ptr, ptr %4, align 8
  %13 = icmp ne ptr %12, null
  br i1 %13, label %14, label %21

14:                                               ; preds = %11
  %15 = load ptr, ptr %4, align 8
  %16 = load ptr, ptr %3, align 8
  %17 = load i8, ptr %16, align 1
  %18 = sext i8 %17 to i32
  %19 = call ptr @strchr(ptr noundef %15, i32 noundef %18) #5
  %20 = icmp ne ptr %19, null
  br i1 %20, label %33, label %21

21:                                               ; preds = %14, %11
  %22 = load i32, ptr %5, align 4
  %23 = icmp ne i32 %22, 0
  br i1 %23, label %24, label %30

24:                                               ; preds = %21
  %25 = load ptr, ptr %3, align 8
  %26 = load i8, ptr %25, align 1
  %27 = sext i8 %26 to i32
  %28 = call ptr @strchr(ptr noundef @.str.4.11, i32 noundef %27) #5
  %29 = icmp ne ptr %28, null
  br label %30

30:                                               ; preds = %24, %21
  %31 = phi i1 [ false, %21 ], [ %29, %24 ]
  %32 = xor i1 %31, true
  br label %33

33:                                               ; preds = %30, %14, %6
  %34 = phi i1 [ false, %14 ], [ false, %6 ], [ %32, %30 ]
  br i1 %34, label %35, label %48

35:                                               ; preds = %33
  %36 = call ptr @__ctype_b_loc() #6
  %37 = load ptr, ptr %36, align 8
  %38 = load ptr, ptr %3, align 8
  %39 = load i8, ptr %38, align 1
  %40 = zext i8 %39 to i32
  %41 = sext i32 %40 to i64
  %42 = getelementptr inbounds i16, ptr %37, i64 %41
  %43 = load i16, ptr %42, align 2
  %44 = zext i16 %43 to i32
  %45 = and i32 %44, 8192
  store i32 %45, ptr %5, align 4
  %46 = load ptr, ptr %3, align 8
  %47 = getelementptr inbounds i8, ptr %46, i32 1
  store ptr %47, ptr %3, align 8
  br label %6, !llvm.loop !16

48:                                               ; preds = %33
  %49 = load ptr, ptr %3, align 8
  ret ptr %49
}

; Function Attrs: noinline nounwind optnone uwtable
define internal ptr @ini_strncpy0(ptr noundef %0, ptr noundef %1, i64 noundef %2) #0 {
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca i64, align 8
  %7 = alloca i64, align 8
  store ptr %0, ptr %4, align 8
  store ptr %1, ptr %5, align 8
  store i64 %2, ptr %6, align 8
  store i64 0, ptr %7, align 8
  br label %8

8:                                                ; preds = %30, %3
  %9 = load i64, ptr %7, align 8
  %10 = load i64, ptr %6, align 8
  %11 = sub i64 %10, 1
  %12 = icmp ult i64 %9, %11
  br i1 %12, label %13, label %20

13:                                               ; preds = %8
  %14 = load ptr, ptr %5, align 8
  %15 = load i64, ptr %7, align 8
  %16 = getelementptr inbounds i8, ptr %14, i64 %15
  %17 = load i8, ptr %16, align 1
  %18 = sext i8 %17 to i32
  %19 = icmp ne i32 %18, 0
  br label %20

20:                                               ; preds = %13, %8
  %21 = phi i1 [ false, %8 ], [ %19, %13 ]
  br i1 %21, label %22, label %33

22:                                               ; preds = %20
  %23 = load ptr, ptr %5, align 8
  %24 = load i64, ptr %7, align 8
  %25 = getelementptr inbounds i8, ptr %23, i64 %24
  %26 = load i8, ptr %25, align 1
  %27 = load ptr, ptr %4, align 8
  %28 = load i64, ptr %7, align 8
  %29 = getelementptr inbounds i8, ptr %27, i64 %28
  store i8 %26, ptr %29, align 1
  br label %30

30:                                               ; preds = %22
  %31 = load i64, ptr %7, align 8
  %32 = add i64 %31, 1
  store i64 %32, ptr %7, align 8
  br label %8, !llvm.loop !17

33:                                               ; preds = %20
  %34 = load ptr, ptr %4, align 8
  %35 = load i64, ptr %7, align 8
  %36 = getelementptr inbounds i8, ptr %34, i64 %35
  store i8 0, ptr %36, align 1
  %37 = load ptr, ptr %4, align 8
  ret ptr %37
}

; Function Attrs: nounwind willreturn memory(none)
declare ptr @__ctype_b_loc() #3

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @ini_parse_file(ptr noundef %0, ptr noundef %1, ptr noundef %2) #0 {
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  store ptr %0, ptr %4, align 8
  store ptr %1, ptr %5, align 8
  store ptr %2, ptr %6, align 8
  %7 = load ptr, ptr %4, align 8
  %8 = load ptr, ptr %5, align 8
  %9 = load ptr, ptr %6, align 8
  %10 = call i32 @ini_parse_stream(ptr noundef @fgets, ptr noundef %7, ptr noundef %8, ptr noundef %9)
  ret i32 %10
}

declare ptr @fgets(ptr noundef, i32 noundef, ptr noundef) #4

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @ini_parse(ptr noundef %0, ptr noundef %1, ptr noundef %2) #0 {
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  %9 = alloca i32, align 4
  store ptr %0, ptr %5, align 8
  store ptr %1, ptr %6, align 8
  store ptr %2, ptr %7, align 8
  %10 = load ptr, ptr %5, align 8
  %11 = call noalias ptr @fopen(ptr noundef %10, ptr noundef @.str.3.12)
  store ptr %11, ptr %8, align 8
  %12 = load ptr, ptr %8, align 8
  %13 = icmp ne ptr %12, null
  br i1 %13, label %15, label %14

14:                                               ; preds = %3
  store i32 -1, ptr %4, align 4
  br label %23

15:                                               ; preds = %3
  %16 = load ptr, ptr %8, align 8
  %17 = load ptr, ptr %6, align 8
  %18 = load ptr, ptr %7, align 8
  %19 = call i32 @ini_parse_file(ptr noundef %16, ptr noundef %17, ptr noundef %18)
  store i32 %19, ptr %9, align 4
  %20 = load ptr, ptr %8, align 8
  %21 = call i32 @fclose(ptr noundef %20)
  %22 = load i32, ptr %9, align 4
  store i32 %22, ptr %4, align 4
  br label %23

23:                                               ; preds = %15, %14
  %24 = load i32, ptr %4, align 4
  ret i32 %24
}

declare noalias ptr @fopen(ptr noundef, ptr noundef) #4

declare i32 @fclose(ptr noundef) #4

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @ini_parse_string(ptr noundef %0, ptr noundef %1, ptr noundef %2) #0 {
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  store ptr %0, ptr %4, align 8
  store ptr %1, ptr %5, align 8
  store ptr %2, ptr %6, align 8
  %7 = load ptr, ptr %4, align 8
  %8 = load ptr, ptr %4, align 8
  %9 = call i64 @strlen(ptr noundef %8) #5
  %10 = load ptr, ptr %5, align 8
  %11 = load ptr, ptr %6, align 8
  %12 = call i32 @ini_parse_string_length(ptr noundef %7, i64 noundef %9, ptr noundef %10, ptr noundef %11)
  ret i32 %12
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @ini_parse_string_length(ptr noundef %0, i64 noundef %1, ptr noundef %2, ptr noundef %3) #0 {
  %5 = alloca ptr, align 8
  %6 = alloca i64, align 8
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  %9 = alloca %struct.ini_parse_string_ctx, align 8
  store ptr %0, ptr %5, align 8
  store i64 %1, ptr %6, align 8
  store ptr %2, ptr %7, align 8
  store ptr %3, ptr %8, align 8
  %10 = load ptr, ptr %5, align 8
  %11 = getelementptr inbounds %struct.ini_parse_string_ctx, ptr %9, i32 0, i32 0
  store ptr %10, ptr %11, align 8
  %12 = load i64, ptr %6, align 8
  %13 = getelementptr inbounds %struct.ini_parse_string_ctx, ptr %9, i32 0, i32 1
  store i64 %12, ptr %13, align 8
  %14 = load ptr, ptr %7, align 8
  %15 = load ptr, ptr %8, align 8
  %16 = call i32 @ini_parse_stream(ptr noundef @ini_reader_string, ptr noundef %9, ptr noundef %14, ptr noundef %15)
  ret i32 %16
}

; Function Attrs: noinline nounwind optnone uwtable
define internal ptr @ini_reader_string(ptr noundef %0, i32 noundef %1, ptr noundef %2) #0 {
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  %9 = alloca ptr, align 8
  %10 = alloca i64, align 8
  %11 = alloca ptr, align 8
  %12 = alloca i8, align 1
  store ptr %0, ptr %5, align 8
  store i32 %1, ptr %6, align 4
  store ptr %2, ptr %7, align 8
  %13 = load ptr, ptr %7, align 8
  store ptr %13, ptr %8, align 8
  %14 = load ptr, ptr %8, align 8
  %15 = getelementptr inbounds %struct.ini_parse_string_ctx, ptr %14, i32 0, i32 0
  %16 = load ptr, ptr %15, align 8
  store ptr %16, ptr %9, align 8
  %17 = load ptr, ptr %8, align 8
  %18 = getelementptr inbounds %struct.ini_parse_string_ctx, ptr %17, i32 0, i32 1
  %19 = load i64, ptr %18, align 8
  store i64 %19, ptr %10, align 8
  %20 = load ptr, ptr %5, align 8
  store ptr %20, ptr %11, align 8
  %21 = load i64, ptr %10, align 8
  %22 = icmp eq i64 %21, 0
  br i1 %22, label %26, label %23

23:                                               ; preds = %3
  %24 = load i32, ptr %6, align 4
  %25 = icmp slt i32 %24, 2
  br i1 %25, label %26, label %27

26:                                               ; preds = %23, %3
  store ptr null, ptr %4, align 8
  br label %61

27:                                               ; preds = %23
  br label %28

28:                                               ; preds = %49, %27
  %29 = load i32, ptr %6, align 4
  %30 = icmp sgt i32 %29, 1
  br i1 %30, label %31, label %34

31:                                               ; preds = %28
  %32 = load i64, ptr %10, align 8
  %33 = icmp ne i64 %32, 0
  br label %34

34:                                               ; preds = %31, %28
  %35 = phi i1 [ false, %28 ], [ %33, %31 ]
  br i1 %35, label %36, label %52

36:                                               ; preds = %34
  %37 = load ptr, ptr %9, align 8
  %38 = getelementptr inbounds i8, ptr %37, i32 1
  store ptr %38, ptr %9, align 8
  %39 = load i8, ptr %37, align 1
  store i8 %39, ptr %12, align 1
  %40 = load i64, ptr %10, align 8
  %41 = add i64 %40, -1
  store i64 %41, ptr %10, align 8
  %42 = load i8, ptr %12, align 1
  %43 = load ptr, ptr %11, align 8
  %44 = getelementptr inbounds i8, ptr %43, i32 1
  store ptr %44, ptr %11, align 8
  store i8 %42, ptr %43, align 1
  %45 = load i8, ptr %12, align 1
  %46 = sext i8 %45 to i32
  %47 = icmp eq i32 %46, 10
  br i1 %47, label %48, label %49

48:                                               ; preds = %36
  br label %52

49:                                               ; preds = %36
  %50 = load i32, ptr %6, align 4
  %51 = add nsw i32 %50, -1
  store i32 %51, ptr %6, align 4
  br label %28, !llvm.loop !18

52:                                               ; preds = %48, %34
  %53 = load ptr, ptr %11, align 8
  store i8 0, ptr %53, align 1
  %54 = load ptr, ptr %9, align 8
  %55 = load ptr, ptr %8, align 8
  %56 = getelementptr inbounds %struct.ini_parse_string_ctx, ptr %55, i32 0, i32 0
  store ptr %54, ptr %56, align 8
  %57 = load i64, ptr %10, align 8
  %58 = load ptr, ptr %8, align 8
  %59 = getelementptr inbounds %struct.ini_parse_string_ctx, ptr %58, i32 0, i32 1
  store i64 %57, ptr %59, align 8
  %60 = load ptr, ptr %5, align 8
  store ptr %60, ptr %4, align 8
  br label %61

61:                                               ; preds = %52, %26
  %62 = load ptr, ptr %4, align 8
  ret ptr %62
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #2 = { nounwind willreturn memory(read) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind willreturn memory(none) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind willreturn memory(read) }
attributes #6 = { nounwind willreturn memory(none) }

!llvm.ident = !{!0, !0}
!llvm.module.flags = !{!1, !2, !3, !4, !5}

!0 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 8, !"PIC Level", i32 2}
!3 = !{i32 7, !"PIE Level", i32 2}
!4 = !{i32 7, !"uwtable", i32 2}
!5 = !{i32 7, !"frame-pointer", i32 2}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
!8 = distinct !{!8, !7}
!9 = distinct !{!9, !7}
!10 = distinct !{!10, !7}
!11 = distinct !{!11, !7}
!12 = distinct !{!12, !7}
!13 = distinct !{!13, !7}
!14 = distinct !{!14, !7}
!15 = distinct !{!15, !7}
!16 = distinct !{!16, !7}
!17 = distinct !{!17, !7}
!18 = distinct !{!18, !7}
