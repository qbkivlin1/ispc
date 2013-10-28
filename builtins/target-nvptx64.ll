;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Define the standard library builtins for the NOVEC target
define(`MASK',`i32')
define(`WIDTH',`1')

include(`util.m4')

include(`svml.m4')
svml_stubs(float,f,WIDTH)
svml_stubs(double,d,WIDTH)

; Define some basics for a 1-wide target
stdlib_core()
packed_load_and_store()
scans()
int64minmax()
aossoa()
rdrand_decls()

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; masked store

gen_masked_store(i8)
gen_masked_store(i16)
gen_masked_store(i32)
gen_masked_store(i64)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; unaligned loads/loads+broadcasts


masked_load(i8,  1)
masked_load(i16, 2)
masked_load(i32, 4)
masked_load(float, 4)
masked_load(i64, 8)
masked_load(double, 8)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; gather/scatter

; define these with the macros from stdlib.m4

gen_gather_factored(i8)
gen_gather_factored(i16)
gen_gather_factored(i32)
gen_gather_factored(float)
gen_gather_factored(i64)
gen_gather_factored(double)

gen_scatter(i8)
gen_scatter(i16)
gen_scatter(i32)
gen_scatter(float)
gen_scatter(i64)
gen_scatter(double)


;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;
declare i32 @llvm.nvvm.read.ptx.sreg.tid.x() nounwind readnone
declare i32 @llvm.nvvm.read.ptx.sreg.ctaid.x() nounwind readnone
declare i32 @llvm.nvvm.read.ptx.sreg.ctaid.y() nounwind readnone
declare i32 @llvm.nvvm.read.ptx.sreg.ctaid.z() nounwind readnone
declare i32 @llvm.nvvm.read.ptx.sreg.nctaid.x() nounwind readnone
declare i32 @llvm.nvvm.read.ptx.sreg.nctaid.y() nounwind readnone
declare i32 @llvm.nvvm.read.ptx.sreg.nctaid.z() nounwind readnone
declare i32 @llvm.nvvm.read.ptx.sreg.warpsize() nounwind readnone

define i32 @__tid_x()  nounwind readnone alwaysinline
{
 %tid = call i32 @llvm.nvvm.read.ptx.sreg.tid.x()
 ret i32 %tid
}
define i32 @__warpsize()  nounwind readnone alwaysinline
{
 %tid = call i32 @llvm.nvvm.read.ptx.sreg.warpsize()
 ret i32 %tid
}


define i32 @__ctaid_x()  nounwind readnone alwaysinline
{
 %bid = call i32 @llvm.nvvm.read.ptx.sreg.ctaid.x()
 ret i32 %bid
}
define i32 @__ctaid_y()  nounwind readnone alwaysinline
{
 %bid = call i32 @llvm.nvvm.read.ptx.sreg.ctaid.y()
 ret i32 %bid
}
define i32 @__ctaid_z()  nounwind readnone alwaysinline
{
 %bid = call i32 @llvm.nvvm.read.ptx.sreg.ctaid.z()
 ret i32 %bid
}

define i32 @__nctaid_x()  nounwind readnone alwaysinline
{
 %nb = call i32 @llvm.nvvm.read.ptx.sreg.nctaid.x()
 ret i32 %nb
}
define i32 @__nctaid_y()  nounwind readnone alwaysinline
{
 %nb = call i32 @llvm.nvvm.read.ptx.sreg.nctaid.y()
 ret i32 %nb
}
define i32 @__nctaid_z()  nounwind readnone alwaysinline
{
 %nb = call i32 @llvm.nvvm.read.ptx.sreg.nctaid.z()
 ret i32 %nb
}

;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;

define  <1 x i8> @__vselect_i8(<1 x i8>, <1 x i8> ,
                               <1 x i32> %mask) nounwind readnone alwaysinline {
;  %mv = trunc <1 x i32> %mask to <1 x i8>
;  %notmask = xor <1 x i8> %mv, <i8 -1>
;  %cleared_old = and <1 x i8> %0, %notmask
;  %masked_new = and <1 x i8> %1, %mv
;  %new = or <1 x i8> %cleared_old, %masked_new
;  ret <1 x i8> %new

   ; not doing this the easy way because of problems with LLVM's scalarizer
;   %cmp = icmp eq <1 x i32> %mask, <i32 0>
;   %sel = select <1 x i1> %cmp, <1 x i8> %0, <1 x i8> %1
    %m = extractelement <1 x i32> %mask, i32 0
    %cmp = icmp eq i32 %m, 0
    %d0 = extractelement <1 x i8> %0, i32 0
    %d1 = extractelement <1 x i8> %1, i32 0
    %sel = select i1 %cmp, i8 %d0, i8 %d1    
    %r = insertelement <1 x i8> undef, i8 %sel, i32 0
   ret <1 x i8> %r
}

define  <1 x i16> @__vselect_i16(<1 x i16>, <1 x i16> ,
                                 <1 x i32> %mask) nounwind readnone alwaysinline {
;  %mv = trunc <1 x i32> %mask to <1 x i16>
;  %notmask = xor <1 x i16> %mv, <i16 -1>
;  %cleared_old = and <1 x i16> %0, %notmask
;  %masked_new = and <1 x i16> %1, %mv
;  %new = or <1 x i16> %cleared_old, %masked_new
;  ret <1 x i16> %new
;   %cmp = icmp eq <1 x i32> %mask, <i32 0>
;   %sel = select <1 x i1> %cmp, <1 x i16> %0, <1 x i16> %1
    %m = extractelement <1 x i32> %mask, i32 0
    %cmp = icmp eq i32 %m, 0
    %d0 = extractelement <1 x i16> %0, i32 0
    %d1 = extractelement <1 x i16> %1, i32 0
    %sel = select i1 %cmp, i16 %d0, i16 %d1    
    %r = insertelement <1 x i16> undef, i16 %sel, i32 0
   ret <1 x i16> %r

;   ret <1 x i16> %sel
}


define  <1 x i32> @__vselect_i32(<1 x i32>, <1 x i32> ,
                                 <1 x i32> %mask) nounwind readnone alwaysinline {
;  %notmask = xor <1 x i32> %mask, <i32 -1>
;  %cleared_old = and <1 x i32> %0, %notmask
;  %masked_new = and <1 x i32> %1, %mask
;  %new = or <1 x i32> %cleared_old, %masked_new
;  ret <1 x i32> %new
;   %cmp = icmp eq <1 x i32> %mask, <i32 0>
;   %sel = select <1 x i1> %cmp, <1 x i32> %0, <1 x i32> %1
;   ret <1 x i32> %sel
    %m = extractelement <1 x i32> %mask, i32 0
    %cmp = icmp eq i32 %m, 0
    %d0 = extractelement <1 x i32> %0, i32 0
    %d1 = extractelement <1 x i32> %1, i32 0
    %sel = select i1 %cmp, i32 %d0, i32 %d1    
    %r = insertelement <1 x i32> undef, i32 %sel, i32 0
   ret <1 x i32> %r

}

define  <1 x i64> @__vselect_i64(<1 x i64>, <1 x i64> ,
                                 <1 x i32> %mask) nounwind readnone alwaysinline {
;  %newmask = zext <1 x i32> %mask to <1 x i64>
;  %notmask = xor <1 x i64> %newmask, <i64 -1>
;  %cleared_old = and <1 x i64> %0, %notmask
;  %masked_new = and <1 x i64> %1, %newmask
;  %new = or <1 x i64> %cleared_old, %masked_new
;  ret <1 x i64> %new
;   %cmp = icmp eq <1 x i32> %mask, <i32 0>
;   %sel = select <1 x i1> %cmp, <1 x i64> %0, <1 x i64> %1
;   ret <1 x i64> %sel
    %m = extractelement <1 x i32> %mask, i32 0
    %cmp = icmp eq i32 %m, 0
    %d0 = extractelement <1 x i64> %0, i32 0
    %d1 = extractelement <1 x i64> %1, i32 0
    %sel = select i1 %cmp, i64 %d0, i64 %d1    
    %r = insertelement <1 x i64> undef, i64 %sel, i32 0
   ret <1 x i64> %r

}

define  <1 x float> @__vselect_float(<1 x float>, <1 x float>,
                                     <1 x i32> %mask) nounwind readnone alwaysinline {
;  %v0 = bitcast <1 x float> %0 to <1 x i32>
;  %v1 = bitcast <1 x float> %1 to <1 x i32>
;  %r = call <1 x i32> @__vselect_i32(<1 x i32> %v0, <1 x i32> %v1, <1 x i32> %mask)
;  %rf = bitcast <1 x i32> %r to <1 x float>
;  ret <1 x float> %rf
;   %cmp = icmp eq <1 x i32> %mask, <i32 0>
;   %sel = select <1 x i1> %cmp, <1 x float> %0, <1 x float> %1
;   ret <1 x float> %sel
    %m = extractelement <1 x i32> %mask, i32 0
    %cmp = icmp eq i32 %m, 0
    %d0 = extractelement <1 x float> %0, i32 0
    %d1 = extractelement <1 x float> %1, i32 0
    %sel = select i1 %cmp, float %d0, float %d1    
    %r = insertelement <1 x float> undef, float %sel, i32 0
   ret <1 x float> %r

}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; masked store

define void @__masked_store_blend_i8(<1 x i8>* nocapture, <1 x i8>,
                                     <1 x i32> %mask) nounwind alwaysinline {
  %val = load <1 x i8> * %0, align 4
  %newval = call <1 x i8> @__vselect_i8(<1 x i8> %val, <1 x i8> %1, <1 x i32> %mask) 
  store <1 x i8> %newval, <1 x i8> * %0, align 4
  ret void
}

define void @__masked_store_blend_i16(<1 x i16>* nocapture, <1 x i16>, 
                                      <1 x i32> %mask) nounwind alwaysinline {
  %val = load <1 x i16> * %0, align 4
  %newval = call <1 x i16> @__vselect_i16(<1 x i16> %val, <1 x i16> %1, <1 x i32> %mask) 
  store <1 x i16> %newval, <1 x i16> * %0, align 4
  ret void
}

define void @__masked_store_blend_i32(<1 x i32>* nocapture, <1 x i32>, 
                                     <1 x i32> %mask) nounwind alwaysinline {
  %val = load <1 x i32> * %0, align 4
  %newval = call <1 x i32> @__vselect_i32(<1 x i32> %val, <1 x i32> %1, <1 x i32> %mask) 
  store <1 x i32> %newval, <1 x i32> * %0, align 4
  ret void
}

define void @__masked_store_blend_i64(<1 x i64>* nocapture, <1 x i64>,
                                      <1 x i32> %mask) nounwind alwaysinline {
  %val = load <1 x i64> * %0, align 4
  %newval = call <1 x i64> @__vselect_i64(<1 x i64> %val, <1 x i64> %1, <1 x i32> %mask) 
  store <1 x i64> %newval, <1 x i64> * %0, align 4
  ret void
}

masked_store_float_double()

define  i64 @__movmsk(<1 x i32>) nounwind readnone alwaysinline {
  %item = extractelement <1 x i32> %0, i32 0
  %v = lshr i32 %item, 31
  %v64 = zext i32 %v to i64
  ret i64 %v64
}

define  i1 @__any(<1 x i32>) nounwind readnone alwaysinline {
  %item = extractelement <1 x i32> %0, i32 0
  %v = lshr i32 %item, 31
  %cmp = icmp ne i32 %v, 0
  ret i1 %cmp
}

define  i1 @__all(<1 x i32>) nounwind readnone alwaysinline {
  %item = extractelement <1 x i32> %0, i32 0
  %v = lshr i32 %item, 31
  %cmp = icmp eq i32 %v, 1
  ret i1 %cmp
}

define  i1 @__none(<1 x i32>) nounwind readnone alwaysinline {
  %item = extractelement <1 x i32> %0, i32 0
  %v = lshr i32 %item, 31
  %cmp = icmp eq i32 %v, 0
  ret i1 %cmp
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; rounding
;;
;; There are not any rounding instructions in SSE2, so we have to emulate
;; the functionality with multiple instructions...

; The code for __round_* is the result of compiling the following source
; code.
;
; export float Round(float x) {
;    unsigned int sign = signbits(x);
;    unsigned int ix = intbits(x);
;    ix ^= sign;
;    x = floatbits(ix);
;    x += 0x1.0p23f;
;    x -= 0x1.0p23f;
;    ix = intbits(x);
;    ix ^= sign;
;    x = floatbits(ix);
;    return x;
;}

define  <1 x float> @__round_varying_float(<1 x float>) nounwind readonly alwaysinline {
  %float_to_int_bitcast.i.i.i.i = bitcast <1 x float> %0 to <1 x i32>
  %bitop.i.i = and <1 x i32> %float_to_int_bitcast.i.i.i.i, <i32 -2147483648>
  %bitop.i = xor <1 x i32> %float_to_int_bitcast.i.i.i.i, %bitop.i.i
  %int_to_float_bitcast.i.i40.i = bitcast <1 x i32> %bitop.i to <1 x float>
  %binop.i = fadd <1 x float> %int_to_float_bitcast.i.i40.i, <float 8.388608e+06>
  %binop21.i = fadd <1 x float> %binop.i, <float -8.388608e+06>
  %float_to_int_bitcast.i.i.i = bitcast <1 x float> %binop21.i to <1 x i32>
  %bitop31.i = xor <1 x i32> %float_to_int_bitcast.i.i.i, %bitop.i.i
  %int_to_float_bitcast.i.i.i = bitcast <1 x i32> %bitop31.i to <1 x float>
  ret <1 x float> %int_to_float_bitcast.i.i.i
}

;; Similarly, for implementations of the __floor* functions below, we have the
;; bitcode from compiling the following source code...

;export float Floor(float x) {
;    float y = Round(x);
;    unsigned int cmp = y > x ? 0xffffffff : 0;
;    float delta = -1.f;
;    unsigned int idelta = intbits(delta);
;    idelta &= cmp;
;    delta = floatbits(idelta);
;    return y + delta;
;}

define  <1 x float> @__floor_varying_float(<1 x float>) nounwind readonly alwaysinline {
  %calltmp.i = tail call <1 x float> @__round_varying_float(<1 x float> %0) nounwind
  %bincmp.i = fcmp ogt <1 x float> %calltmp.i, %0
  %val_to_boolvec32.i = sext <1 x i1> %bincmp.i to <1 x i32>
  %bitop.i = and <1 x i32> %val_to_boolvec32.i, <i32 -1082130432>
  %int_to_float_bitcast.i.i.i = bitcast <1 x i32> %bitop.i to <1 x float>
  %binop.i = fadd <1 x float> %calltmp.i, %int_to_float_bitcast.i.i.i
  ret <1 x float> %binop.i
}

;; And here is the code we compiled to get the __ceil* functions below
;
;export uniform float Ceil(uniform float x) {
;    uniform float y = Round(x);
;    uniform int yltx = y < x ? 0xffffffff : 0;
;    uniform float delta = 1.f;
;    uniform int idelta = intbits(delta);
;    idelta &= yltx;
;    delta = floatbits(idelta);
;    return y + delta;
;}

define  <1 x float> @__ceil_varying_float(<1 x float>) nounwind readonly alwaysinline {
  %calltmp.i = tail call <1 x float> @__round_varying_float(<1 x float> %0) nounwind
  %bincmp.i = fcmp olt <1 x float> %calltmp.i, %0
  %val_to_boolvec32.i = sext <1 x i1> %bincmp.i to <1 x i32>
  %bitop.i = and <1 x i32> %val_to_boolvec32.i, <i32 1065353216>
  %int_to_float_bitcast.i.i.i = bitcast <1 x i32> %bitop.i to <1 x float>
  %binop.i = fadd <1 x float> %calltmp.i, %int_to_float_bitcast.i.i.i
  ret <1 x float> %binop.i
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; rounding doubles

; expecting math lib to provide this
declare double @ceil (double) nounwind readnone
declare double @floor (double) nounwind readnone
declare double @round (double) nounwind readnone
;declare float     @llvm.sqrt.f32(float %Val)
declare double    @llvm.sqrt.f64(double %Val)
declare float     @llvm.sin.f32(float %Val)
declare float     @llvm.cos.f32(float %Val)
declare float     @llvm.sqrt.f32(float %Val)
declare float     @llvm.exp.f32(float %Val)
declare float     @llvm.log.f32(float %Val)
declare float     @llvm.pow.f32(float %f, float %e)

declare float     @llvm.nvvm.rsqrt.approx.f(float %f) nounwind readonly alwaysinline
declare float     @llvm.nvvm.sqrt.f(float %f) nounwind readonly alwaysinline
declare double    @llvm.nvvm.rsqrt.approx.d(double %f) nounwind readonly alwaysinline
declare double    @llvm.nvvm.sqrt.d(double %f) nounwind readonly alwaysinline




;; stuff that could be in builtins ...

define(`unary1to1', `
  %v_0 = extractelement <1 x $1> %0, i32 0
  %r_0 = call $1 $2($1 %v_0)
  %ret_0 = insertelement <1 x $1> undef, $1 %r_0, i32 0
  ret <1 x $1> %ret_0
')



;; dummy 1 wide vector ops
define  void
@__aos_to_soa4_float1(<1 x float> %v0, <1 x float> %v1, <1 x float> %v2,
        <1 x float> %v3, <1 x float> * noalias %out0, 
        <1 x float> * noalias %out1, <1 x float> * noalias %out2, 
        <1 x float> * noalias %out3) nounwind alwaysinline { 

  store <1 x float> %v0, <1 x float > * %out0
  store <1 x float> %v1, <1 x float > * %out1
  store <1 x float> %v2, <1 x float > * %out2
  store <1 x float> %v3, <1 x float > * %out3

  ret void
}

define  void
@__soa_to_aos4_float1(<1 x float> %v0, <1 x float> %v1, <1 x float> %v2,
        <1 x float> %v3, <1 x float> * noalias %out0, 
        <1 x float> * noalias %out1, <1 x float> * noalias %out2, 
        <1 x float> * noalias %out3) nounwind alwaysinline { 
  call void @__aos_to_soa4_float1(<1 x float> %v0, <1 x float> %v1, 
    <1 x float> %v2, <1 x float> %v3, <1 x float> * %out0, 
    <1 x float> * %out1, <1 x float> * %out2, <1 x float> * %out3)
  ret void
}

define  void
@__aos_to_soa3_float1(<1 x float> %v0, <1 x float> %v1,
         <1 x float> %v2, <1 x float> * %out0, <1 x float> * %out1,
         <1 x float> * %out2) {
  store <1 x float> %v0, <1 x float > * %out0
  store <1 x float> %v1, <1 x float > * %out1
  store <1 x float> %v2, <1 x float > * %out2

  ret void
}

define  void
@__soa_to_aos3_float1(<1 x float> %v0, <1 x float> %v1,
         <1 x float> %v2, <1 x float> * %out0, <1 x float> * %out1,
         <1 x float> * %out2) {
  call void @__aos_to_soa3_float1(<1 x float> %v0, <1 x float> %v1,
         <1 x float> %v2, <1 x float> * %out0, <1 x float> * %out1,
         <1 x float> * %out2)
  ret void
}


;; end builtins


define  <1 x double> @__round_varying_double(<1 x double>) nounwind readonly alwaysinline {
  unary1to1(double, @round)
}

define  <1 x double> @__floor_varying_double(<1 x double>) nounwind readonly alwaysinline {
  unary1to1(double, @floor)
}


define  <1 x double> @__ceil_varying_double(<1 x double>) nounwind readonly alwaysinline {
  unary1to1(double, @ceil)
}

; To do vector integer min and max, we do the vector compare and then sign
; extend the i1 vector result to an i32 mask.  The __vselect does the
; rest...

define  <1 x i32> @__min_varying_int32(<1 x i32>, <1 x i32>) nounwind readonly alwaysinline {
  %c = icmp slt <1 x i32> %0, %1
  %mask = sext <1 x i1> %c to <1 x i32>
  %v = call <1 x i32> @__vselect_i32(<1 x i32> %1, <1 x i32> %0, <1 x i32> %mask)
  ret <1 x i32> %v
}

define  i32 @__min_uniform_int32(i32, i32) nounwind readonly alwaysinline {
  %c = icmp slt i32 %0, %1
  %r = select i1 %c, i32 %0, i32 %1
  ret i32 %r
}

define  <1 x i32> @__max_varying_int32(<1 x i32>, <1 x i32>) nounwind readonly alwaysinline {
  %c = icmp sgt <1 x i32> %0, %1
  %mask = sext <1 x i1> %c to <1 x i32>
  %v = call <1 x i32> @__vselect_i32(<1 x i32> %1, <1 x i32> %0, <1 x i32> %mask)
  ret <1 x i32> %v
}

define  i32 @__max_uniform_int32(i32, i32) nounwind readonly alwaysinline {
  %c = icmp sgt i32 %0, %1
  %r = select i1 %c, i32 %0, i32 %1
  ret i32 %r
}

; The functions for unsigned ints are similar, just with unsigned
; comparison functions...

define  <1 x i32> @__min_varying_uint32(<1 x i32>, <1 x i32>) nounwind readonly alwaysinline {
  %c = icmp ult <1 x i32> %0, %1
  %mask = sext <1 x i1> %c to <1 x i32>
  %v = call <1 x i32> @__vselect_i32(<1 x i32> %1, <1 x i32> %0, <1 x i32> %mask)
  ret <1 x i32> %v
}

define  i32 @__min_uniform_uint32(i32, i32) nounwind readonly alwaysinline {
  %c = icmp ult i32 %0, %1
  %r = select i1 %c, i32 %0, i32 %1
  ret i32 %r
}

define  <1 x i32> @__max_varying_uint32(<1 x i32>, <1 x i32>) nounwind readonly alwaysinline {
  %c = icmp ugt <1 x i32> %0, %1
  %mask = sext <1 x i1> %c to <1 x i32>
  %v = call <1 x i32> @__vselect_i32(<1 x i32> %1, <1 x i32> %0, <1 x i32> %mask)
  ret <1 x i32> %v
}

define  i32 @__max_uniform_uint32(i32, i32) nounwind readonly alwaysinline {
  %c = icmp ugt i32 %0, %1
  %r = select i1 %c, i32 %0, i32 %1
  ret i32 %r
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; horizontal ops / reductions

declare i32 @llvm.ctpop.i32(i32) nounwind readnone

declare i16 @__reduce_add_int8(<WIDTH x i8>) nounwind readnone
declare i32 @__reduce_add_int16(<WIDTH x i16>) nounwind readnone

define  i32 @__popcnt_int32(i32) nounwind readonly alwaysinline {
  %call = call i32 @llvm.ctpop.i32(i32 %0)
  ret i32 %call
}

declare i64 @llvm.ctpop.i64(i64) nounwind readnone

define  i64 @__popcnt_int64(i64) nounwind readonly alwaysinline {
  %call = call i64 @llvm.ctpop.i64(i64 %0)
  ret i64 %call
}


define  float @__reduce_add_float(<1 x float> %v) nounwind readonly alwaysinline {
  %r = extractelement <1 x float> %v, i32 0
  ret float %r
}

define  float @__reduce_min_float(<1 x float>) nounwind readnone {
  %r = extractelement <1 x float> %0, i32 0
  ret float %r
}

define  float @__reduce_max_float(<1 x float>) nounwind readnone {
  %r = extractelement <1 x float> %0, i32 0
  ret float %r
}

define  i32 @__reduce_add_int32(<1 x i32> %v) nounwind readnone {
  %r = extractelement <1 x i32> %v, i32 0
  ret i32 %r
}

define  i32 @__reduce_min_int32(<1 x i32>) nounwind readnone {
  %r = extractelement <1 x i32> %0, i32 0
  ret i32 %r
}

define  i32 @__reduce_max_int32(<1 x i32>) nounwind readnone {
  %r = extractelement <1 x i32> %0, i32 0
  ret i32 %r
}

define  i32 @__reduce_min_uint32(<1 x i32>) nounwind readnone {
  %r = extractelement <1 x i32> %0, i32 0
  ret i32 %r
}

define  i32 @__reduce_max_uint32(<1 x i32>) nounwind readnone {
  %r = extractelement <1 x i32> %0, i32 0
  ret i32 %r
 }


define  double @__reduce_add_double(<1 x double>) nounwind readnone {
  %m = extractelement <1 x double> %0, i32 0
  ret double %m
}

define  double @__reduce_min_double(<1 x double>) nounwind readnone {
  %m = extractelement <1 x double> %0, i32 0
  ret double %m
}

define  double @__reduce_max_double(<1 x double>) nounwind readnone {
  %m = extractelement <1 x double> %0, i32 0
  ret double %m
}

define  i64 @__reduce_add_int64(<1 x i64>) nounwind readnone {
  %m = extractelement <1 x i64> %0, i32 0
  ret i64 %m
}

define  i64 @__reduce_min_int64(<1 x i64>) nounwind readnone {
  %m = extractelement <1 x i64> %0, i32 0
  ret i64 %m
}

define  i64 @__reduce_max_int64(<1 x i64>) nounwind readnone {
  %m = extractelement <1 x i64> %0, i32 0
  ret i64 %m
}

define  i64 @__reduce_min_uint64(<1 x i64>) nounwind readnone {
  %m = extractelement <1 x i64> %0, i32 0
  ret i64 %m
}

define  i64 @__reduce_max_uint64(<1 x i64>) nounwind readnone {
  %m = extractelement <1 x i64> %0, i32 0
  ret i64 %m
}

define  i1 @__reduce_equal_int32(<1 x i32> %vv, i32 * %samevalue,
                                      <1 x i32> %mask) nounwind alwaysinline {
  %v=extractelement <1 x i32> %vv, i32 0
  store i32 %v, i32 * %samevalue
  ret i1 true

}

define  i1 @__reduce_equal_float(<1 x float> %vv, float * %samevalue,
                                      <1 x i32> %mask) nounwind alwaysinline {
  %v=extractelement <1 x float> %vv, i32 0
  store float %v, float * %samevalue
  ret i1 true

}

define  i1 @__reduce_equal_int64(<1 x i64> %vv, i64 * %samevalue,
                                      <1 x i32> %mask) nounwind alwaysinline {
  %v=extractelement <1 x i64> %vv, i32 0
  store i64 %v, i64 * %samevalue
  ret i1 true

}

define  i1 @__reduce_equal_double(<1 x double> %vv, double * %samevalue,
                                      <1 x i32> %mask) nounwind alwaysinline {
  %v=extractelement <1 x double> %vv, i32 0
  store double %v, double * %samevalue
  ret i1 true

}

; extracting/reinserting elements because I want to be able to remove vectors later on

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; rcp

define  <1 x float> @__rcp_varying_float(<1 x float>) nounwind readonly alwaysinline {
  ;%call = call <1 x float> @llvm.x86.sse.rcp.ps(<1 x float> %0)
  ; do one N-R iteration to improve precision
  ;  float iv = __rcp_v(v);
  ;  return iv * (2. - v * iv);
  ;%v_iv = fmul <1 x float> %0, %call
  ;%two_minus = fsub <1 x float> <float 2., float 2., float 2., float 2.>, %v_iv  
  ;%iv_mul = fmul <1 x float> %call, %two_minus
  ;ret <1 x float> %iv_mul
  %d = extractelement <1 x float> %0, i32 0
  %r = fdiv float 1.,%d
  %rv = insertelement <1 x float> undef, float %r, i32 0
  ret <1 x float> %rv
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; sqrt

define  <1 x float> @__sqrt_varying_float(<1 x float> %v) nounwind readonly alwaysinline {
  %vs = extractelement <1 x float> %v, i32 0
  %rs = call float @llvm.nvvm.sqrt.f(float %vs)
  %rv = insertelement <1 x float> undef , float %rs, i32 0
  ret <1 x float> %rv
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; rsqrt


define  <1 x float> @__rsqrt_varying_float(<1 x float> %v) nounwind readonly alwaysinline {
  %vs = extractelement <1 x float> %v, i32 0
  %rs = call float @llvm.nvvm.rsqrt.approx.f(float %vs)
;  %rs = call float asm "rsqrt.approx.f32 $0,$0", "=f,f"(float %vs)  ; example of inline ptx
  %rv = insertelement <1 x float> undef , float %rs, i32 0
  ret <1 x float> %rv
}
define  <1 x double> @__rsqrt_varying_double(<1 x double> %v) nounwind readonly alwaysinline {
  %vs = extractelement <1 x double> %v, i32 0
  %rs = call double @llvm.nvvm.rsqrt.approx.d(double %vs)
  %rv = insertelement <1 x double> undef , double %rs, i32 0
  ret <1 x double> %rv
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; float min/max

define  <1 x float> @__max_varying_float(<1 x float>, <1 x float>) nounwind readonly alwaysinline {
;  %call = call <1 x float> @llvm.x86.sse.max.ps(<1 x float> %0, <1 x float> %1)
;  ret <1 x float> %call
  %a = extractelement <1 x float> %0, i32 0
  %b = extractelement <1 x float> %1, i32 0
  %d = fcmp ogt float %a, %b  
  %r = select i1 %d, float %a, float %b
  %rv = insertelement <1 x float> undef, float %r, i32 0
  ret <1 x float> %rv    
}

define  <1 x float> @__min_varying_float(<1 x float>, <1 x float>) nounwind readonly alwaysinline {
;  %call = call <1 x float> @llvm.x86.sse.min.ps(<1 x float> %0, <1 x float> %1)
;  ret <1 x float> %call
  %a = extractelement <1 x float> %0, i32 0
  %b = extractelement <1 x float> %1, i32 0
  %d = fcmp olt float %a, %b  
  %r = select i1 %d, float %a, float %b
  %rv = insertelement <1 x float> undef, float %r, i32 0
  ret <1 x float> %rv    

}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; double precision sqrt

;declare <2 x double> @llvm.x86.sse2.sqrt.pd(<2 x double>) nounwind readnone

define  <1 x double> @__sqrt_varying_double(<1 x double>) nounwind alwaysinline {
  ;unarya2to4(ret, double, @llvm.x86.sse2.sqrt.pd, %0)
  ;ret <1 x double> %ret
  unary1to1(double, @llvm.sqrt.f64)
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; double precision min/max

;declare <2 x double> @llvm.x86.sse2.max.pd(<2 x double>, <2 x double>) nounwind readnone
;declare <2 x double> @llvm.x86.sse2.min.pd(<2 x double>, <2 x double>) nounwind readnone

define  <1 x double> @__min_varying_double(<1 x double>, <1 x double>) nounwind readnone {
  ;binarsy2to4(ret, double, @llvm.x86.sse2.min.pd, %0, %1)
  ;ret <1 x double> %ret
  %a = extractelement <1 x double> %0, i32 0
  %b = extractelement <1 x double> %1, i32 0
  %d = fcmp olt double %a, %b  
  %r = select i1 %d, double %a, double %b
  %rv = insertelement <1 x double> undef, double %r, i32 0
  ret <1 x double> %rv    

}

define  <1 x double> @__max_varying_double(<1 x double>, <1 x double>) nounwind readnone {
  ;binary2sto4(ret, double, @llvm.x86.sse2.max.pd, %0, %1)
  ;ret <1 x double> %ret
  %a = extractelement <1 x double> %0, i32 0
  %b = extractelement <1 x double> %1, i32 0
  %d = fcmp ogt double %a, %b  
  %r = select i1 %d, double %a, double %b
  %rv = insertelement <1 x double> undef, double %r, i32 0
  ret <1 x double> %rv    

}


define  float @__rcp_uniform_float(float) nounwind readonly alwaysinline {
;    uniform float iv = extract(__rcp_u(v), 0);
;    return iv * (2. - v * iv);
  %r = fdiv float 1.,%0
  ret float %r
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; rounding floats

define  float @__round_uniform_float(float) nounwind readonly alwaysinline {
  ; roundss, round mode nearest 0b00 | don't signal precision exceptions 0b1000 = 8
  ; the roundss intrinsic is a total mess--docs say:
  ;
  ;  __m128 _mm_round_ss (__m128 a, __m128 b, const int c)
  ;       
  ;  b is a 128-bit parameter. The lowest 32 bits are the result of the rounding function
  ;  on b0. The higher order 96 bits are copied directly from input parameter a. The
  ;  return value is described by the following equations:
  ;
  ;  r0 = RND(b0)
  ;  r1 = a1
  ;  r2 = a2
  ;  r3 = a3
  ;
  ;  It doesn't matter what we pass as a, since we only need the r0 value
  ;  here.  So we pass the same register for both.
  %v = insertelement<1 x float> undef, float %0, i32 0
  %rv = call <1 x float> @__round_varying_float(<1 x float> %v)
  %r=extractelement <1 x float> %rv, i32 0
  ret float %r

}

define  float @__floor_uniform_float(float) nounwind readonly alwaysinline {
  %v = insertelement<1 x float> undef, float %0, i32 0
  %rv = call <1 x float> @__floor_varying_float(<1 x float> %v)
  %r=extractelement <1 x float> %rv, i32 0
  ret float %r

}

define  float @__ceil_uniform_float(float) nounwind readonly alwaysinline {
  %v = insertelement<1 x float> undef, float %0, i32 0
  %rv = call <1 x float> @__ceil_varying_float(<1 x float> %v)
  %r=extractelement <1 x float> %rv, i32 0
  ret float %r
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; rounding doubles


define  double @__round_uniform_double(double) nounwind readonly alwaysinline {
       %rs=call double @round(double %0)
       ret double %rs
}

define  double @__floor_uniform_double(double) nounwind readonly alwaysinline {
  %rs = call double @floor(double %0)
  ret double %rs
}

define  double @__ceil_uniform_double(double) nounwind readonly alwaysinline {
  %rs = call double @ceil(double %0)
  ret double %rs
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; sqrt


define  float @__sqrt_uniform_float(float) nounwind readonly alwaysinline {
  %ret = call float @llvm.sqrt.f32(float %0)
  ret float %ret
}

define  double @__sqrt_uniform_double(double) nounwind readonly alwaysinline {
  %ret = call double @llvm.sqrt.f64(double %0)
  ret double %ret
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; rsqrt


define  float @__rsqrt_uniform_float(float) nounwind readonly alwaysinline {
  %s = call float @__sqrt_uniform_float(float %0)
  %r = call float @__rcp_uniform_float(float %s)
  ret float %r
}




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; fastmath


define  void @__fastmath() nounwind alwaysinline {
 ; no-op
  ret void
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; float min/max


define  float @__max_uniform_float(float, float) nounwind readonly alwaysinline {
  %d = fcmp ogt float %0, %1 
  %r = select i1 %d, float %0, float %1
  ret float %r

}

define  float @__min_uniform_float(float, float) nounwind readonly alwaysinline {
  %d = fcmp olt float %0, %1 
  %r = select i1 %d, float %0, float %1
  ret float %r

}
define  double @__max_uniform_double(double, double) nounwind readonly alwaysinline {
  %d = fcmp ogt double %0, %1 
  %r = select i1 %d, double %0, double %1
  ret double %r

}

define  double @__min_uniform_double(double, double) nounwind readonly alwaysinline {
  %d = fcmp olt double %0, %1 
  %r = select i1 %d, double %0, double %1
  ret double %r

}

define_shuffles()

ctlztz()

define_prefetches()

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; half conversion routines

declare float @__half_to_float_uniform(i16 %v) nounwind readnone
declare <WIDTH x float> @__half_to_float_varying(<WIDTH x i16> %v) nounwind readnone
declare i16 @__float_to_half_uniform(float %v) nounwind readnone
declare <WIDTH x i16> @__float_to_half_varying(<WIDTH x float> %v) nounwind readnone

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; int8/int16 builtins

define_avgs()
