import wso2/nballerina.bir;
import wso2/nballerina.print.wasm;

function buildListConstruct(wasm:Module module, Scaffold scaffold, bir:ListConstructInsn insn) returns wasm:Expression {
    final int length = insn.operands.length();
    wasm:Expression list = module.call("arr_create", [module.addConst({ i64: length })], "eqref");
    wasm:Expression setList = module.localSet(insn.result.number, list);
    wasm:Expression[] children = [setList];
    foreach int i in 0 ..< length {
        wasm:Expression arr = module.refAs("ref.as_non_null", module.localGet(insn.result.number));
        wasm:Expression val = buildWideRepr(module, scaffold, insn.operands[i], REPR_ANY, insn.result.semType);
        wasm:Expression index = module.addConst({ i64 : i });
        wasm:Expression setVal = module.call("arr_set", [arr, val, index], "None");
        children.push(setVal);
    }
    return module.block(children);
}

function buildListGet(wasm:Module module, Scaffold scaffold, bir:ListGetInsn insn) returns wasm:Expression {
    wasm:Expression list = module.localGet(insn.operands[0].number);
    wasm:Expression index = module.unary("i32.wrap_i64", buildRepr(module, scaffold, insn.operands[1], REPR_INT));
    wasm:Expression call = module.call("arr_get", [list, index], "eqref");
    return module.localSet(insn.result.number, call);
}

function buildListSet(wasm:Module module, Scaffold scaffold, bir:ListSetInsn insn) returns wasm:Expression {
    wasm:Expression list = buildRepr(module, scaffold, insn.operands[0], REPR_LIST);
    wasm:Expression index = buildRepr(module, scaffold, insn.operands[1], REPR_INT);
    wasm:Expression newMember = buildRepr(module, scaffold, insn.operands[2], REPR_ANY);
    return module.call("arr_set", [list, newMember, index], "None");
}

function buildMappingConstruct(wasm:Module module, Scaffold scaffold, bir:MappingConstructInsn insn) returns wasm:Expression {
    string[] fieldNames = insn.fieldNames;
    bir:Operand[] operands = insn.operands;
    wasm:Expression[] children = [];
    children.push(module.localSet(insn.result.number, module.structNew(MAP_TYPE, [module.call("map_create", [], "anyref")])));
    foreach int i in 0..<fieldNames.length() {
        wasm:Expression convertedToData = module.refAs("ref.as_data", module.localGet(insn.result.number));
        wasm:Expression cast = module.refCast(convertedToData, module.rtt(MAP_TYPE));
        wasm:Expression convertedToDataString = module.refAs("ref.as_data", buildConstString(module, scaffold, fieldNames[i]));
        wasm:Expression castString = module.refCast(convertedToDataString, module.rtt(STRING_TYPE));
        children.push(module.call("map_set", [module.structGet(MAP_TYPE, "val", cast), module.structGet(STRING_TYPE, "val", castString), buildRepr(module, scaffold, operands[i], REPR_ANY)], "None"));
    }
    return module.block(children);
}


function buildMappingGet(wasm:Module module, Scaffold scaffold, bir:MappingGetInsn insn) returns wasm:Expression {
    bir:Register m = insn.operands[0];
    wasm:Expression key = module.structGet(STRING_TYPE, "val", buildString(module, scaffold, insn.operands[1]));
    return module.localSet(insn.result.number, module.call("map_get", [module.structGet(MAP_TYPE, "val", module.localGet(m.number)), key], "anyref"));
}

function buildMappingSet(wasm:Module module, Scaffold scaffold, bir:MappingSetInsn insn) returns wasm:Expression {
    bir:Register m = insn.operands[0];
    wasm:Expression convertedToDataString = module.refAs("ref.as_data", buildString(module, scaffold, insn.operands[1]));
    wasm:Expression castString = module.refCast(convertedToDataString, module.rtt(STRING_TYPE));
    wasm:Expression key = module.structGet(STRING_TYPE, "val", castString);
    wasm:Expression val = buildRepr(module, scaffold, insn.operands[2], REPR_ANY);
    return module.call("map_set", [module.structGet(MAP_TYPE, "val", module.localGet(m.number)), key, val], "anyref");
}
