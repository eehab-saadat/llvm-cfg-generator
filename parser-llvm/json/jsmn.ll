; ModuleID = 'client.c'
source_filename = "client.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.jsmn_parser = type { i32, i32, i32 }
%struct.jsmntok = type { i32, i32, i32, i32 }

@.str = private unnamed_addr constant [120 x i8] c"{\22JSON Test Pattern pass3\22: {\22The outermost value\22: \22must be an object or array.\22, \22In this test\22: \22It is an object.\22}}\00", align 1
@.str.1 = private unnamed_addr constant [24 x i8] c"JSON Test Pattern pass3\00", align 1
@.str.2 = private unnamed_addr constant [20 x i8] c"The outermost value\00", align 1
@.str.3 = private unnamed_addr constant [13 x i8] c"In this test\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @jsmn_parse(ptr noundef %0, ptr noundef %1, i64 noundef %2, ptr noundef %3, i32 noundef %4) #0 {
  %6 = alloca i32, align 4
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  %9 = alloca i64, align 8
  %10 = alloca ptr, align 8
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca ptr, align 8
  %15 = alloca i32, align 4
  %16 = alloca i8, align 1
  %17 = alloca i32, align 4
  %18 = alloca ptr, align 8
  store ptr %0, ptr %7, align 8
  store ptr %1, ptr %8, align 8
  store i64 %2, ptr %9, align 8
  store ptr %3, ptr %10, align 8
  store i32 %4, ptr %11, align 4
  %19 = load ptr, ptr %7, align 8
  %20 = getelementptr inbounds %struct.jsmn_parser, ptr %19, i32 0, i32 1
  %21 = load i32, ptr %20, align 4
  store i32 %21, ptr %15, align 4
  br label %22

22:                                               ; preds = %337, %5
  %23 = load ptr, ptr %7, align 8
  %24 = getelementptr inbounds %struct.jsmn_parser, ptr %23, i32 0, i32 0
  %25 = load i32, ptr %24, align 4
  %26 = zext i32 %25 to i64
  %27 = load i64, ptr %9, align 8
  %28 = icmp ult i64 %26, %27
  br i1 %28, label %29, label %39

29:                                               ; preds = %22
  %30 = load ptr, ptr %8, align 8
  %31 = load ptr, ptr %7, align 8
  %32 = getelementptr inbounds %struct.jsmn_parser, ptr %31, i32 0, i32 0
  %33 = load i32, ptr %32, align 4
  %34 = zext i32 %33 to i64
  %35 = getelementptr inbounds i8, ptr %30, i64 %34
  %36 = load i8, ptr %35, align 1
  %37 = sext i8 %36 to i32
  %38 = icmp ne i32 %37, 0
  br label %39

39:                                               ; preds = %29, %22
  %40 = phi i1 [ false, %22 ], [ %38, %29 ]
  br i1 %40, label %41, label %342

41:                                               ; preds = %39
  %42 = load ptr, ptr %8, align 8
  %43 = load ptr, ptr %7, align 8
  %44 = getelementptr inbounds %struct.jsmn_parser, ptr %43, i32 0, i32 0
  %45 = load i32, ptr %44, align 4
  %46 = zext i32 %45 to i64
  %47 = getelementptr inbounds i8, ptr %42, i64 %46
  %48 = load i8, ptr %47, align 1
  store i8 %48, ptr %16, align 1
  %49 = load i8, ptr %16, align 1
  %50 = sext i8 %49 to i32
  switch i32 %50, label %303 [
    i32 123, label %51
    i32 91, label %51
    i32 125, label %101
    i32 93, label %101
    i32 34, label %183
    i32 9, label %216
    i32 13, label %216
    i32 10, label %216
    i32 32, label %216
    i32 58, label %217
    i32 44, label %224
  ]

51:                                               ; preds = %41, %41
  %52 = load i32, ptr %15, align 4
  %53 = add nsw i32 %52, 1
  store i32 %53, ptr %15, align 4
  %54 = load ptr, ptr %10, align 8
  %55 = icmp eq ptr %54, null
  br i1 %55, label %56, label %57

56:                                               ; preds = %51
  br label %336

57:                                               ; preds = %51
  %58 = load ptr, ptr %7, align 8
  %59 = load ptr, ptr %10, align 8
  %60 = load i32, ptr %11, align 4
  %61 = zext i32 %60 to i64
  %62 = call ptr @jsmn_alloc_token(ptr noundef %58, ptr noundef %59, i64 noundef %61)
  store ptr %62, ptr %14, align 8
  %63 = load ptr, ptr %14, align 8
  %64 = icmp eq ptr %63, null
  br i1 %64, label %65, label %66

65:                                               ; preds = %57
  store i32 -1, ptr %6, align 4
  br label %377

66:                                               ; preds = %57
  %67 = load ptr, ptr %7, align 8
  %68 = getelementptr inbounds %struct.jsmn_parser, ptr %67, i32 0, i32 2
  %69 = load i32, ptr %68, align 4
  %70 = icmp ne i32 %69, -1
  br i1 %70, label %71, label %82

71:                                               ; preds = %66
  %72 = load ptr, ptr %10, align 8
  %73 = load ptr, ptr %7, align 8
  %74 = getelementptr inbounds %struct.jsmn_parser, ptr %73, i32 0, i32 2
  %75 = load i32, ptr %74, align 4
  %76 = sext i32 %75 to i64
  %77 = getelementptr inbounds %struct.jsmntok, ptr %72, i64 %76
  store ptr %77, ptr %18, align 8
  %78 = load ptr, ptr %18, align 8
  %79 = getelementptr inbounds %struct.jsmntok, ptr %78, i32 0, i32 3
  %80 = load i32, ptr %79, align 4
  %81 = add nsw i32 %80, 1
  store i32 %81, ptr %79, align 4
  br label %82

82:                                               ; preds = %71, %66
  %83 = load i8, ptr %16, align 1
  %84 = sext i8 %83 to i32
  %85 = icmp eq i32 %84, 123
  %86 = zext i1 %85 to i64
  %87 = select i1 %85, i32 1, i32 2
  %88 = load ptr, ptr %14, align 8
  %89 = getelementptr inbounds %struct.jsmntok, ptr %88, i32 0, i32 0
  store i32 %87, ptr %89, align 4
  %90 = load ptr, ptr %7, align 8
  %91 = getelementptr inbounds %struct.jsmn_parser, ptr %90, i32 0, i32 0
  %92 = load i32, ptr %91, align 4
  %93 = load ptr, ptr %14, align 8
  %94 = getelementptr inbounds %struct.jsmntok, ptr %93, i32 0, i32 1
  store i32 %92, ptr %94, align 4
  %95 = load ptr, ptr %7, align 8
  %96 = getelementptr inbounds %struct.jsmn_parser, ptr %95, i32 0, i32 1
  %97 = load i32, ptr %96, align 4
  %98 = sub i32 %97, 1
  %99 = load ptr, ptr %7, align 8
  %100 = getelementptr inbounds %struct.jsmn_parser, ptr %99, i32 0, i32 2
  store i32 %98, ptr %100, align 4
  br label %336

101:                                              ; preds = %41, %41
  %102 = load ptr, ptr %10, align 8
  %103 = icmp eq ptr %102, null
  br i1 %103, label %104, label %105

104:                                              ; preds = %101
  br label %336

105:                                              ; preds = %101
  %106 = load i8, ptr %16, align 1
  %107 = sext i8 %106 to i32
  %108 = icmp eq i32 %107, 125
  %109 = zext i1 %108 to i64
  %110 = select i1 %108, i32 1, i32 2
  store i32 %110, ptr %17, align 4
  %111 = load ptr, ptr %7, align 8
  %112 = getelementptr inbounds %struct.jsmn_parser, ptr %111, i32 0, i32 1
  %113 = load i32, ptr %112, align 4
  %114 = sub i32 %113, 1
  store i32 %114, ptr %13, align 4
  br label %115

115:                                              ; preds = %149, %105
  %116 = load i32, ptr %13, align 4
  %117 = icmp sge i32 %116, 0
  br i1 %117, label %118, label %152

118:                                              ; preds = %115
  %119 = load ptr, ptr %10, align 8
  %120 = load i32, ptr %13, align 4
  %121 = sext i32 %120 to i64
  %122 = getelementptr inbounds %struct.jsmntok, ptr %119, i64 %121
  store ptr %122, ptr %14, align 8
  %123 = load ptr, ptr %14, align 8
  %124 = getelementptr inbounds %struct.jsmntok, ptr %123, i32 0, i32 1
  %125 = load i32, ptr %124, align 4
  %126 = icmp ne i32 %125, -1
  br i1 %126, label %127, label %148

127:                                              ; preds = %118
  %128 = load ptr, ptr %14, align 8
  %129 = getelementptr inbounds %struct.jsmntok, ptr %128, i32 0, i32 2
  %130 = load i32, ptr %129, align 4
  %131 = icmp eq i32 %130, -1
  br i1 %131, label %132, label %148

132:                                              ; preds = %127
  %133 = load ptr, ptr %14, align 8
  %134 = getelementptr inbounds %struct.jsmntok, ptr %133, i32 0, i32 0
  %135 = load i32, ptr %134, align 4
  %136 = load i32, ptr %17, align 4
  %137 = icmp ne i32 %135, %136
  br i1 %137, label %138, label %139

138:                                              ; preds = %132
  store i32 -2, ptr %6, align 4
  br label %377

139:                                              ; preds = %132
  %140 = load ptr, ptr %7, align 8
  %141 = getelementptr inbounds %struct.jsmn_parser, ptr %140, i32 0, i32 2
  store i32 -1, ptr %141, align 4
  %142 = load ptr, ptr %7, align 8
  %143 = getelementptr inbounds %struct.jsmn_parser, ptr %142, i32 0, i32 0
  %144 = load i32, ptr %143, align 4
  %145 = add i32 %144, 1
  %146 = load ptr, ptr %14, align 8
  %147 = getelementptr inbounds %struct.jsmntok, ptr %146, i32 0, i32 2
  store i32 %145, ptr %147, align 4
  br label %152

148:                                              ; preds = %127, %118
  br label %149

149:                                              ; preds = %148
  %150 = load i32, ptr %13, align 4
  %151 = add nsw i32 %150, -1
  store i32 %151, ptr %13, align 4
  br label %115, !llvm.loop !6

152:                                              ; preds = %139, %115
  %153 = load i32, ptr %13, align 4
  %154 = icmp eq i32 %153, -1
  br i1 %154, label %155, label %156

155:                                              ; preds = %152
  store i32 -2, ptr %6, align 4
  br label %377

156:                                              ; preds = %152
  br label %157

157:                                              ; preds = %179, %156
  %158 = load i32, ptr %13, align 4
  %159 = icmp sge i32 %158, 0
  br i1 %159, label %160, label %182

160:                                              ; preds = %157
  %161 = load ptr, ptr %10, align 8
  %162 = load i32, ptr %13, align 4
  %163 = sext i32 %162 to i64
  %164 = getelementptr inbounds %struct.jsmntok, ptr %161, i64 %163
  store ptr %164, ptr %14, align 8
  %165 = load ptr, ptr %14, align 8
  %166 = getelementptr inbounds %struct.jsmntok, ptr %165, i32 0, i32 1
  %167 = load i32, ptr %166, align 4
  %168 = icmp ne i32 %167, -1
  br i1 %168, label %169, label %178

169:                                              ; preds = %160
  %170 = load ptr, ptr %14, align 8
  %171 = getelementptr inbounds %struct.jsmntok, ptr %170, i32 0, i32 2
  %172 = load i32, ptr %171, align 4
  %173 = icmp eq i32 %172, -1
  br i1 %173, label %174, label %178

174:                                              ; preds = %169
  %175 = load i32, ptr %13, align 4
  %176 = load ptr, ptr %7, align 8
  %177 = getelementptr inbounds %struct.jsmn_parser, ptr %176, i32 0, i32 2
  store i32 %175, ptr %177, align 4
  br label %182

178:                                              ; preds = %169, %160
  br label %179

179:                                              ; preds = %178
  %180 = load i32, ptr %13, align 4
  %181 = add nsw i32 %180, -1
  store i32 %181, ptr %13, align 4
  br label %157, !llvm.loop !8

182:                                              ; preds = %174, %157
  br label %336

183:                                              ; preds = %41
  %184 = load ptr, ptr %7, align 8
  %185 = load ptr, ptr %8, align 8
  %186 = load i64, ptr %9, align 8
  %187 = load ptr, ptr %10, align 8
  %188 = load i32, ptr %11, align 4
  %189 = zext i32 %188 to i64
  %190 = call i32 @jsmn_parse_string(ptr noundef %184, ptr noundef %185, i64 noundef %186, ptr noundef %187, i64 noundef %189)
  store i32 %190, ptr %12, align 4
  %191 = load i32, ptr %12, align 4
  %192 = icmp slt i32 %191, 0
  br i1 %192, label %193, label %195

193:                                              ; preds = %183
  %194 = load i32, ptr %12, align 4
  store i32 %194, ptr %6, align 4
  br label %377

195:                                              ; preds = %183
  %196 = load i32, ptr %15, align 4
  %197 = add nsw i32 %196, 1
  store i32 %197, ptr %15, align 4
  %198 = load ptr, ptr %7, align 8
  %199 = getelementptr inbounds %struct.jsmn_parser, ptr %198, i32 0, i32 2
  %200 = load i32, ptr %199, align 4
  %201 = icmp ne i32 %200, -1
  br i1 %201, label %202, label %215

202:                                              ; preds = %195
  %203 = load ptr, ptr %10, align 8
  %204 = icmp ne ptr %203, null
  br i1 %204, label %205, label %215

205:                                              ; preds = %202
  %206 = load ptr, ptr %10, align 8
  %207 = load ptr, ptr %7, align 8
  %208 = getelementptr inbounds %struct.jsmn_parser, ptr %207, i32 0, i32 2
  %209 = load i32, ptr %208, align 4
  %210 = sext i32 %209 to i64
  %211 = getelementptr inbounds %struct.jsmntok, ptr %206, i64 %210
  %212 = getelementptr inbounds %struct.jsmntok, ptr %211, i32 0, i32 3
  %213 = load i32, ptr %212, align 4
  %214 = add nsw i32 %213, 1
  store i32 %214, ptr %212, align 4
  br label %215

215:                                              ; preds = %205, %202, %195
  br label %336

216:                                              ; preds = %41, %41, %41, %41
  br label %336

217:                                              ; preds = %41
  %218 = load ptr, ptr %7, align 8
  %219 = getelementptr inbounds %struct.jsmn_parser, ptr %218, i32 0, i32 1
  %220 = load i32, ptr %219, align 4
  %221 = sub i32 %220, 1
  %222 = load ptr, ptr %7, align 8
  %223 = getelementptr inbounds %struct.jsmn_parser, ptr %222, i32 0, i32 2
  store i32 %221, ptr %223, align 4
  br label %336

224:                                              ; preds = %41
  %225 = load ptr, ptr %10, align 8
  %226 = icmp ne ptr %225, null
  br i1 %226, label %227, label %302

227:                                              ; preds = %224
  %228 = load ptr, ptr %7, align 8
  %229 = getelementptr inbounds %struct.jsmn_parser, ptr %228, i32 0, i32 2
  %230 = load i32, ptr %229, align 4
  %231 = icmp ne i32 %230, -1
  br i1 %231, label %232, label %302

232:                                              ; preds = %227
  %233 = load ptr, ptr %10, align 8
  %234 = load ptr, ptr %7, align 8
  %235 = getelementptr inbounds %struct.jsmn_parser, ptr %234, i32 0, i32 2
  %236 = load i32, ptr %235, align 4
  %237 = sext i32 %236 to i64
  %238 = getelementptr inbounds %struct.jsmntok, ptr %233, i64 %237
  %239 = getelementptr inbounds %struct.jsmntok, ptr %238, i32 0, i32 0
  %240 = load i32, ptr %239, align 4
  %241 = icmp ne i32 %240, 2
  br i1 %241, label %242, label %302

242:                                              ; preds = %232
  %243 = load ptr, ptr %10, align 8
  %244 = load ptr, ptr %7, align 8
  %245 = getelementptr inbounds %struct.jsmn_parser, ptr %244, i32 0, i32 2
  %246 = load i32, ptr %245, align 4
  %247 = sext i32 %246 to i64
  %248 = getelementptr inbounds %struct.jsmntok, ptr %243, i64 %247
  %249 = getelementptr inbounds %struct.jsmntok, ptr %248, i32 0, i32 0
  %250 = load i32, ptr %249, align 4
  %251 = icmp ne i32 %250, 1
  br i1 %251, label %252, label %302

252:                                              ; preds = %242
  %253 = load ptr, ptr %7, align 8
  %254 = getelementptr inbounds %struct.jsmn_parser, ptr %253, i32 0, i32 1
  %255 = load i32, ptr %254, align 4
  %256 = sub i32 %255, 1
  store i32 %256, ptr %13, align 4
  br label %257

257:                                              ; preds = %298, %252
  %258 = load i32, ptr %13, align 4
  %259 = icmp sge i32 %258, 0
  br i1 %259, label %260, label %301

260:                                              ; preds = %257
  %261 = load ptr, ptr %10, align 8
  %262 = load i32, ptr %13, align 4
  %263 = sext i32 %262 to i64
  %264 = getelementptr inbounds %struct.jsmntok, ptr %261, i64 %263
  %265 = getelementptr inbounds %struct.jsmntok, ptr %264, i32 0, i32 0
  %266 = load i32, ptr %265, align 4
  %267 = icmp eq i32 %266, 2
  br i1 %267, label %276, label %268

268:                                              ; preds = %260
  %269 = load ptr, ptr %10, align 8
  %270 = load i32, ptr %13, align 4
  %271 = sext i32 %270 to i64
  %272 = getelementptr inbounds %struct.jsmntok, ptr %269, i64 %271
  %273 = getelementptr inbounds %struct.jsmntok, ptr %272, i32 0, i32 0
  %274 = load i32, ptr %273, align 4
  %275 = icmp eq i32 %274, 1
  br i1 %275, label %276, label %297

276:                                              ; preds = %268, %260
  %277 = load ptr, ptr %10, align 8
  %278 = load i32, ptr %13, align 4
  %279 = sext i32 %278 to i64
  %280 = getelementptr inbounds %struct.jsmntok, ptr %277, i64 %279
  %281 = getelementptr inbounds %struct.jsmntok, ptr %280, i32 0, i32 1
  %282 = load i32, ptr %281, align 4
  %283 = icmp ne i32 %282, -1
  br i1 %283, label %284, label %296

284:                                              ; preds = %276
  %285 = load ptr, ptr %10, align 8
  %286 = load i32, ptr %13, align 4
  %287 = sext i32 %286 to i64
  %288 = getelementptr inbounds %struct.jsmntok, ptr %285, i64 %287
  %289 = getelementptr inbounds %struct.jsmntok, ptr %288, i32 0, i32 2
  %290 = load i32, ptr %289, align 4
  %291 = icmp eq i32 %290, -1
  br i1 %291, label %292, label %296

292:                                              ; preds = %284
  %293 = load i32, ptr %13, align 4
  %294 = load ptr, ptr %7, align 8
  %295 = getelementptr inbounds %struct.jsmn_parser, ptr %294, i32 0, i32 2
  store i32 %293, ptr %295, align 4
  br label %301

296:                                              ; preds = %284, %276
  br label %297

297:                                              ; preds = %296, %268
  br label %298

298:                                              ; preds = %297
  %299 = load i32, ptr %13, align 4
  %300 = add nsw i32 %299, -1
  store i32 %300, ptr %13, align 4
  br label %257, !llvm.loop !9

301:                                              ; preds = %292, %257
  br label %302

302:                                              ; preds = %301, %242, %232, %227, %224
  br label %336

303:                                              ; preds = %41
  %304 = load ptr, ptr %7, align 8
  %305 = load ptr, ptr %8, align 8
  %306 = load i64, ptr %9, align 8
  %307 = load ptr, ptr %10, align 8
  %308 = load i32, ptr %11, align 4
  %309 = zext i32 %308 to i64
  %310 = call i32 @jsmn_parse_primitive(ptr noundef %304, ptr noundef %305, i64 noundef %306, ptr noundef %307, i64 noundef %309)
  store i32 %310, ptr %12, align 4
  %311 = load i32, ptr %12, align 4
  %312 = icmp slt i32 %311, 0
  br i1 %312, label %313, label %315

313:                                              ; preds = %303
  %314 = load i32, ptr %12, align 4
  store i32 %314, ptr %6, align 4
  br label %377

315:                                              ; preds = %303
  %316 = load i32, ptr %15, align 4
  %317 = add nsw i32 %316, 1
  store i32 %317, ptr %15, align 4
  %318 = load ptr, ptr %7, align 8
  %319 = getelementptr inbounds %struct.jsmn_parser, ptr %318, i32 0, i32 2
  %320 = load i32, ptr %319, align 4
  %321 = icmp ne i32 %320, -1
  br i1 %321, label %322, label %335

322:                                              ; preds = %315
  %323 = load ptr, ptr %10, align 8
  %324 = icmp ne ptr %323, null
  br i1 %324, label %325, label %335

325:                                              ; preds = %322
  %326 = load ptr, ptr %10, align 8
  %327 = load ptr, ptr %7, align 8
  %328 = getelementptr inbounds %struct.jsmn_parser, ptr %327, i32 0, i32 2
  %329 = load i32, ptr %328, align 4
  %330 = sext i32 %329 to i64
  %331 = getelementptr inbounds %struct.jsmntok, ptr %326, i64 %330
  %332 = getelementptr inbounds %struct.jsmntok, ptr %331, i32 0, i32 3
  %333 = load i32, ptr %332, align 4
  %334 = add nsw i32 %333, 1
  store i32 %334, ptr %332, align 4
  br label %335

335:                                              ; preds = %325, %322, %315
  br label %336

336:                                              ; preds = %335, %302, %217, %216, %215, %182, %104, %82, %56
  br label %337

337:                                              ; preds = %336
  %338 = load ptr, ptr %7, align 8
  %339 = getelementptr inbounds %struct.jsmn_parser, ptr %338, i32 0, i32 0
  %340 = load i32, ptr %339, align 4
  %341 = add i32 %340, 1
  store i32 %341, ptr %339, align 4
  br label %22, !llvm.loop !10

342:                                              ; preds = %39
  %343 = load ptr, ptr %10, align 8
  %344 = icmp ne ptr %343, null
  br i1 %344, label %345, label %375

345:                                              ; preds = %342
  %346 = load ptr, ptr %7, align 8
  %347 = getelementptr inbounds %struct.jsmn_parser, ptr %346, i32 0, i32 1
  %348 = load i32, ptr %347, align 4
  %349 = sub i32 %348, 1
  store i32 %349, ptr %13, align 4
  br label %350

350:                                              ; preds = %371, %345
  %351 = load i32, ptr %13, align 4
  %352 = icmp sge i32 %351, 0
  br i1 %352, label %353, label %374

353:                                              ; preds = %350
  %354 = load ptr, ptr %10, align 8
  %355 = load i32, ptr %13, align 4
  %356 = sext i32 %355 to i64
  %357 = getelementptr inbounds %struct.jsmntok, ptr %354, i64 %356
  %358 = getelementptr inbounds %struct.jsmntok, ptr %357, i32 0, i32 1
  %359 = load i32, ptr %358, align 4
  %360 = icmp ne i32 %359, -1
  br i1 %360, label %361, label %370

361:                                              ; preds = %353
  %362 = load ptr, ptr %10, align 8
  %363 = load i32, ptr %13, align 4
  %364 = sext i32 %363 to i64
  %365 = getelementptr inbounds %struct.jsmntok, ptr %362, i64 %364
  %366 = getelementptr inbounds %struct.jsmntok, ptr %365, i32 0, i32 2
  %367 = load i32, ptr %366, align 4
  %368 = icmp eq i32 %367, -1
  br i1 %368, label %369, label %370

369:                                              ; preds = %361
  store i32 -3, ptr %6, align 4
  br label %377

370:                                              ; preds = %361, %353
  br label %371

371:                                              ; preds = %370
  %372 = load i32, ptr %13, align 4
  %373 = add nsw i32 %372, -1
  store i32 %373, ptr %13, align 4
  br label %350, !llvm.loop !11

374:                                              ; preds = %350
  br label %375

375:                                              ; preds = %374, %342
  %376 = load i32, ptr %15, align 4
  store i32 %376, ptr %6, align 4
  br label %377

377:                                              ; preds = %375, %369, %313, %193, %155, %138, %65
  %378 = load i32, ptr %6, align 4
  ret i32 %378
}

; Function Attrs: noinline nounwind optnone uwtable
define internal ptr @jsmn_alloc_token(ptr noundef %0, ptr noundef %1, i64 noundef %2) #0 {
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca i64, align 8
  %8 = alloca ptr, align 8
  store ptr %0, ptr %5, align 8
  store ptr %1, ptr %6, align 8
  store i64 %2, ptr %7, align 8
  %9 = load ptr, ptr %5, align 8
  %10 = getelementptr inbounds %struct.jsmn_parser, ptr %9, i32 0, i32 1
  %11 = load i32, ptr %10, align 4
  %12 = zext i32 %11 to i64
  %13 = load i64, ptr %7, align 8
  %14 = icmp uge i64 %12, %13
  br i1 %14, label %15, label %16

15:                                               ; preds = %3
  store ptr null, ptr %4, align 8
  br label %31

16:                                               ; preds = %3
  %17 = load ptr, ptr %6, align 8
  %18 = load ptr, ptr %5, align 8
  %19 = getelementptr inbounds %struct.jsmn_parser, ptr %18, i32 0, i32 1
  %20 = load i32, ptr %19, align 4
  %21 = add i32 %20, 1
  store i32 %21, ptr %19, align 4
  %22 = zext i32 %20 to i64
  %23 = getelementptr inbounds %struct.jsmntok, ptr %17, i64 %22
  store ptr %23, ptr %8, align 8
  %24 = load ptr, ptr %8, align 8
  %25 = getelementptr inbounds %struct.jsmntok, ptr %24, i32 0, i32 2
  store i32 -1, ptr %25, align 4
  %26 = load ptr, ptr %8, align 8
  %27 = getelementptr inbounds %struct.jsmntok, ptr %26, i32 0, i32 1
  store i32 -1, ptr %27, align 4
  %28 = load ptr, ptr %8, align 8
  %29 = getelementptr inbounds %struct.jsmntok, ptr %28, i32 0, i32 3
  store i32 0, ptr %29, align 4
  %30 = load ptr, ptr %8, align 8
  store ptr %30, ptr %4, align 8
  br label %31

31:                                               ; preds = %16, %15
  %32 = load ptr, ptr %4, align 8
  ret ptr %32
}

; Function Attrs: noinline nounwind optnone uwtable
define internal i32 @jsmn_parse_string(ptr noundef %0, ptr noundef %1, i64 noundef %2, ptr noundef %3, i64 noundef %4) #0 {
  %6 = alloca i32, align 4
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  %9 = alloca i64, align 8
  %10 = alloca ptr, align 8
  %11 = alloca i64, align 8
  %12 = alloca ptr, align 8
  %13 = alloca i32, align 4
  %14 = alloca i8, align 1
  %15 = alloca i32, align 4
  store ptr %0, ptr %7, align 8
  store ptr %1, ptr %8, align 8
  store i64 %2, ptr %9, align 8
  store ptr %3, ptr %10, align 8
  store i64 %4, ptr %11, align 8
  %16 = load ptr, ptr %7, align 8
  %17 = getelementptr inbounds %struct.jsmn_parser, ptr %16, i32 0, i32 0
  %18 = load i32, ptr %17, align 4
  store i32 %18, ptr %13, align 4
  %19 = load ptr, ptr %7, align 8
  %20 = getelementptr inbounds %struct.jsmn_parser, ptr %19, i32 0, i32 0
  %21 = load i32, ptr %20, align 4
  %22 = add i32 %21, 1
  store i32 %22, ptr %20, align 4
  br label %23

23:                                               ; preds = %211, %5
  %24 = load ptr, ptr %7, align 8
  %25 = getelementptr inbounds %struct.jsmn_parser, ptr %24, i32 0, i32 0
  %26 = load i32, ptr %25, align 4
  %27 = zext i32 %26 to i64
  %28 = load i64, ptr %9, align 8
  %29 = icmp ult i64 %27, %28
  br i1 %29, label %30, label %40

30:                                               ; preds = %23
  %31 = load ptr, ptr %8, align 8
  %32 = load ptr, ptr %7, align 8
  %33 = getelementptr inbounds %struct.jsmn_parser, ptr %32, i32 0, i32 0
  %34 = load i32, ptr %33, align 4
  %35 = zext i32 %34 to i64
  %36 = getelementptr inbounds i8, ptr %31, i64 %35
  %37 = load i8, ptr %36, align 1
  %38 = sext i8 %37 to i32
  %39 = icmp ne i32 %38, 0
  br label %40

40:                                               ; preds = %30, %23
  %41 = phi i1 [ false, %23 ], [ %39, %30 ]
  br i1 %41, label %42, label %216

42:                                               ; preds = %40
  %43 = load ptr, ptr %8, align 8
  %44 = load ptr, ptr %7, align 8
  %45 = getelementptr inbounds %struct.jsmn_parser, ptr %44, i32 0, i32 0
  %46 = load i32, ptr %45, align 4
  %47 = zext i32 %46 to i64
  %48 = getelementptr inbounds i8, ptr %43, i64 %47
  %49 = load i8, ptr %48, align 1
  store i8 %49, ptr %14, align 1
  %50 = load i8, ptr %14, align 1
  %51 = sext i8 %50 to i32
  %52 = icmp eq i32 %51, 34
  br i1 %52, label %53, label %75

53:                                               ; preds = %42
  %54 = load ptr, ptr %10, align 8
  %55 = icmp eq ptr %54, null
  br i1 %55, label %56, label %57

56:                                               ; preds = %53
  store i32 0, ptr %6, align 4
  br label %220

57:                                               ; preds = %53
  %58 = load ptr, ptr %7, align 8
  %59 = load ptr, ptr %10, align 8
  %60 = load i64, ptr %11, align 8
  %61 = call ptr @jsmn_alloc_token(ptr noundef %58, ptr noundef %59, i64 noundef %60)
  store ptr %61, ptr %12, align 8
  %62 = load ptr, ptr %12, align 8
  %63 = icmp eq ptr %62, null
  br i1 %63, label %64, label %68

64:                                               ; preds = %57
  %65 = load i32, ptr %13, align 4
  %66 = load ptr, ptr %7, align 8
  %67 = getelementptr inbounds %struct.jsmn_parser, ptr %66, i32 0, i32 0
  store i32 %65, ptr %67, align 4
  store i32 -1, ptr %6, align 4
  br label %220

68:                                               ; preds = %57
  %69 = load ptr, ptr %12, align 8
  %70 = load i32, ptr %13, align 4
  %71 = add nsw i32 %70, 1
  %72 = load ptr, ptr %7, align 8
  %73 = getelementptr inbounds %struct.jsmn_parser, ptr %72, i32 0, i32 0
  %74 = load i32, ptr %73, align 4
  call void @jsmn_fill_token(ptr noundef %69, i32 noundef 4, i32 noundef %71, i32 noundef %74)
  store i32 0, ptr %6, align 4
  br label %220

75:                                               ; preds = %42
  %76 = load i8, ptr %14, align 1
  %77 = sext i8 %76 to i32
  %78 = icmp eq i32 %77, 92
  br i1 %78, label %79, label %210

79:                                               ; preds = %75
  %80 = load ptr, ptr %7, align 8
  %81 = getelementptr inbounds %struct.jsmn_parser, ptr %80, i32 0, i32 0
  %82 = load i32, ptr %81, align 4
  %83 = add i32 %82, 1
  %84 = zext i32 %83 to i64
  %85 = load i64, ptr %9, align 8
  %86 = icmp ult i64 %84, %85
  br i1 %86, label %87, label %210

87:                                               ; preds = %79
  %88 = load ptr, ptr %7, align 8
  %89 = getelementptr inbounds %struct.jsmn_parser, ptr %88, i32 0, i32 0
  %90 = load i32, ptr %89, align 4
  %91 = add i32 %90, 1
  store i32 %91, ptr %89, align 4
  %92 = load ptr, ptr %8, align 8
  %93 = load ptr, ptr %7, align 8
  %94 = getelementptr inbounds %struct.jsmn_parser, ptr %93, i32 0, i32 0
  %95 = load i32, ptr %94, align 4
  %96 = zext i32 %95 to i64
  %97 = getelementptr inbounds i8, ptr %92, i64 %96
  %98 = load i8, ptr %97, align 1
  %99 = sext i8 %98 to i32
  switch i32 %99, label %205 [
    i32 34, label %100
    i32 47, label %100
    i32 92, label %100
    i32 98, label %100
    i32 102, label %100
    i32 114, label %100
    i32 110, label %100
    i32 116, label %100
    i32 117, label %101
  ]

100:                                              ; preds = %87, %87, %87, %87, %87, %87, %87, %87
  br label %209

101:                                              ; preds = %87
  %102 = load ptr, ptr %7, align 8
  %103 = getelementptr inbounds %struct.jsmn_parser, ptr %102, i32 0, i32 0
  %104 = load i32, ptr %103, align 4
  %105 = add i32 %104, 1
  store i32 %105, ptr %103, align 4
  store i32 0, ptr %15, align 4
  br label %106

106:                                              ; preds = %197, %101
  %107 = load i32, ptr %15, align 4
  %108 = icmp slt i32 %107, 4
  br i1 %108, label %109, label %126

109:                                              ; preds = %106
  %110 = load ptr, ptr %7, align 8
  %111 = getelementptr inbounds %struct.jsmn_parser, ptr %110, i32 0, i32 0
  %112 = load i32, ptr %111, align 4
  %113 = zext i32 %112 to i64
  %114 = load i64, ptr %9, align 8
  %115 = icmp ult i64 %113, %114
  br i1 %115, label %116, label %126

116:                                              ; preds = %109
  %117 = load ptr, ptr %8, align 8
  %118 = load ptr, ptr %7, align 8
  %119 = getelementptr inbounds %struct.jsmn_parser, ptr %118, i32 0, i32 0
  %120 = load i32, ptr %119, align 4
  %121 = zext i32 %120 to i64
  %122 = getelementptr inbounds i8, ptr %117, i64 %121
  %123 = load i8, ptr %122, align 1
  %124 = sext i8 %123 to i32
  %125 = icmp ne i32 %124, 0
  br label %126

126:                                              ; preds = %116, %109, %106
  %127 = phi i1 [ false, %109 ], [ false, %106 ], [ %125, %116 ]
  br i1 %127, label %128, label %200

128:                                              ; preds = %126
  %129 = load ptr, ptr %8, align 8
  %130 = load ptr, ptr %7, align 8
  %131 = getelementptr inbounds %struct.jsmn_parser, ptr %130, i32 0, i32 0
  %132 = load i32, ptr %131, align 4
  %133 = zext i32 %132 to i64
  %134 = getelementptr inbounds i8, ptr %129, i64 %133
  %135 = load i8, ptr %134, align 1
  %136 = sext i8 %135 to i32
  %137 = icmp sge i32 %136, 48
  br i1 %137, label %138, label %148

138:                                              ; preds = %128
  %139 = load ptr, ptr %8, align 8
  %140 = load ptr, ptr %7, align 8
  %141 = getelementptr inbounds %struct.jsmn_parser, ptr %140, i32 0, i32 0
  %142 = load i32, ptr %141, align 4
  %143 = zext i32 %142 to i64
  %144 = getelementptr inbounds i8, ptr %139, i64 %143
  %145 = load i8, ptr %144, align 1
  %146 = sext i8 %145 to i32
  %147 = icmp sle i32 %146, 57
  br i1 %147, label %192, label %148

148:                                              ; preds = %138, %128
  %149 = load ptr, ptr %8, align 8
  %150 = load ptr, ptr %7, align 8
  %151 = getelementptr inbounds %struct.jsmn_parser, ptr %150, i32 0, i32 0
  %152 = load i32, ptr %151, align 4
  %153 = zext i32 %152 to i64
  %154 = getelementptr inbounds i8, ptr %149, i64 %153
  %155 = load i8, ptr %154, align 1
  %156 = sext i8 %155 to i32
  %157 = icmp sge i32 %156, 65
  br i1 %157, label %158, label %168

158:                                              ; preds = %148
  %159 = load ptr, ptr %8, align 8
  %160 = load ptr, ptr %7, align 8
  %161 = getelementptr inbounds %struct.jsmn_parser, ptr %160, i32 0, i32 0
  %162 = load i32, ptr %161, align 4
  %163 = zext i32 %162 to i64
  %164 = getelementptr inbounds i8, ptr %159, i64 %163
  %165 = load i8, ptr %164, align 1
  %166 = sext i8 %165 to i32
  %167 = icmp sle i32 %166, 70
  br i1 %167, label %192, label %168

168:                                              ; preds = %158, %148
  %169 = load ptr, ptr %8, align 8
  %170 = load ptr, ptr %7, align 8
  %171 = getelementptr inbounds %struct.jsmn_parser, ptr %170, i32 0, i32 0
  %172 = load i32, ptr %171, align 4
  %173 = zext i32 %172 to i64
  %174 = getelementptr inbounds i8, ptr %169, i64 %173
  %175 = load i8, ptr %174, align 1
  %176 = sext i8 %175 to i32
  %177 = icmp sge i32 %176, 97
  br i1 %177, label %178, label %188

178:                                              ; preds = %168
  %179 = load ptr, ptr %8, align 8
  %180 = load ptr, ptr %7, align 8
  %181 = getelementptr inbounds %struct.jsmn_parser, ptr %180, i32 0, i32 0
  %182 = load i32, ptr %181, align 4
  %183 = zext i32 %182 to i64
  %184 = getelementptr inbounds i8, ptr %179, i64 %183
  %185 = load i8, ptr %184, align 1
  %186 = sext i8 %185 to i32
  %187 = icmp sle i32 %186, 102
  br i1 %187, label %192, label %188

188:                                              ; preds = %178, %168
  %189 = load i32, ptr %13, align 4
  %190 = load ptr, ptr %7, align 8
  %191 = getelementptr inbounds %struct.jsmn_parser, ptr %190, i32 0, i32 0
  store i32 %189, ptr %191, align 4
  store i32 -2, ptr %6, align 4
  br label %220

192:                                              ; preds = %178, %158, %138
  %193 = load ptr, ptr %7, align 8
  %194 = getelementptr inbounds %struct.jsmn_parser, ptr %193, i32 0, i32 0
  %195 = load i32, ptr %194, align 4
  %196 = add i32 %195, 1
  store i32 %196, ptr %194, align 4
  br label %197

197:                                              ; preds = %192
  %198 = load i32, ptr %15, align 4
  %199 = add nsw i32 %198, 1
  store i32 %199, ptr %15, align 4
  br label %106, !llvm.loop !12

200:                                              ; preds = %126
  %201 = load ptr, ptr %7, align 8
  %202 = getelementptr inbounds %struct.jsmn_parser, ptr %201, i32 0, i32 0
  %203 = load i32, ptr %202, align 4
  %204 = add i32 %203, -1
  store i32 %204, ptr %202, align 4
  br label %209

205:                                              ; preds = %87
  %206 = load i32, ptr %13, align 4
  %207 = load ptr, ptr %7, align 8
  %208 = getelementptr inbounds %struct.jsmn_parser, ptr %207, i32 0, i32 0
  store i32 %206, ptr %208, align 4
  store i32 -2, ptr %6, align 4
  br label %220

209:                                              ; preds = %200, %100
  br label %210

210:                                              ; preds = %209, %79, %75
  br label %211

211:                                              ; preds = %210
  %212 = load ptr, ptr %7, align 8
  %213 = getelementptr inbounds %struct.jsmn_parser, ptr %212, i32 0, i32 0
  %214 = load i32, ptr %213, align 4
  %215 = add i32 %214, 1
  store i32 %215, ptr %213, align 4
  br label %23, !llvm.loop !13

216:                                              ; preds = %40
  %217 = load i32, ptr %13, align 4
  %218 = load ptr, ptr %7, align 8
  %219 = getelementptr inbounds %struct.jsmn_parser, ptr %218, i32 0, i32 0
  store i32 %217, ptr %219, align 4
  store i32 -3, ptr %6, align 4
  br label %220

220:                                              ; preds = %216, %205, %188, %68, %64, %56
  %221 = load i32, ptr %6, align 4
  ret i32 %221
}

; Function Attrs: noinline nounwind optnone uwtable
define internal i32 @jsmn_parse_primitive(ptr noundef %0, ptr noundef %1, i64 noundef %2, ptr noundef %3, i64 noundef %4) #0 {
  %6 = alloca i32, align 4
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  %9 = alloca i64, align 8
  %10 = alloca ptr, align 8
  %11 = alloca i64, align 8
  %12 = alloca ptr, align 8
  %13 = alloca i32, align 4
  store ptr %0, ptr %7, align 8
  store ptr %1, ptr %8, align 8
  store i64 %2, ptr %9, align 8
  store ptr %3, ptr %10, align 8
  store i64 %4, ptr %11, align 8
  %14 = load ptr, ptr %7, align 8
  %15 = getelementptr inbounds %struct.jsmn_parser, ptr %14, i32 0, i32 0
  %16 = load i32, ptr %15, align 4
  store i32 %16, ptr %13, align 4
  br label %17

17:                                               ; preds = %72, %5
  %18 = load ptr, ptr %7, align 8
  %19 = getelementptr inbounds %struct.jsmn_parser, ptr %18, i32 0, i32 0
  %20 = load i32, ptr %19, align 4
  %21 = zext i32 %20 to i64
  %22 = load i64, ptr %9, align 8
  %23 = icmp ult i64 %21, %22
  br i1 %23, label %24, label %34

24:                                               ; preds = %17
  %25 = load ptr, ptr %8, align 8
  %26 = load ptr, ptr %7, align 8
  %27 = getelementptr inbounds %struct.jsmn_parser, ptr %26, i32 0, i32 0
  %28 = load i32, ptr %27, align 4
  %29 = zext i32 %28 to i64
  %30 = getelementptr inbounds i8, ptr %25, i64 %29
  %31 = load i8, ptr %30, align 1
  %32 = sext i8 %31 to i32
  %33 = icmp ne i32 %32, 0
  br label %34

34:                                               ; preds = %24, %17
  %35 = phi i1 [ false, %17 ], [ %33, %24 ]
  br i1 %35, label %36, label %77

36:                                               ; preds = %34
  %37 = load ptr, ptr %8, align 8
  %38 = load ptr, ptr %7, align 8
  %39 = getelementptr inbounds %struct.jsmn_parser, ptr %38, i32 0, i32 0
  %40 = load i32, ptr %39, align 4
  %41 = zext i32 %40 to i64
  %42 = getelementptr inbounds i8, ptr %37, i64 %41
  %43 = load i8, ptr %42, align 1
  %44 = sext i8 %43 to i32
  switch i32 %44, label %46 [
    i32 58, label %45
    i32 9, label %45
    i32 13, label %45
    i32 10, label %45
    i32 32, label %45
    i32 44, label %45
    i32 93, label %45
    i32 125, label %45
  ]

45:                                               ; preds = %36, %36, %36, %36, %36, %36, %36, %36
  br label %78

46:                                               ; preds = %36
  br label %47

47:                                               ; preds = %46
  %48 = load ptr, ptr %8, align 8
  %49 = load ptr, ptr %7, align 8
  %50 = getelementptr inbounds %struct.jsmn_parser, ptr %49, i32 0, i32 0
  %51 = load i32, ptr %50, align 4
  %52 = zext i32 %51 to i64
  %53 = getelementptr inbounds i8, ptr %48, i64 %52
  %54 = load i8, ptr %53, align 1
  %55 = sext i8 %54 to i32
  %56 = icmp slt i32 %55, 32
  br i1 %56, label %67, label %57

57:                                               ; preds = %47
  %58 = load ptr, ptr %8, align 8
  %59 = load ptr, ptr %7, align 8
  %60 = getelementptr inbounds %struct.jsmn_parser, ptr %59, i32 0, i32 0
  %61 = load i32, ptr %60, align 4
  %62 = zext i32 %61 to i64
  %63 = getelementptr inbounds i8, ptr %58, i64 %62
  %64 = load i8, ptr %63, align 1
  %65 = sext i8 %64 to i32
  %66 = icmp sge i32 %65, 127
  br i1 %66, label %67, label %71

67:                                               ; preds = %57, %47
  %68 = load i32, ptr %13, align 4
  %69 = load ptr, ptr %7, align 8
  %70 = getelementptr inbounds %struct.jsmn_parser, ptr %69, i32 0, i32 0
  store i32 %68, ptr %70, align 4
  store i32 -2, ptr %6, align 4
  br label %107

71:                                               ; preds = %57
  br label %72

72:                                               ; preds = %71
  %73 = load ptr, ptr %7, align 8
  %74 = getelementptr inbounds %struct.jsmn_parser, ptr %73, i32 0, i32 0
  %75 = load i32, ptr %74, align 4
  %76 = add i32 %75, 1
  store i32 %76, ptr %74, align 4
  br label %17, !llvm.loop !14

77:                                               ; preds = %34
  br label %78

78:                                               ; preds = %77, %45
  %79 = load ptr, ptr %10, align 8
  %80 = icmp eq ptr %79, null
  br i1 %80, label %81, label %86

81:                                               ; preds = %78
  %82 = load ptr, ptr %7, align 8
  %83 = getelementptr inbounds %struct.jsmn_parser, ptr %82, i32 0, i32 0
  %84 = load i32, ptr %83, align 4
  %85 = add i32 %84, -1
  store i32 %85, ptr %83, align 4
  store i32 0, ptr %6, align 4
  br label %107

86:                                               ; preds = %78
  %87 = load ptr, ptr %7, align 8
  %88 = load ptr, ptr %10, align 8
  %89 = load i64, ptr %11, align 8
  %90 = call ptr @jsmn_alloc_token(ptr noundef %87, ptr noundef %88, i64 noundef %89)
  store ptr %90, ptr %12, align 8
  %91 = load ptr, ptr %12, align 8
  %92 = icmp eq ptr %91, null
  br i1 %92, label %93, label %97

93:                                               ; preds = %86
  %94 = load i32, ptr %13, align 4
  %95 = load ptr, ptr %7, align 8
  %96 = getelementptr inbounds %struct.jsmn_parser, ptr %95, i32 0, i32 0
  store i32 %94, ptr %96, align 4
  store i32 -1, ptr %6, align 4
  br label %107

97:                                               ; preds = %86
  %98 = load ptr, ptr %12, align 8
  %99 = load i32, ptr %13, align 4
  %100 = load ptr, ptr %7, align 8
  %101 = getelementptr inbounds %struct.jsmn_parser, ptr %100, i32 0, i32 0
  %102 = load i32, ptr %101, align 4
  call void @jsmn_fill_token(ptr noundef %98, i32 noundef 8, i32 noundef %99, i32 noundef %102)
  %103 = load ptr, ptr %7, align 8
  %104 = getelementptr inbounds %struct.jsmn_parser, ptr %103, i32 0, i32 0
  %105 = load i32, ptr %104, align 4
  %106 = add i32 %105, -1
  store i32 %106, ptr %104, align 4
  store i32 0, ptr %6, align 4
  br label %107

107:                                              ; preds = %97, %93, %81, %67
  %108 = load i32, ptr %6, align 4
  ret i32 %108
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @jsmn_init(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = load ptr, ptr %2, align 8
  %4 = getelementptr inbounds %struct.jsmn_parser, ptr %3, i32 0, i32 0
  store i32 0, ptr %4, align 4
  %5 = load ptr, ptr %2, align 8
  %6 = getelementptr inbounds %struct.jsmn_parser, ptr %5, i32 0, i32 1
  store i32 0, ptr %6, align 4
  %7 = load ptr, ptr %2, align 8
  %8 = getelementptr inbounds %struct.jsmn_parser, ptr %7, i32 0, i32 2
  store i32 -1, ptr %8, align 4
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca %struct.jsmn_parser, align 4
  %4 = alloca [32 x %struct.jsmntok], align 16
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  store ptr @.str, ptr %2, align 8
  call void @jsmn_init(ptr noundef %3)
  %12 = load ptr, ptr %2, align 8
  %13 = load ptr, ptr %2, align 8
  %14 = call i32 @strlen_custom(ptr noundef %13)
  %15 = sext i32 %14 to i64
  %16 = getelementptr inbounds [32 x %struct.jsmntok], ptr %4, i64 0, i64 0
  %17 = call i32 @jsmn_parse(ptr noundef %3, ptr noundef %12, i64 noundef %15, ptr noundef %16, i32 noundef 32)
  store i32 %17, ptr %5, align 4
  %18 = load i32, ptr %5, align 4
  %19 = icmp slt i32 %18, 0
  br i1 %19, label %20, label %21

20:                                               ; preds = %0
  store i32 1, ptr %1, align 4
  br label %133

21:                                               ; preds = %0
  %22 = load i32, ptr %5, align 4
  %23 = icmp slt i32 %22, 1
  br i1 %23, label %29, label %24

24:                                               ; preds = %21
  %25 = getelementptr inbounds [32 x %struct.jsmntok], ptr %4, i64 0, i64 0
  %26 = getelementptr inbounds %struct.jsmntok, ptr %25, i32 0, i32 0
  %27 = load i32, ptr %26, align 16
  %28 = icmp ne i32 %27, 1
  br i1 %28, label %29, label %30

29:                                               ; preds = %24, %21
  store i32 1, ptr %1, align 4
  br label %133

30:                                               ; preds = %24
  store i32 1, ptr %6, align 4
  br label %31

31:                                               ; preds = %129, %30
  %32 = load i32, ptr %6, align 4
  %33 = load i32, ptr %5, align 4
  %34 = icmp slt i32 %32, %33
  br i1 %34, label %35, label %132

35:                                               ; preds = %31
  %36 = load ptr, ptr %2, align 8
  %37 = load i32, ptr %6, align 4
  %38 = sext i32 %37 to i64
  %39 = getelementptr inbounds [32 x %struct.jsmntok], ptr %4, i64 0, i64 %38
  %40 = call i32 @jsoneq(ptr noundef %36, ptr noundef %39, ptr noundef @.str.1)
  %41 = icmp eq i32 %40, 0
  br i1 %41, label %42, label %128

42:                                               ; preds = %35
  %43 = load i32, ptr %6, align 4
  %44 = add nsw i32 %43, 1
  %45 = load i32, ptr %5, align 4
  %46 = icmp slt i32 %44, %45
  br i1 %46, label %47, label %127

47:                                               ; preds = %42
  %48 = load i32, ptr %6, align 4
  %49 = add nsw i32 %48, 1
  %50 = sext i32 %49 to i64
  %51 = getelementptr inbounds [32 x %struct.jsmntok], ptr %4, i64 0, i64 %50
  %52 = getelementptr inbounds %struct.jsmntok, ptr %51, i32 0, i32 0
  %53 = load i32, ptr %52, align 16
  %54 = icmp eq i32 %53, 1
  br i1 %54, label %55, label %127

55:                                               ; preds = %47
  %56 = load i32, ptr %6, align 4
  %57 = add nsw i32 %56, 2
  store i32 %57, ptr %8, align 4
  %58 = load i32, ptr %6, align 4
  %59 = add nsw i32 %58, 1
  %60 = sext i32 %59 to i64
  %61 = getelementptr inbounds [32 x %struct.jsmntok], ptr %4, i64 0, i64 %60
  %62 = getelementptr inbounds %struct.jsmntok, ptr %61, i32 0, i32 3
  %63 = load i32, ptr %62, align 4
  store i32 %63, ptr %9, align 4
  store i32 0, ptr %7, align 4
  br label %64

64:                                               ; preds = %119, %55
  %65 = load i32, ptr %7, align 4
  %66 = load i32, ptr %9, align 4
  %67 = mul nsw i32 %66, 2
  %68 = icmp slt i32 %65, %67
  br i1 %68, label %69, label %122

69:                                               ; preds = %64
  %70 = load i32, ptr %8, align 4
  %71 = load i32, ptr %7, align 4
  %72 = add nsw i32 %70, %71
  store i32 %72, ptr %10, align 4
  %73 = load i32, ptr %8, align 4
  %74 = load i32, ptr %7, align 4
  %75 = add nsw i32 %73, %74
  %76 = add nsw i32 %75, 1
  store i32 %76, ptr %11, align 4
  %77 = load i32, ptr %10, align 4
  %78 = load i32, ptr %5, align 4
  %79 = icmp slt i32 %77, %78
  br i1 %79, label %80, label %118

80:                                               ; preds = %69
  %81 = load i32, ptr %11, align 4
  %82 = load i32, ptr %5, align 4
  %83 = icmp slt i32 %81, %82
  br i1 %83, label %84, label %118

84:                                               ; preds = %80
  %85 = load ptr, ptr %2, align 8
  %86 = load i32, ptr %10, align 4
  %87 = sext i32 %86 to i64
  %88 = getelementptr inbounds [32 x %struct.jsmntok], ptr %4, i64 0, i64 %87
  %89 = call i32 @jsoneq(ptr noundef %85, ptr noundef %88, ptr noundef @.str.2)
  %90 = icmp eq i32 %89, 0
  br i1 %90, label %91, label %100

91:                                               ; preds = %84
  %92 = load i32, ptr %11, align 4
  %93 = sext i32 %92 to i64
  %94 = getelementptr inbounds [32 x %struct.jsmntok], ptr %4, i64 0, i64 %93
  %95 = getelementptr inbounds %struct.jsmntok, ptr %94, i32 0, i32 0
  %96 = load i32, ptr %95, align 16
  %97 = icmp eq i32 %96, 4
  br i1 %97, label %98, label %99

98:                                               ; preds = %91
  br label %99

99:                                               ; preds = %98, %91
  br label %117

100:                                              ; preds = %84
  %101 = load ptr, ptr %2, align 8
  %102 = load i32, ptr %10, align 4
  %103 = sext i32 %102 to i64
  %104 = getelementptr inbounds [32 x %struct.jsmntok], ptr %4, i64 0, i64 %103
  %105 = call i32 @jsoneq(ptr noundef %101, ptr noundef %104, ptr noundef @.str.3)
  %106 = icmp eq i32 %105, 0
  br i1 %106, label %107, label %116

107:                                              ; preds = %100
  %108 = load i32, ptr %11, align 4
  %109 = sext i32 %108 to i64
  %110 = getelementptr inbounds [32 x %struct.jsmntok], ptr %4, i64 0, i64 %109
  %111 = getelementptr inbounds %struct.jsmntok, ptr %110, i32 0, i32 0
  %112 = load i32, ptr %111, align 16
  %113 = icmp eq i32 %112, 4
  br i1 %113, label %114, label %115

114:                                              ; preds = %107
  br label %115

115:                                              ; preds = %114, %107
  br label %116

116:                                              ; preds = %115, %100
  br label %117

117:                                              ; preds = %116, %99
  br label %118

118:                                              ; preds = %117, %80, %69
  br label %119

119:                                              ; preds = %118
  %120 = load i32, ptr %7, align 4
  %121 = add nsw i32 %120, 2
  store i32 %121, ptr %7, align 4
  br label %64, !llvm.loop !15

122:                                              ; preds = %64
  %123 = load i32, ptr %9, align 4
  %124 = add nsw i32 %123, 1
  %125 = load i32, ptr %6, align 4
  %126 = add nsw i32 %125, %124
  store i32 %126, ptr %6, align 4
  br label %127

127:                                              ; preds = %122, %47, %42
  br label %128

128:                                              ; preds = %127, %35
  br label %129

129:                                              ; preds = %128
  %130 = load i32, ptr %6, align 4
  %131 = add nsw i32 %130, 1
  store i32 %131, ptr %6, align 4
  br label %31, !llvm.loop !16

132:                                              ; preds = %31
  store i32 0, ptr %1, align 4
  br label %133

133:                                              ; preds = %132, %29, %20
  %134 = load i32, ptr %1, align 4
  ret i32 %134
}

; Function Attrs: noinline nounwind optnone uwtable
define internal i32 @strlen_custom(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  store i32 0, ptr %3, align 4
  br label %4

4:                                                ; preds = %12, %1
  %5 = load ptr, ptr %2, align 8
  %6 = load i32, ptr %3, align 4
  %7 = sext i32 %6 to i64
  %8 = getelementptr inbounds i8, ptr %5, i64 %7
  %9 = load i8, ptr %8, align 1
  %10 = sext i8 %9 to i32
  %11 = icmp ne i32 %10, 0
  br i1 %11, label %12, label %15

12:                                               ; preds = %4
  %13 = load i32, ptr %3, align 4
  %14 = add nsw i32 %13, 1
  store i32 %14, ptr %3, align 4
  br label %4, !llvm.loop !17

15:                                               ; preds = %4
  %16 = load i32, ptr %3, align 4
  ret i32 %16
}

; Function Attrs: noinline nounwind optnone uwtable
define internal i32 @jsoneq(ptr noundef %0, ptr noundef %1, ptr noundef %2) #0 {
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  store ptr %0, ptr %5, align 8
  store ptr %1, ptr %6, align 8
  store ptr %2, ptr %7, align 8
  %10 = load ptr, ptr %6, align 8
  %11 = getelementptr inbounds %struct.jsmntok, ptr %10, i32 0, i32 0
  %12 = load i32, ptr %11, align 4
  %13 = icmp eq i32 %12, 4
  br i1 %13, label %14, label %66

14:                                               ; preds = %3
  store i32 0, ptr %8, align 4
  br label %15

15:                                               ; preds = %23, %14
  %16 = load ptr, ptr %7, align 8
  %17 = load i32, ptr %8, align 4
  %18 = sext i32 %17 to i64
  %19 = getelementptr inbounds i8, ptr %16, i64 %18
  %20 = load i8, ptr %19, align 1
  %21 = sext i8 %20 to i32
  %22 = icmp ne i32 %21, 0
  br i1 %22, label %23, label %26

23:                                               ; preds = %15
  %24 = load i32, ptr %8, align 4
  %25 = add nsw i32 %24, 1
  store i32 %25, ptr %8, align 4
  br label %15, !llvm.loop !18

26:                                               ; preds = %15
  %27 = load i32, ptr %8, align 4
  %28 = load ptr, ptr %6, align 8
  %29 = getelementptr inbounds %struct.jsmntok, ptr %28, i32 0, i32 2
  %30 = load i32, ptr %29, align 4
  %31 = load ptr, ptr %6, align 8
  %32 = getelementptr inbounds %struct.jsmntok, ptr %31, i32 0, i32 1
  %33 = load i32, ptr %32, align 4
  %34 = sub nsw i32 %30, %33
  %35 = icmp eq i32 %27, %34
  br i1 %35, label %36, label %65

36:                                               ; preds = %26
  store i32 0, ptr %9, align 4
  br label %37

37:                                               ; preds = %61, %36
  %38 = load i32, ptr %9, align 4
  %39 = load i32, ptr %8, align 4
  %40 = icmp slt i32 %38, %39
  br i1 %40, label %41, label %64

41:                                               ; preds = %37
  %42 = load ptr, ptr %5, align 8
  %43 = load ptr, ptr %6, align 8
  %44 = getelementptr inbounds %struct.jsmntok, ptr %43, i32 0, i32 1
  %45 = load i32, ptr %44, align 4
  %46 = load i32, ptr %9, align 4
  %47 = add nsw i32 %45, %46
  %48 = sext i32 %47 to i64
  %49 = getelementptr inbounds i8, ptr %42, i64 %48
  %50 = load i8, ptr %49, align 1
  %51 = sext i8 %50 to i32
  %52 = load ptr, ptr %7, align 8
  %53 = load i32, ptr %9, align 4
  %54 = sext i32 %53 to i64
  %55 = getelementptr inbounds i8, ptr %52, i64 %54
  %56 = load i8, ptr %55, align 1
  %57 = sext i8 %56 to i32
  %58 = icmp ne i32 %51, %57
  br i1 %58, label %59, label %60

59:                                               ; preds = %41
  store i32 -1, ptr %4, align 4
  br label %67

60:                                               ; preds = %41
  br label %61

61:                                               ; preds = %60
  %62 = load i32, ptr %9, align 4
  %63 = add nsw i32 %62, 1
  store i32 %63, ptr %9, align 4
  br label %37, !llvm.loop !19

64:                                               ; preds = %37
  store i32 0, ptr %4, align 4
  br label %67

65:                                               ; preds = %26
  br label %66

66:                                               ; preds = %65, %3
  store i32 -1, ptr %4, align 4
  br label %67

67:                                               ; preds = %66, %64, %59
  %68 = load i32, ptr %4, align 4
  ret i32 %68
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @jsmn_fill_token(ptr noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3) #0 {
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store ptr %0, ptr %5, align 8
  store i32 %1, ptr %6, align 4
  store i32 %2, ptr %7, align 4
  store i32 %3, ptr %8, align 4
  %9 = load i32, ptr %6, align 4
  %10 = load ptr, ptr %5, align 8
  %11 = getelementptr inbounds %struct.jsmntok, ptr %10, i32 0, i32 0
  store i32 %9, ptr %11, align 4
  %12 = load i32, ptr %7, align 4
  %13 = load ptr, ptr %5, align 8
  %14 = getelementptr inbounds %struct.jsmntok, ptr %13, i32 0, i32 1
  store i32 %12, ptr %14, align 4
  %15 = load i32, ptr %8, align 4
  %16 = load ptr, ptr %5, align 8
  %17 = getelementptr inbounds %struct.jsmntok, ptr %16, i32 0, i32 2
  store i32 %15, ptr %17, align 4
  %18 = load ptr, ptr %5, align 8
  %19 = getelementptr inbounds %struct.jsmntok, ptr %18, i32 0, i32 3
  store i32 0, ptr %19, align 4
  ret void
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
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
!19 = distinct !{!19, !7}
