import wso2/nballerina.bir;
import wso2/nballerina.print.wasm;

final readonly & map<wasm:Op> intArithmeticOps = {
    "+": "i64.add",
    "-": "i64.sub",
    "*": "i64.mul",
    "/": "i64.div_s",
    "%": "i64.rem_s"
};

final readonly & map<wasm:Op> binaryBitwiseOp = {
    "|": "i64.or",
    "^": "i64.xor",
    "&": "i64.and",
    ">>>": "i64.shr_s",
    ">>": "i64.shr_u",
    "<<": "i64.shl"
};

final readonly & map<wasm:Op> floatArithmeticOps = {
    "+": "f64.add",
    "-": "f64.sub",
    "*": "f64.mul",
    "/": "f64.div"
};

final RuntimeModule numberMod = "number";

final RuntimeFunction convertToIntFunction = {
    name: "convert_to_int",
    returnType: "i64"
};

final RuntimeFunction convertToFloatFunction = {
    name: "convert_to_float",
    returnType: "f64"
};

final RuntimeFunction floatModulusFunction = {
    name: "_bal_float_rem",
    returnType: "f64"
};

function buildBitwiseBinary(wasm:Module module, bir:IntBitwiseBinaryInsn insn) returns wasm:Expression {
    wasm:Op op = binaryBitwiseOp.get(insn.op);
    wasm:Expression lhs = buildInt(module, insn.operands[0]);
    wasm:Expression rhs = buildInt(module, insn.operands[1]);
    return buildStore(module, insn.result, module.binary(op, lhs, rhs));
}

function buildArithmeticBinary(wasm:Module module, Scaffold scaffold, bir:IntArithmeticBinaryInsn insn) returns wasm:Expression {
    wasm:Op op = intArithmeticOps.get(insn.op);
    wasm:Expression lhs = buildInt(module, insn.operands[0]);
    wasm:Expression rhs = buildInt(module, insn.operands[1]);
    wasm:Expression operation = buildStore(module, insn.result, module.binary(op, lhs, rhs));
    if op != "i64.rem_s" {
        scaffold.addExceptionTag(OVERFLOW_TAG);
        wasm:Expression overflowCheck = checkOverflow(module, op, lhs, rhs);
        return module.block([overflowCheck, operation]);
    }
    return operation;
}

function buildConvertToInt(wasm:Module module, Scaffold scaffold, bir:ConvertToIntInsn insn) returns wasm:Expression {
    var [repr, val] = buildReprValue(module, scaffold, insn.operand);
    var { name, returnType } = convertToIntFunction;
    if repr.base == BASE_REPR_FLOAT {
        return module.localSet(insn.result.number, module.unary("i64.trunc_f64_s", val));
    }
    else if repr.base == BASE_REPR_INT {
        return module.localSet(insn.result.number, val);    
    }
    return module.localSet(insn.result.number, module.structNew(BOXED_INT_TYPE, [module.addConst({ i32: TYPE_INT }), module.call(name, [val], returnType)]));   
}

function buildNoPanicArithmeticBinary(wasm:Module module, bir:IntNoPanicArithmeticBinaryInsn insn) returns wasm:Expression {
    wasm:Expression lhs = buildInt(module, insn.operands[0]);
    wasm:Expression rhs = buildInt(module, insn.operands[1]);
    wasm:Op op = intArithmeticOps.get(insn.op);
    return buildStore(module, insn.result, module.binary(op, lhs, rhs));
}

function checkOverflow(wasm:Module module, wasm:Op op, wasm:Expression op1, wasm:Expression op2) returns wasm:Expression {
    wasm:Expression MAX_INT = module.addConst({ i64: 9223372036854775807 });
    wasm:Expression MIN_INT = module.addConst({ i64: -9223372036854775808 });
    wasm:Expression op1GZ = module.binary("i64.gt_s", op1, module.addConst({ i64: 0 }));
    wasm:Expression op1GEZ = module.binary("i64.ge_s", op1, module.addConst({ i64: 0 }));
    wasm:Expression op2GZ = module.binary("i64.gt_s", op2, module.addConst({ i64: 0 }));
    wasm:Expression op1LZ = module.binary("i64.lt_s", op1, module.addConst({ i64: 0 }));
    wasm:Expression op2LZ = module.binary("i64.lt_s", op2, module.addConst({ i64: 0 }));
    wasm:Expression throw = module.throw(OVERFLOW_TAG);
    if op == "i64.add" {
        wasm:Expression maxSOp2 = module.binary("i64.sub", MAX_INT, op2);
        wasm:Expression minSOp2 = module.binary("i64.sub", MIN_INT, op2);
        wasm:Expression cond1 = module.binary("i32.and", op1GZ, op2GZ);
        wasm:Expression cond1Inner = module.binary("i64.gt_s", op1, maxSOp2);
        wasm:Expression cond2 = module.binary("i32.and", op1LZ, op2LZ);
        wasm:Expression cond2Inner = module.binary("i64.lt_s", op1, minSOp2);
        wasm:Expression elseIfInner = module.addIf(cond2Inner, throw);
        wasm:Expression elseIf = module.addIf(cond2, elseIfInner);
        wasm:Expression ifInner = module.addIf(cond1Inner, throw);
        return module.addIf(cond1, ifInner, elseIf);
    }
    else if op == "i64.sub" {
        wasm:Expression maxAOp2 = module.binary("i64.add", MAX_INT, op2);
        wasm:Expression minAOp2 = module.binary("i64.add", MIN_INT, op2);
        wasm:Expression cond1 = module.binary("i32.and", op1GEZ, op2LZ);
        wasm:Expression cond1Inner = module.binary("i64.gt_s", op1, maxAOp2);
        wasm:Expression cond2 = module.binary("i32.and", op1LZ, op2GZ);
        wasm:Expression cond2Inner = module.binary("i64.lt_s", op1, minAOp2);
        wasm:Expression elseIfInner = module.addIf(cond2Inner, throw);
        wasm:Expression elseIf = module.addIf(cond2, elseIfInner);
        wasm:Expression ifInner = module.addIf(cond1Inner, throw);
        return module.addIf(cond1, ifInner, elseIf);
    }
    else if op == "i64.mul" {
        wasm:Expression maxDOp1 = module.binary("i64.div_s", MAX_INT, op1);
        wasm:Expression minDOp1 = module.binary("i64.div_s", MIN_INT, op1);
        wasm:Expression cond1 = module.binary("i32.and", op1GZ, op2GZ);
        wasm:Expression cond2 = module.binary("i32.and", op1LZ, op2LZ);
        wasm:Expression cond3 = module.binary("i32.and", module.binary("i64.lt_s", op1, module.addConst({ i64: -1 })), op2GZ);
        wasm:Expression cond4 = module.binary("i32.and", op1GZ, op2LZ);
        wasm:Expression cond1Inner = module.binary("i64.gt_s", op2, maxDOp1);
        wasm:Expression cond2Inner = module.binary("i64.lt_s", op2, maxDOp1);
        wasm:Expression cond3Inner = module.binary("i64.gt_s", op2, minDOp1);
        wasm:Expression cond4Inner = module.binary("i64.lt_s", op2, minDOp1);
        wasm:Expression elseIf3Inner = module.addIf(cond4Inner, throw);
        wasm:Expression elseIf3 = module.addIf(cond4, elseIf3Inner);
        wasm:Expression elseIf2Inner = module.addIf(cond3Inner, throw);
        wasm:Expression elseIf2 = module.addIf(cond3, elseIf2Inner, elseIf3);
        wasm:Expression elseIf1Inner = module.addIf(cond2Inner, throw);
        wasm:Expression elseIf1 = module.addIf(cond2, elseIf1Inner, elseIf2);
        wasm:Expression ifInner = module.addIf(cond1Inner, throw);
        return module.addIf(cond1, ifInner, elseIf1);
    }
    else if op == "i64.div_s" {
        wasm:Expression minEOp2 = module.binary("i64.eq", MIN_INT, op1);
        wasm:Expression nEOp2 = module.binary("i64.eq", module.addConst({ i64: -1 }), op2);
        wasm:Expression cond1 = module.binary("i32.and", nEOp2, minEOp2);
        return module.addIf(cond1, throw);
    }
    panic error("impossible");
}

function buildConvertToFloat(wasm:Module module, Scaffold scaffold, bir:ConvertToFloatInsn insn) returns wasm:Expression { 
    var [repr, val] = buildReprValue(module, scaffold, insn.operand);
    var { name, returnType } = convertToFloatFunction;
    if repr.base == BASE_REPR_INT {
        return module.localSet(insn.result.number, module.unary("f64.convert_i64_s", val));
    }
    else if repr.base == BASE_REPR_FLOAT {
        return module.localSet(insn.result.number, module.call(name, [val], returnType));
    }
    else {
        return module.localSet(insn.result.number, module.structNew(FLOAT_TYPE, [module.addConst({ i32: TYPE_FLOAT }), module.call(name, [val], returnType)]));
    }
}

function buildFloatArithmeticBinary(wasm:Module module, bir:FloatArithmeticBinaryInsn insn) returns wasm:Expression {
    wasm:Expression lhs = buildFloat(module, insn.operands[0]);
    wasm:Expression rhs = buildFloat(module, insn.operands[1]);
    wasm:Expression result;
    if insn.op == "%" {
        result = buildRuntimeFunctionCall(module, floatModulusFunction, [lhs, rhs]);
    }
    else {
        wasm:Op op = floatArithmeticOps.get(insn.op);
        result = module.binary(op, lhs, rhs);
    }
    return buildStore(module, insn.result, result);                                  
}

function buildFloatNegate(wasm:Module module, bir:FloatNegateInsn insn) returns wasm:Expression {
    wasm:Expression operand = buildFloat(module, insn.operand);
    wasm:Expression result = module.unary("f64.neg", operand);
    return module.localSet(insn.result.number, result);
}
