@_bal_stack_guard = external global i8*
@_Bi04root0 = external constant {i32}
declare i8 addrspace(1)* @_bal_panic_construct(i64) cold
declare void @_bal_panic(i8 addrspace(1)*) noreturn cold
declare {{i32, i8 addrspace(1)*(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i8 addrspace(1)*)*, i64(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i64)*, double(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, double)*, i64, {i32}*}*, i64, i64, i8* addrspace(1)*} addrspace(1)* @_bal_list_construct({i32}*, i64)
declare i64 @_bal_array_generic_compare(i8 addrspace(1)*, i8 addrspace(1)*) readonly
declare void @_Bb02ioprintln(i8 addrspace(1)*)
define void @_B04rootmain() !dbg !5 {
  %a = alloca i8 addrspace(1)*
  %1 = alloca i8 addrspace(1)*
  %b = alloca i8 addrspace(1)*
  %2 = alloca i8 addrspace(1)*
  %c = alloca i8 addrspace(1)*
  %3 = alloca i8 addrspace(1)*
  %d = alloca i8 addrspace(1)*
  %4 = alloca i8 addrspace(1)*
  %e = alloca i8 addrspace(1)*
  %5 = alloca i8 addrspace(1)*
  %6 = alloca i1
  %7 = alloca i8 addrspace(1)*
  %8 = alloca i1
  %9 = alloca i8 addrspace(1)*
  %10 = alloca i1
  %11 = alloca i8 addrspace(1)*
  %12 = alloca i1
  %13 = alloca i8 addrspace(1)*
  %14 = alloca i1
  %15 = alloca i8 addrspace(1)*
  %16 = alloca i1
  %17 = alloca i8 addrspace(1)*
  %18 = alloca i1
  %19 = alloca i8 addrspace(1)*
  %20 = alloca i1
  %21 = alloca i8 addrspace(1)*
  %22 = alloca i1
  %23 = alloca i8 addrspace(1)*
  %24 = alloca i1
  %25 = alloca i8 addrspace(1)*
  %26 = alloca i1
  %27 = alloca i8 addrspace(1)*
  %28 = alloca i1
  %29 = alloca i8 addrspace(1)*
  %30 = alloca i1
  %31 = alloca i8 addrspace(1)*
  %32 = alloca i1
  %33 = alloca i8 addrspace(1)*
  %34 = alloca i1
  %35 = alloca i8 addrspace(1)*
  %36 = alloca i1
  %37 = alloca i8 addrspace(1)*
  %38 = alloca i1
  %39 = alloca i8 addrspace(1)*
  %40 = alloca i1
  %41 = alloca i8 addrspace(1)*
  %42 = alloca i1
  %43 = alloca i8 addrspace(1)*
  %44 = alloca i1
  %45 = alloca i8 addrspace(1)*
  %46 = alloca i1
  %47 = alloca i8 addrspace(1)*
  %48 = alloca i1
  %49 = alloca i8 addrspace(1)*
  %50 = alloca i1
  %51 = alloca i8 addrspace(1)*
  %52 = alloca i1
  %53 = alloca i8 addrspace(1)*
  %54 = alloca i1
  %55 = alloca i8 addrspace(1)*
  %56 = alloca i1
  %57 = alloca i8 addrspace(1)*
  %58 = alloca i1
  %59 = alloca i8 addrspace(1)*
  %60 = alloca i1
  %61 = alloca i8 addrspace(1)*
  %62 = alloca i1
  %63 = alloca i8 addrspace(1)*
  %64 = alloca i1
  %65 = alloca i8 addrspace(1)*
  %66 = alloca i1
  %67 = alloca i8 addrspace(1)*
  %68 = alloca i1
  %69 = alloca i8 addrspace(1)*
  %70 = alloca i1
  %71 = alloca i8 addrspace(1)*
  %72 = alloca i1
  %73 = alloca i8 addrspace(1)*
  %74 = alloca i1
  %75 = alloca i8 addrspace(1)*
  %76 = alloca i1
  %77 = alloca i8 addrspace(1)*
  %78 = alloca i8
  %79 = load i8*, i8** @_bal_stack_guard
  %80 = icmp ult i8* %78, %79
  br i1 %80, label %446, label %81
81:
  %82 = call {{i32, i8 addrspace(1)*(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i8 addrspace(1)*)*, i64(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i64)*, double(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, double)*, i64, {i32}*}*, i64, i64, i8* addrspace(1)*} addrspace(1)* @_bal_list_construct({i32}* @_Bi04root0, i64 2)
  %83 = getelementptr inbounds {{i32, i8 addrspace(1)*(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i8 addrspace(1)*)*, i64(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i64)*, double(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, double)*, i64, {i32}*}*, i64, i64, i8* addrspace(1)*}, {{i32, i8 addrspace(1)*(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i8 addrspace(1)*)*, i64(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i64)*, double(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, double)*, i64, {i32}*}*, i64, i64, i8* addrspace(1)*} addrspace(1)* %82, i64 0, i32 3
  %84 = load i8* addrspace(1)*, i8* addrspace(1)* addrspace(1)* %83, align 8
  %85 = bitcast i8* addrspace(1)* %84 to [0 x i8 addrspace(1)*] addrspace(1)*
  %86 = zext i1 0 to i64
  %87 = or i64 %86, 72057594037927936
  %88 = getelementptr i8, i8 addrspace(1)* null, i64 %87
  %89 = getelementptr inbounds [0 x i8 addrspace(1)*], [0 x i8 addrspace(1)*] addrspace(1)* %85, i64 0, i64 0
  store i8 addrspace(1)* %88, i8 addrspace(1)* addrspace(1)* %89
  %90 = zext i1 1 to i64
  %91 = or i64 %90, 72057594037927936
  %92 = getelementptr i8, i8 addrspace(1)* null, i64 %91
  %93 = getelementptr inbounds [0 x i8 addrspace(1)*], [0 x i8 addrspace(1)*] addrspace(1)* %85, i64 0, i64 1
  store i8 addrspace(1)* %92, i8 addrspace(1)* addrspace(1)* %93
  %94 = getelementptr inbounds {{i32, i8 addrspace(1)*(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i8 addrspace(1)*)*, i64(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i64)*, double(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, double)*, i64, {i32}*}*, i64, i64, i8* addrspace(1)*}, {{i32, i8 addrspace(1)*(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i8 addrspace(1)*)*, i64(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i64)*, double(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, double)*, i64, {i32}*}*, i64, i64, i8* addrspace(1)*} addrspace(1)* %82, i64 0, i32 1
  store i64 2, i64 addrspace(1)* %94
  %95 = bitcast {{i32, i8 addrspace(1)*(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i8 addrspace(1)*)*, i64(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i64)*, double(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, double)*, i64, {i32}*}*, i64, i64, i8* addrspace(1)*} addrspace(1)* %82 to i8 addrspace(1)*
  %96 = getelementptr i8, i8 addrspace(1)* %95, i64 1297036692682702852
  store i8 addrspace(1)* %96, i8 addrspace(1)** %1
  %97 = load i8 addrspace(1)*, i8 addrspace(1)** %1
  store i8 addrspace(1)* %97, i8 addrspace(1)** %a
  %98 = call {{i32, i8 addrspace(1)*(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i8 addrspace(1)*)*, i64(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i64)*, double(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, double)*, i64, {i32}*}*, i64, i64, i8* addrspace(1)*} addrspace(1)* @_bal_list_construct({i32}* @_Bi04root0, i64 2)
  %99 = getelementptr inbounds {{i32, i8 addrspace(1)*(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i8 addrspace(1)*)*, i64(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i64)*, double(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, double)*, i64, {i32}*}*, i64, i64, i8* addrspace(1)*}, {{i32, i8 addrspace(1)*(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i8 addrspace(1)*)*, i64(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i64)*, double(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, double)*, i64, {i32}*}*, i64, i64, i8* addrspace(1)*} addrspace(1)* %98, i64 0, i32 3
  %100 = load i8* addrspace(1)*, i8* addrspace(1)* addrspace(1)* %99, align 8
  %101 = bitcast i8* addrspace(1)* %100 to [0 x i8 addrspace(1)*] addrspace(1)*
  %102 = zext i1 1 to i64
  %103 = or i64 %102, 72057594037927936
  %104 = getelementptr i8, i8 addrspace(1)* null, i64 %103
  %105 = getelementptr inbounds [0 x i8 addrspace(1)*], [0 x i8 addrspace(1)*] addrspace(1)* %101, i64 0, i64 0
  store i8 addrspace(1)* %104, i8 addrspace(1)* addrspace(1)* %105
  %106 = zext i1 0 to i64
  %107 = or i64 %106, 72057594037927936
  %108 = getelementptr i8, i8 addrspace(1)* null, i64 %107
  %109 = getelementptr inbounds [0 x i8 addrspace(1)*], [0 x i8 addrspace(1)*] addrspace(1)* %101, i64 0, i64 1
  store i8 addrspace(1)* %108, i8 addrspace(1)* addrspace(1)* %109
  %110 = getelementptr inbounds {{i32, i8 addrspace(1)*(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i8 addrspace(1)*)*, i64(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i64)*, double(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, double)*, i64, {i32}*}*, i64, i64, i8* addrspace(1)*}, {{i32, i8 addrspace(1)*(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i8 addrspace(1)*)*, i64(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i64)*, double(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, double)*, i64, {i32}*}*, i64, i64, i8* addrspace(1)*} addrspace(1)* %98, i64 0, i32 1
  store i64 2, i64 addrspace(1)* %110
  %111 = bitcast {{i32, i8 addrspace(1)*(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i8 addrspace(1)*)*, i64(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i64)*, double(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, double)*, i64, {i32}*}*, i64, i64, i8* addrspace(1)*} addrspace(1)* %98 to i8 addrspace(1)*
  %112 = getelementptr i8, i8 addrspace(1)* %111, i64 1297036692682702852
  store i8 addrspace(1)* %112, i8 addrspace(1)** %2
  %113 = load i8 addrspace(1)*, i8 addrspace(1)** %2
  store i8 addrspace(1)* %113, i8 addrspace(1)** %b
  %114 = call {{i32, i8 addrspace(1)*(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i8 addrspace(1)*)*, i64(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i64)*, double(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, double)*, i64, {i32}*}*, i64, i64, i8* addrspace(1)*} addrspace(1)* @_bal_list_construct({i32}* @_Bi04root0, i64 3)
  %115 = getelementptr inbounds {{i32, i8 addrspace(1)*(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i8 addrspace(1)*)*, i64(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i64)*, double(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, double)*, i64, {i32}*}*, i64, i64, i8* addrspace(1)*}, {{i32, i8 addrspace(1)*(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i8 addrspace(1)*)*, i64(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i64)*, double(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, double)*, i64, {i32}*}*, i64, i64, i8* addrspace(1)*} addrspace(1)* %114, i64 0, i32 3
  %116 = load i8* addrspace(1)*, i8* addrspace(1)* addrspace(1)* %115, align 8
  %117 = bitcast i8* addrspace(1)* %116 to [0 x i8 addrspace(1)*] addrspace(1)*
  %118 = zext i1 0 to i64
  %119 = or i64 %118, 72057594037927936
  %120 = getelementptr i8, i8 addrspace(1)* null, i64 %119
  %121 = getelementptr inbounds [0 x i8 addrspace(1)*], [0 x i8 addrspace(1)*] addrspace(1)* %117, i64 0, i64 0
  store i8 addrspace(1)* %120, i8 addrspace(1)* addrspace(1)* %121
  %122 = zext i1 1 to i64
  %123 = or i64 %122, 72057594037927936
  %124 = getelementptr i8, i8 addrspace(1)* null, i64 %123
  %125 = getelementptr inbounds [0 x i8 addrspace(1)*], [0 x i8 addrspace(1)*] addrspace(1)* %117, i64 0, i64 1
  store i8 addrspace(1)* %124, i8 addrspace(1)* addrspace(1)* %125
  %126 = zext i1 1 to i64
  %127 = or i64 %126, 72057594037927936
  %128 = getelementptr i8, i8 addrspace(1)* null, i64 %127
  %129 = getelementptr inbounds [0 x i8 addrspace(1)*], [0 x i8 addrspace(1)*] addrspace(1)* %117, i64 0, i64 2
  store i8 addrspace(1)* %128, i8 addrspace(1)* addrspace(1)* %129
  %130 = getelementptr inbounds {{i32, i8 addrspace(1)*(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i8 addrspace(1)*)*, i64(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i64)*, double(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, double)*, i64, {i32}*}*, i64, i64, i8* addrspace(1)*}, {{i32, i8 addrspace(1)*(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i8 addrspace(1)*)*, i64(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i64)*, double(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, double)*, i64, {i32}*}*, i64, i64, i8* addrspace(1)*} addrspace(1)* %114, i64 0, i32 1
  store i64 3, i64 addrspace(1)* %130
  %131 = bitcast {{i32, i8 addrspace(1)*(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i8 addrspace(1)*)*, i64(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i64)*, double(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, double)*, i64, {i32}*}*, i64, i64, i8* addrspace(1)*} addrspace(1)* %114 to i8 addrspace(1)*
  %132 = getelementptr i8, i8 addrspace(1)* %131, i64 1297036692682702852
  store i8 addrspace(1)* %132, i8 addrspace(1)** %3
  %133 = load i8 addrspace(1)*, i8 addrspace(1)** %3
  store i8 addrspace(1)* %133, i8 addrspace(1)** %c
  %134 = call {{i32, i8 addrspace(1)*(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i8 addrspace(1)*)*, i64(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i64)*, double(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, double)*, i64, {i32}*}*, i64, i64, i8* addrspace(1)*} addrspace(1)* @_bal_list_construct({i32}* @_Bi04root0, i64 3)
  %135 = getelementptr inbounds {{i32, i8 addrspace(1)*(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i8 addrspace(1)*)*, i64(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i64)*, double(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, double)*, i64, {i32}*}*, i64, i64, i8* addrspace(1)*}, {{i32, i8 addrspace(1)*(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i8 addrspace(1)*)*, i64(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i64)*, double(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, double)*, i64, {i32}*}*, i64, i64, i8* addrspace(1)*} addrspace(1)* %134, i64 0, i32 3
  %136 = load i8* addrspace(1)*, i8* addrspace(1)* addrspace(1)* %135, align 8
  %137 = bitcast i8* addrspace(1)* %136 to [0 x i8 addrspace(1)*] addrspace(1)*
  %138 = zext i1 0 to i64
  %139 = or i64 %138, 72057594037927936
  %140 = getelementptr i8, i8 addrspace(1)* null, i64 %139
  %141 = getelementptr inbounds [0 x i8 addrspace(1)*], [0 x i8 addrspace(1)*] addrspace(1)* %137, i64 0, i64 0
  store i8 addrspace(1)* %140, i8 addrspace(1)* addrspace(1)* %141
  %142 = zext i1 1 to i64
  %143 = or i64 %142, 72057594037927936
  %144 = getelementptr i8, i8 addrspace(1)* null, i64 %143
  %145 = getelementptr inbounds [0 x i8 addrspace(1)*], [0 x i8 addrspace(1)*] addrspace(1)* %137, i64 0, i64 1
  store i8 addrspace(1)* %144, i8 addrspace(1)* addrspace(1)* %145
  %146 = zext i1 0 to i64
  %147 = or i64 %146, 72057594037927936
  %148 = getelementptr i8, i8 addrspace(1)* null, i64 %147
  %149 = getelementptr inbounds [0 x i8 addrspace(1)*], [0 x i8 addrspace(1)*] addrspace(1)* %137, i64 0, i64 2
  store i8 addrspace(1)* %148, i8 addrspace(1)* addrspace(1)* %149
  %150 = getelementptr inbounds {{i32, i8 addrspace(1)*(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i8 addrspace(1)*)*, i64(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i64)*, double(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, double)*, i64, {i32}*}*, i64, i64, i8* addrspace(1)*}, {{i32, i8 addrspace(1)*(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i8 addrspace(1)*)*, i64(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i64)*, double(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, double)*, i64, {i32}*}*, i64, i64, i8* addrspace(1)*} addrspace(1)* %134, i64 0, i32 1
  store i64 3, i64 addrspace(1)* %150
  %151 = bitcast {{i32, i8 addrspace(1)*(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i8 addrspace(1)*)*, i64(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i64)*, double(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, double)*, i64, {i32}*}*, i64, i64, i8* addrspace(1)*} addrspace(1)* %134 to i8 addrspace(1)*
  %152 = getelementptr i8, i8 addrspace(1)* %151, i64 1297036692682702852
  store i8 addrspace(1)* %152, i8 addrspace(1)** %4
  %153 = load i8 addrspace(1)*, i8 addrspace(1)** %4
  store i8 addrspace(1)* %153, i8 addrspace(1)** %d
  %154 = call {{i32, i8 addrspace(1)*(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i8 addrspace(1)*)*, i64(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i64)*, double(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, double)*, i64, {i32}*}*, i64, i64, i8* addrspace(1)*} addrspace(1)* @_bal_list_construct({i32}* @_Bi04root0, i64 0)
  %155 = bitcast {{i32, i8 addrspace(1)*(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i8 addrspace(1)*)*, i64(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, i64)*, double(i8 addrspace(1)*, i64)*, i64(i8 addrspace(1)*, i64, double)*, i64, {i32}*}*, i64, i64, i8* addrspace(1)*} addrspace(1)* %154 to i8 addrspace(1)*
  %156 = getelementptr i8, i8 addrspace(1)* %155, i64 1297036692682702852
  store i8 addrspace(1)* %156, i8 addrspace(1)** %5
  %157 = load i8 addrspace(1)*, i8 addrspace(1)** %5
  store i8 addrspace(1)* %157, i8 addrspace(1)** %e
  %158 = load i8 addrspace(1)*, i8 addrspace(1)** %a
  %159 = load i8 addrspace(1)*, i8 addrspace(1)** %a
  %160 = call i64 @_bal_array_generic_compare(i8 addrspace(1)* %158, i8 addrspace(1)* %159)
  %161 = icmp eq i64 %160, 0
  store i1 %161, i1* %6
  %162 = load i1, i1* %6, !dbg !8
  %163 = zext i1 %162 to i64, !dbg !8
  %164 = or i64 %163, 72057594037927936, !dbg !8
  %165 = getelementptr i8, i8 addrspace(1)* null, i64 %164, !dbg !8
  call void @_Bb02ioprintln(i8 addrspace(1)* %165), !dbg !8
  store i8 addrspace(1)* null, i8 addrspace(1)** %7, !dbg !8
  %166 = load i8 addrspace(1)*, i8 addrspace(1)** %a
  %167 = load i8 addrspace(1)*, i8 addrspace(1)** %a
  %168 = call i64 @_bal_array_generic_compare(i8 addrspace(1)* %166, i8 addrspace(1)* %167)
  %169 = icmp ule i64 %168, 1
  store i1 %169, i1* %8
  %170 = load i1, i1* %8, !dbg !9
  %171 = zext i1 %170 to i64, !dbg !9
  %172 = or i64 %171, 72057594037927936, !dbg !9
  %173 = getelementptr i8, i8 addrspace(1)* null, i64 %172, !dbg !9
  call void @_Bb02ioprintln(i8 addrspace(1)* %173), !dbg !9
  store i8 addrspace(1)* null, i8 addrspace(1)** %9, !dbg !9
  %174 = load i8 addrspace(1)*, i8 addrspace(1)** %a
  %175 = load i8 addrspace(1)*, i8 addrspace(1)** %a
  %176 = call i64 @_bal_array_generic_compare(i8 addrspace(1)* %174, i8 addrspace(1)* %175)
  %177 = icmp eq i64 %176, 2
  store i1 %177, i1* %10
  %178 = load i1, i1* %10, !dbg !10
  %179 = zext i1 %178 to i64, !dbg !10
  %180 = or i64 %179, 72057594037927936, !dbg !10
  %181 = getelementptr i8, i8 addrspace(1)* null, i64 %180, !dbg !10
  call void @_Bb02ioprintln(i8 addrspace(1)* %181), !dbg !10
  store i8 addrspace(1)* null, i8 addrspace(1)** %11, !dbg !10
  %182 = load i8 addrspace(1)*, i8 addrspace(1)** %a
  %183 = load i8 addrspace(1)*, i8 addrspace(1)** %a
  %184 = call i64 @_bal_array_generic_compare(i8 addrspace(1)* %182, i8 addrspace(1)* %183)
  %185 = icmp sge i64 %184, 1
  store i1 %185, i1* %12
  %186 = load i1, i1* %12, !dbg !11
  %187 = zext i1 %186 to i64, !dbg !11
  %188 = or i64 %187, 72057594037927936, !dbg !11
  %189 = getelementptr i8, i8 addrspace(1)* null, i64 %188, !dbg !11
  call void @_Bb02ioprintln(i8 addrspace(1)* %189), !dbg !11
  store i8 addrspace(1)* null, i8 addrspace(1)** %13, !dbg !11
  %190 = load i8 addrspace(1)*, i8 addrspace(1)** %a
  %191 = load i8 addrspace(1)*, i8 addrspace(1)** %b
  %192 = call i64 @_bal_array_generic_compare(i8 addrspace(1)* %190, i8 addrspace(1)* %191)
  %193 = icmp eq i64 %192, 0
  store i1 %193, i1* %14
  %194 = load i1, i1* %14, !dbg !12
  %195 = zext i1 %194 to i64, !dbg !12
  %196 = or i64 %195, 72057594037927936, !dbg !12
  %197 = getelementptr i8, i8 addrspace(1)* null, i64 %196, !dbg !12
  call void @_Bb02ioprintln(i8 addrspace(1)* %197), !dbg !12
  store i8 addrspace(1)* null, i8 addrspace(1)** %15, !dbg !12
  %198 = load i8 addrspace(1)*, i8 addrspace(1)** %a
  %199 = load i8 addrspace(1)*, i8 addrspace(1)** %b
  %200 = call i64 @_bal_array_generic_compare(i8 addrspace(1)* %198, i8 addrspace(1)* %199)
  %201 = icmp ule i64 %200, 1
  store i1 %201, i1* %16
  %202 = load i1, i1* %16, !dbg !13
  %203 = zext i1 %202 to i64, !dbg !13
  %204 = or i64 %203, 72057594037927936, !dbg !13
  %205 = getelementptr i8, i8 addrspace(1)* null, i64 %204, !dbg !13
  call void @_Bb02ioprintln(i8 addrspace(1)* %205), !dbg !13
  store i8 addrspace(1)* null, i8 addrspace(1)** %17, !dbg !13
  %206 = load i8 addrspace(1)*, i8 addrspace(1)** %a
  %207 = load i8 addrspace(1)*, i8 addrspace(1)** %b
  %208 = call i64 @_bal_array_generic_compare(i8 addrspace(1)* %206, i8 addrspace(1)* %207)
  %209 = icmp eq i64 %208, 2
  store i1 %209, i1* %18
  %210 = load i1, i1* %18, !dbg !14
  %211 = zext i1 %210 to i64, !dbg !14
  %212 = or i64 %211, 72057594037927936, !dbg !14
  %213 = getelementptr i8, i8 addrspace(1)* null, i64 %212, !dbg !14
  call void @_Bb02ioprintln(i8 addrspace(1)* %213), !dbg !14
  store i8 addrspace(1)* null, i8 addrspace(1)** %19, !dbg !14
  %214 = load i8 addrspace(1)*, i8 addrspace(1)** %a
  %215 = load i8 addrspace(1)*, i8 addrspace(1)** %b
  %216 = call i64 @_bal_array_generic_compare(i8 addrspace(1)* %214, i8 addrspace(1)* %215)
  %217 = icmp sge i64 %216, 1
  store i1 %217, i1* %20
  %218 = load i1, i1* %20, !dbg !15
  %219 = zext i1 %218 to i64, !dbg !15
  %220 = or i64 %219, 72057594037927936, !dbg !15
  %221 = getelementptr i8, i8 addrspace(1)* null, i64 %220, !dbg !15
  call void @_Bb02ioprintln(i8 addrspace(1)* %221), !dbg !15
  store i8 addrspace(1)* null, i8 addrspace(1)** %21, !dbg !15
  %222 = load i8 addrspace(1)*, i8 addrspace(1)** %b
  %223 = load i8 addrspace(1)*, i8 addrspace(1)** %a
  %224 = call i64 @_bal_array_generic_compare(i8 addrspace(1)* %222, i8 addrspace(1)* %223)
  %225 = icmp eq i64 %224, 0
  store i1 %225, i1* %22
  %226 = load i1, i1* %22, !dbg !16
  %227 = zext i1 %226 to i64, !dbg !16
  %228 = or i64 %227, 72057594037927936, !dbg !16
  %229 = getelementptr i8, i8 addrspace(1)* null, i64 %228, !dbg !16
  call void @_Bb02ioprintln(i8 addrspace(1)* %229), !dbg !16
  store i8 addrspace(1)* null, i8 addrspace(1)** %23, !dbg !16
  %230 = load i8 addrspace(1)*, i8 addrspace(1)** %b
  %231 = load i8 addrspace(1)*, i8 addrspace(1)** %a
  %232 = call i64 @_bal_array_generic_compare(i8 addrspace(1)* %230, i8 addrspace(1)* %231)
  %233 = icmp ule i64 %232, 1
  store i1 %233, i1* %24
  %234 = load i1, i1* %24, !dbg !17
  %235 = zext i1 %234 to i64, !dbg !17
  %236 = or i64 %235, 72057594037927936, !dbg !17
  %237 = getelementptr i8, i8 addrspace(1)* null, i64 %236, !dbg !17
  call void @_Bb02ioprintln(i8 addrspace(1)* %237), !dbg !17
  store i8 addrspace(1)* null, i8 addrspace(1)** %25, !dbg !17
  %238 = load i8 addrspace(1)*, i8 addrspace(1)** %b
  %239 = load i8 addrspace(1)*, i8 addrspace(1)** %a
  %240 = call i64 @_bal_array_generic_compare(i8 addrspace(1)* %238, i8 addrspace(1)* %239)
  %241 = icmp eq i64 %240, 2
  store i1 %241, i1* %26
  %242 = load i1, i1* %26, !dbg !18
  %243 = zext i1 %242 to i64, !dbg !18
  %244 = or i64 %243, 72057594037927936, !dbg !18
  %245 = getelementptr i8, i8 addrspace(1)* null, i64 %244, !dbg !18
  call void @_Bb02ioprintln(i8 addrspace(1)* %245), !dbg !18
  store i8 addrspace(1)* null, i8 addrspace(1)** %27, !dbg !18
  %246 = load i8 addrspace(1)*, i8 addrspace(1)** %b
  %247 = load i8 addrspace(1)*, i8 addrspace(1)** %a
  %248 = call i64 @_bal_array_generic_compare(i8 addrspace(1)* %246, i8 addrspace(1)* %247)
  %249 = icmp sge i64 %248, 1
  store i1 %249, i1* %28
  %250 = load i1, i1* %28, !dbg !19
  %251 = zext i1 %250 to i64, !dbg !19
  %252 = or i64 %251, 72057594037927936, !dbg !19
  %253 = getelementptr i8, i8 addrspace(1)* null, i64 %252, !dbg !19
  call void @_Bb02ioprintln(i8 addrspace(1)* %253), !dbg !19
  store i8 addrspace(1)* null, i8 addrspace(1)** %29, !dbg !19
  %254 = load i8 addrspace(1)*, i8 addrspace(1)** %a
  %255 = load i8 addrspace(1)*, i8 addrspace(1)** %c
  %256 = call i64 @_bal_array_generic_compare(i8 addrspace(1)* %254, i8 addrspace(1)* %255)
  %257 = icmp eq i64 %256, 0
  store i1 %257, i1* %30
  %258 = load i1, i1* %30, !dbg !20
  %259 = zext i1 %258 to i64, !dbg !20
  %260 = or i64 %259, 72057594037927936, !dbg !20
  %261 = getelementptr i8, i8 addrspace(1)* null, i64 %260, !dbg !20
  call void @_Bb02ioprintln(i8 addrspace(1)* %261), !dbg !20
  store i8 addrspace(1)* null, i8 addrspace(1)** %31, !dbg !20
  %262 = load i8 addrspace(1)*, i8 addrspace(1)** %a
  %263 = load i8 addrspace(1)*, i8 addrspace(1)** %c
  %264 = call i64 @_bal_array_generic_compare(i8 addrspace(1)* %262, i8 addrspace(1)* %263)
  %265 = icmp ule i64 %264, 1
  store i1 %265, i1* %32
  %266 = load i1, i1* %32, !dbg !21
  %267 = zext i1 %266 to i64, !dbg !21
  %268 = or i64 %267, 72057594037927936, !dbg !21
  %269 = getelementptr i8, i8 addrspace(1)* null, i64 %268, !dbg !21
  call void @_Bb02ioprintln(i8 addrspace(1)* %269), !dbg !21
  store i8 addrspace(1)* null, i8 addrspace(1)** %33, !dbg !21
  %270 = load i8 addrspace(1)*, i8 addrspace(1)** %a
  %271 = load i8 addrspace(1)*, i8 addrspace(1)** %c
  %272 = call i64 @_bal_array_generic_compare(i8 addrspace(1)* %270, i8 addrspace(1)* %271)
  %273 = icmp eq i64 %272, 2
  store i1 %273, i1* %34
  %274 = load i1, i1* %34, !dbg !22
  %275 = zext i1 %274 to i64, !dbg !22
  %276 = or i64 %275, 72057594037927936, !dbg !22
  %277 = getelementptr i8, i8 addrspace(1)* null, i64 %276, !dbg !22
  call void @_Bb02ioprintln(i8 addrspace(1)* %277), !dbg !22
  store i8 addrspace(1)* null, i8 addrspace(1)** %35, !dbg !22
  %278 = load i8 addrspace(1)*, i8 addrspace(1)** %a
  %279 = load i8 addrspace(1)*, i8 addrspace(1)** %c
  %280 = call i64 @_bal_array_generic_compare(i8 addrspace(1)* %278, i8 addrspace(1)* %279)
  %281 = icmp sge i64 %280, 1
  store i1 %281, i1* %36
  %282 = load i1, i1* %36, !dbg !23
  %283 = zext i1 %282 to i64, !dbg !23
  %284 = or i64 %283, 72057594037927936, !dbg !23
  %285 = getelementptr i8, i8 addrspace(1)* null, i64 %284, !dbg !23
  call void @_Bb02ioprintln(i8 addrspace(1)* %285), !dbg !23
  store i8 addrspace(1)* null, i8 addrspace(1)** %37, !dbg !23
  %286 = load i8 addrspace(1)*, i8 addrspace(1)** %c
  %287 = load i8 addrspace(1)*, i8 addrspace(1)** %a
  %288 = call i64 @_bal_array_generic_compare(i8 addrspace(1)* %286, i8 addrspace(1)* %287)
  %289 = icmp eq i64 %288, 0
  store i1 %289, i1* %38
  %290 = load i1, i1* %38, !dbg !24
  %291 = zext i1 %290 to i64, !dbg !24
  %292 = or i64 %291, 72057594037927936, !dbg !24
  %293 = getelementptr i8, i8 addrspace(1)* null, i64 %292, !dbg !24
  call void @_Bb02ioprintln(i8 addrspace(1)* %293), !dbg !24
  store i8 addrspace(1)* null, i8 addrspace(1)** %39, !dbg !24
  %294 = load i8 addrspace(1)*, i8 addrspace(1)** %c
  %295 = load i8 addrspace(1)*, i8 addrspace(1)** %a
  %296 = call i64 @_bal_array_generic_compare(i8 addrspace(1)* %294, i8 addrspace(1)* %295)
  %297 = icmp ule i64 %296, 1
  store i1 %297, i1* %40
  %298 = load i1, i1* %40, !dbg !25
  %299 = zext i1 %298 to i64, !dbg !25
  %300 = or i64 %299, 72057594037927936, !dbg !25
  %301 = getelementptr i8, i8 addrspace(1)* null, i64 %300, !dbg !25
  call void @_Bb02ioprintln(i8 addrspace(1)* %301), !dbg !25
  store i8 addrspace(1)* null, i8 addrspace(1)** %41, !dbg !25
  %302 = load i8 addrspace(1)*, i8 addrspace(1)** %c
  %303 = load i8 addrspace(1)*, i8 addrspace(1)** %a
  %304 = call i64 @_bal_array_generic_compare(i8 addrspace(1)* %302, i8 addrspace(1)* %303)
  %305 = icmp eq i64 %304, 2
  store i1 %305, i1* %42
  %306 = load i1, i1* %42, !dbg !26
  %307 = zext i1 %306 to i64, !dbg !26
  %308 = or i64 %307, 72057594037927936, !dbg !26
  %309 = getelementptr i8, i8 addrspace(1)* null, i64 %308, !dbg !26
  call void @_Bb02ioprintln(i8 addrspace(1)* %309), !dbg !26
  store i8 addrspace(1)* null, i8 addrspace(1)** %43, !dbg !26
  %310 = load i8 addrspace(1)*, i8 addrspace(1)** %c
  %311 = load i8 addrspace(1)*, i8 addrspace(1)** %a
  %312 = call i64 @_bal_array_generic_compare(i8 addrspace(1)* %310, i8 addrspace(1)* %311)
  %313 = icmp sge i64 %312, 1
  store i1 %313, i1* %44
  %314 = load i1, i1* %44, !dbg !27
  %315 = zext i1 %314 to i64, !dbg !27
  %316 = or i64 %315, 72057594037927936, !dbg !27
  %317 = getelementptr i8, i8 addrspace(1)* null, i64 %316, !dbg !27
  call void @_Bb02ioprintln(i8 addrspace(1)* %317), !dbg !27
  store i8 addrspace(1)* null, i8 addrspace(1)** %45, !dbg !27
  %318 = load i8 addrspace(1)*, i8 addrspace(1)** %a
  %319 = load i8 addrspace(1)*, i8 addrspace(1)** %d
  %320 = call i64 @_bal_array_generic_compare(i8 addrspace(1)* %318, i8 addrspace(1)* %319)
  %321 = icmp eq i64 %320, 0
  store i1 %321, i1* %46
  %322 = load i1, i1* %46, !dbg !28
  %323 = zext i1 %322 to i64, !dbg !28
  %324 = or i64 %323, 72057594037927936, !dbg !28
  %325 = getelementptr i8, i8 addrspace(1)* null, i64 %324, !dbg !28
  call void @_Bb02ioprintln(i8 addrspace(1)* %325), !dbg !28
  store i8 addrspace(1)* null, i8 addrspace(1)** %47, !dbg !28
  %326 = load i8 addrspace(1)*, i8 addrspace(1)** %a
  %327 = load i8 addrspace(1)*, i8 addrspace(1)** %d
  %328 = call i64 @_bal_array_generic_compare(i8 addrspace(1)* %326, i8 addrspace(1)* %327)
  %329 = icmp ule i64 %328, 1
  store i1 %329, i1* %48
  %330 = load i1, i1* %48, !dbg !29
  %331 = zext i1 %330 to i64, !dbg !29
  %332 = or i64 %331, 72057594037927936, !dbg !29
  %333 = getelementptr i8, i8 addrspace(1)* null, i64 %332, !dbg !29
  call void @_Bb02ioprintln(i8 addrspace(1)* %333), !dbg !29
  store i8 addrspace(1)* null, i8 addrspace(1)** %49, !dbg !29
  %334 = load i8 addrspace(1)*, i8 addrspace(1)** %a
  %335 = load i8 addrspace(1)*, i8 addrspace(1)** %d
  %336 = call i64 @_bal_array_generic_compare(i8 addrspace(1)* %334, i8 addrspace(1)* %335)
  %337 = icmp eq i64 %336, 2
  store i1 %337, i1* %50
  %338 = load i1, i1* %50, !dbg !30
  %339 = zext i1 %338 to i64, !dbg !30
  %340 = or i64 %339, 72057594037927936, !dbg !30
  %341 = getelementptr i8, i8 addrspace(1)* null, i64 %340, !dbg !30
  call void @_Bb02ioprintln(i8 addrspace(1)* %341), !dbg !30
  store i8 addrspace(1)* null, i8 addrspace(1)** %51, !dbg !30
  %342 = load i8 addrspace(1)*, i8 addrspace(1)** %a
  %343 = load i8 addrspace(1)*, i8 addrspace(1)** %d
  %344 = call i64 @_bal_array_generic_compare(i8 addrspace(1)* %342, i8 addrspace(1)* %343)
  %345 = icmp sge i64 %344, 1
  store i1 %345, i1* %52
  %346 = load i1, i1* %52, !dbg !31
  %347 = zext i1 %346 to i64, !dbg !31
  %348 = or i64 %347, 72057594037927936, !dbg !31
  %349 = getelementptr i8, i8 addrspace(1)* null, i64 %348, !dbg !31
  call void @_Bb02ioprintln(i8 addrspace(1)* %349), !dbg !31
  store i8 addrspace(1)* null, i8 addrspace(1)** %53, !dbg !31
  %350 = load i8 addrspace(1)*, i8 addrspace(1)** %d
  %351 = load i8 addrspace(1)*, i8 addrspace(1)** %a
  %352 = call i64 @_bal_array_generic_compare(i8 addrspace(1)* %350, i8 addrspace(1)* %351)
  %353 = icmp eq i64 %352, 0
  store i1 %353, i1* %54
  %354 = load i1, i1* %54, !dbg !32
  %355 = zext i1 %354 to i64, !dbg !32
  %356 = or i64 %355, 72057594037927936, !dbg !32
  %357 = getelementptr i8, i8 addrspace(1)* null, i64 %356, !dbg !32
  call void @_Bb02ioprintln(i8 addrspace(1)* %357), !dbg !32
  store i8 addrspace(1)* null, i8 addrspace(1)** %55, !dbg !32
  %358 = load i8 addrspace(1)*, i8 addrspace(1)** %d
  %359 = load i8 addrspace(1)*, i8 addrspace(1)** %a
  %360 = call i64 @_bal_array_generic_compare(i8 addrspace(1)* %358, i8 addrspace(1)* %359)
  %361 = icmp ule i64 %360, 1
  store i1 %361, i1* %56
  %362 = load i1, i1* %56, !dbg !33
  %363 = zext i1 %362 to i64, !dbg !33
  %364 = or i64 %363, 72057594037927936, !dbg !33
  %365 = getelementptr i8, i8 addrspace(1)* null, i64 %364, !dbg !33
  call void @_Bb02ioprintln(i8 addrspace(1)* %365), !dbg !33
  store i8 addrspace(1)* null, i8 addrspace(1)** %57, !dbg !33
  %366 = load i8 addrspace(1)*, i8 addrspace(1)** %d
  %367 = load i8 addrspace(1)*, i8 addrspace(1)** %a
  %368 = call i64 @_bal_array_generic_compare(i8 addrspace(1)* %366, i8 addrspace(1)* %367)
  %369 = icmp eq i64 %368, 2
  store i1 %369, i1* %58
  %370 = load i1, i1* %58, !dbg !34
  %371 = zext i1 %370 to i64, !dbg !34
  %372 = or i64 %371, 72057594037927936, !dbg !34
  %373 = getelementptr i8, i8 addrspace(1)* null, i64 %372, !dbg !34
  call void @_Bb02ioprintln(i8 addrspace(1)* %373), !dbg !34
  store i8 addrspace(1)* null, i8 addrspace(1)** %59, !dbg !34
  %374 = load i8 addrspace(1)*, i8 addrspace(1)** %d
  %375 = load i8 addrspace(1)*, i8 addrspace(1)** %a
  %376 = call i64 @_bal_array_generic_compare(i8 addrspace(1)* %374, i8 addrspace(1)* %375)
  %377 = icmp sge i64 %376, 1
  store i1 %377, i1* %60
  %378 = load i1, i1* %60, !dbg !35
  %379 = zext i1 %378 to i64, !dbg !35
  %380 = or i64 %379, 72057594037927936, !dbg !35
  %381 = getelementptr i8, i8 addrspace(1)* null, i64 %380, !dbg !35
  call void @_Bb02ioprintln(i8 addrspace(1)* %381), !dbg !35
  store i8 addrspace(1)* null, i8 addrspace(1)** %61, !dbg !35
  %382 = load i8 addrspace(1)*, i8 addrspace(1)** %a
  %383 = load i8 addrspace(1)*, i8 addrspace(1)** %e
  %384 = call i64 @_bal_array_generic_compare(i8 addrspace(1)* %382, i8 addrspace(1)* %383)
  %385 = icmp eq i64 %384, 0
  store i1 %385, i1* %62
  %386 = load i1, i1* %62, !dbg !36
  %387 = zext i1 %386 to i64, !dbg !36
  %388 = or i64 %387, 72057594037927936, !dbg !36
  %389 = getelementptr i8, i8 addrspace(1)* null, i64 %388, !dbg !36
  call void @_Bb02ioprintln(i8 addrspace(1)* %389), !dbg !36
  store i8 addrspace(1)* null, i8 addrspace(1)** %63, !dbg !36
  %390 = load i8 addrspace(1)*, i8 addrspace(1)** %a
  %391 = load i8 addrspace(1)*, i8 addrspace(1)** %e
  %392 = call i64 @_bal_array_generic_compare(i8 addrspace(1)* %390, i8 addrspace(1)* %391)
  %393 = icmp ule i64 %392, 1
  store i1 %393, i1* %64
  %394 = load i1, i1* %64, !dbg !37
  %395 = zext i1 %394 to i64, !dbg !37
  %396 = or i64 %395, 72057594037927936, !dbg !37
  %397 = getelementptr i8, i8 addrspace(1)* null, i64 %396, !dbg !37
  call void @_Bb02ioprintln(i8 addrspace(1)* %397), !dbg !37
  store i8 addrspace(1)* null, i8 addrspace(1)** %65, !dbg !37
  %398 = load i8 addrspace(1)*, i8 addrspace(1)** %a
  %399 = load i8 addrspace(1)*, i8 addrspace(1)** %e
  %400 = call i64 @_bal_array_generic_compare(i8 addrspace(1)* %398, i8 addrspace(1)* %399)
  %401 = icmp eq i64 %400, 2
  store i1 %401, i1* %66
  %402 = load i1, i1* %66, !dbg !38
  %403 = zext i1 %402 to i64, !dbg !38
  %404 = or i64 %403, 72057594037927936, !dbg !38
  %405 = getelementptr i8, i8 addrspace(1)* null, i64 %404, !dbg !38
  call void @_Bb02ioprintln(i8 addrspace(1)* %405), !dbg !38
  store i8 addrspace(1)* null, i8 addrspace(1)** %67, !dbg !38
  %406 = load i8 addrspace(1)*, i8 addrspace(1)** %a
  %407 = load i8 addrspace(1)*, i8 addrspace(1)** %e
  %408 = call i64 @_bal_array_generic_compare(i8 addrspace(1)* %406, i8 addrspace(1)* %407)
  %409 = icmp sge i64 %408, 1
  store i1 %409, i1* %68
  %410 = load i1, i1* %68, !dbg !39
  %411 = zext i1 %410 to i64, !dbg !39
  %412 = or i64 %411, 72057594037927936, !dbg !39
  %413 = getelementptr i8, i8 addrspace(1)* null, i64 %412, !dbg !39
  call void @_Bb02ioprintln(i8 addrspace(1)* %413), !dbg !39
  store i8 addrspace(1)* null, i8 addrspace(1)** %69, !dbg !39
  %414 = load i8 addrspace(1)*, i8 addrspace(1)** %e
  %415 = load i8 addrspace(1)*, i8 addrspace(1)** %a
  %416 = call i64 @_bal_array_generic_compare(i8 addrspace(1)* %414, i8 addrspace(1)* %415)
  %417 = icmp eq i64 %416, 0
  store i1 %417, i1* %70
  %418 = load i1, i1* %70, !dbg !40
  %419 = zext i1 %418 to i64, !dbg !40
  %420 = or i64 %419, 72057594037927936, !dbg !40
  %421 = getelementptr i8, i8 addrspace(1)* null, i64 %420, !dbg !40
  call void @_Bb02ioprintln(i8 addrspace(1)* %421), !dbg !40
  store i8 addrspace(1)* null, i8 addrspace(1)** %71, !dbg !40
  %422 = load i8 addrspace(1)*, i8 addrspace(1)** %e
  %423 = load i8 addrspace(1)*, i8 addrspace(1)** %a
  %424 = call i64 @_bal_array_generic_compare(i8 addrspace(1)* %422, i8 addrspace(1)* %423)
  %425 = icmp ule i64 %424, 1
  store i1 %425, i1* %72
  %426 = load i1, i1* %72, !dbg !41
  %427 = zext i1 %426 to i64, !dbg !41
  %428 = or i64 %427, 72057594037927936, !dbg !41
  %429 = getelementptr i8, i8 addrspace(1)* null, i64 %428, !dbg !41
  call void @_Bb02ioprintln(i8 addrspace(1)* %429), !dbg !41
  store i8 addrspace(1)* null, i8 addrspace(1)** %73, !dbg !41
  %430 = load i8 addrspace(1)*, i8 addrspace(1)** %e
  %431 = load i8 addrspace(1)*, i8 addrspace(1)** %a
  %432 = call i64 @_bal_array_generic_compare(i8 addrspace(1)* %430, i8 addrspace(1)* %431)
  %433 = icmp eq i64 %432, 2
  store i1 %433, i1* %74
  %434 = load i1, i1* %74, !dbg !42
  %435 = zext i1 %434 to i64, !dbg !42
  %436 = or i64 %435, 72057594037927936, !dbg !42
  %437 = getelementptr i8, i8 addrspace(1)* null, i64 %436, !dbg !42
  call void @_Bb02ioprintln(i8 addrspace(1)* %437), !dbg !42
  store i8 addrspace(1)* null, i8 addrspace(1)** %75, !dbg !42
  %438 = load i8 addrspace(1)*, i8 addrspace(1)** %e
  %439 = load i8 addrspace(1)*, i8 addrspace(1)** %a
  %440 = call i64 @_bal_array_generic_compare(i8 addrspace(1)* %438, i8 addrspace(1)* %439)
  %441 = icmp sge i64 %440, 1
  store i1 %441, i1* %76
  %442 = load i1, i1* %76, !dbg !43
  %443 = zext i1 %442 to i64, !dbg !43
  %444 = or i64 %443, 72057594037927936, !dbg !43
  %445 = getelementptr i8, i8 addrspace(1)* null, i64 %444, !dbg !43
  call void @_Bb02ioprintln(i8 addrspace(1)* %445), !dbg !43
  store i8 addrspace(1)* null, i8 addrspace(1)** %77, !dbg !43
  ret void
446:
  %447 = call i8 addrspace(1)* @_bal_panic_construct(i64 772), !dbg !7
  call void @_bal_panic(i8 addrspace(1)* %447)
  unreachable
}
!llvm.module.flags = !{!0}
!llvm.dbg.cu = !{!2}
!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !DIFile(filename:"../../../compiler/testSuite/07-array/order4-v.bal", directory:"")
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false)
!3 = !DISubroutineType(types: !4)
!4 = !{}
!5 = distinct !DISubprogram(name:"main", linkageName:"_B04rootmain", scope: !1, file: !1, line: 3, type: !3, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !6)
!6 = !{}
!7 = !DILocation(line: 0, column: 0, scope: !5)
!8 = !DILocation(line: 10, column: 1, scope: !5)
!9 = !DILocation(line: 11, column: 1, scope: !5)
!10 = !DILocation(line: 12, column: 1, scope: !5)
!11 = !DILocation(line: 13, column: 1, scope: !5)
!12 = !DILocation(line: 15, column: 1, scope: !5)
!13 = !DILocation(line: 16, column: 1, scope: !5)
!14 = !DILocation(line: 17, column: 1, scope: !5)
!15 = !DILocation(line: 18, column: 1, scope: !5)
!16 = !DILocation(line: 20, column: 1, scope: !5)
!17 = !DILocation(line: 21, column: 1, scope: !5)
!18 = !DILocation(line: 22, column: 1, scope: !5)
!19 = !DILocation(line: 23, column: 1, scope: !5)
!20 = !DILocation(line: 25, column: 1, scope: !5)
!21 = !DILocation(line: 26, column: 1, scope: !5)
!22 = !DILocation(line: 27, column: 1, scope: !5)
!23 = !DILocation(line: 28, column: 1, scope: !5)
!24 = !DILocation(line: 30, column: 1, scope: !5)
!25 = !DILocation(line: 31, column: 1, scope: !5)
!26 = !DILocation(line: 32, column: 1, scope: !5)
!27 = !DILocation(line: 33, column: 1, scope: !5)
!28 = !DILocation(line: 35, column: 1, scope: !5)
!29 = !DILocation(line: 36, column: 1, scope: !5)
!30 = !DILocation(line: 37, column: 1, scope: !5)
!31 = !DILocation(line: 38, column: 1, scope: !5)
!32 = !DILocation(line: 40, column: 1, scope: !5)
!33 = !DILocation(line: 41, column: 1, scope: !5)
!34 = !DILocation(line: 42, column: 1, scope: !5)
!35 = !DILocation(line: 43, column: 1, scope: !5)
!36 = !DILocation(line: 45, column: 1, scope: !5)
!37 = !DILocation(line: 46, column: 1, scope: !5)
!38 = !DILocation(line: 47, column: 1, scope: !5)
!39 = !DILocation(line: 48, column: 1, scope: !5)
!40 = !DILocation(line: 50, column: 1, scope: !5)
!41 = !DILocation(line: 51, column: 1, scope: !5)
!42 = !DILocation(line: 52, column: 1, scope: !5)
!43 = !DILocation(line: 53, column: 1, scope: !5)
