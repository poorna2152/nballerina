import ballerina/io;
import wso2/nballerina.types as t;
import wso2/nballerina.comm.err;
import wso2/nballerina.bir;
import wso2/nballerina.print.wasm;

type BuildError err:Semantic|err:Unimplemented|err:Internal;

function buildModule(bir:Module mod) returns string[]|BuildError {
    Scaffold scaffold = new;
    bir:FunctionDefn[] functionDefns = mod.getFunctionDefns();
    wasm:Module module = new;
    wasm:Relooper relooper = new(module);
    foreach int i in 0 ..< functionDefns.length() {
        relooper.reset();
        scaffold.reset();
        bir:FunctionCode code = check mod.generateFunctionCode(i);
        check bir:verifyFunctionCode(mod, functionDefns[i], code);
        bir:Region[] sorted = from var e in code.regions
                        order by e.entry ascending select e;
        code.regions = sorted;
        wasm:Expression body = buildFunctionBody(scaffold, module, code);
        string funcName = functionDefns[i].symbol.identifier;
        wasm:Type[] params = [];
        wasm:Type[] locals = [];
        foreach bir:SemType ty in functionDefns[i].signature.paramTypes {
            wasm:Type? wTy = operandType(ty);
            if wTy != () {
                params.push(wTy);
            }
        }
        foreach int j in params.length()..<code.registers.length() {
            wasm:Type? ty = operandType(code.registers[j].semType);
            if ty != () && ty != "None" {
                locals.push(ty);
            }
            else {
                locals.push(<wasm:Type>"i32");
            }
        }
        wasm:Type? retType = operandType(functionDefns[i].signature.returnType);
        if retType != () {
            module.addFunction(funcName, params, retType, locals, locals.length(), body);
            module.addFunctionExport(funcName, funcName);
        }
    }
    module.addFunctionImport("println", "console", "log", ["i64"], "None");
    return module.finish();
}

function checkForEntry(bir:Region[] regions, bir:Label label) returns int? {
    foreach int i in 0..<regions.length() {
        bir:Region region = regions[i];
        if region.entry == label {
            return i;
        }
    }
    return ();
}

function buildFunctionBody(Scaffold scaffold, wasm:Module module, bir:FunctionCode code) returns wasm:Expression {
    wasm:Expression[] blocks = [];
    map<wasm:Expression[]> renderedRegion = {};
    int[] processedBlocks = [];
    int index = code.regions.length() - 1;
    while index >= 0 {
        bir:Region region = code.regions[index];
        wasm:Expression[] curr = [];
        bir:Label? exit = region.exit;
        if region.ty == "Multiple" {
            bir:BasicBlock entry = code.blocks[region.entry];
            bir:Insn lastInsn = entry.insns[entry.insns.length() - 1];
            if lastInsn is bir:CondBranchInsn {
                wasm:Expression[] header =  buildBasicBlock(scaffold, module, entry, region.ty);
                wasm:Expression condition = header.remove(header.length() - 1);
                int? ifIndex = checkForEntry(code.regions, lastInsn.ifTrue);
                wasm:Expression[] ifCode = [];
                int? elseIndex = checkForEntry(code.regions, lastInsn.ifTrue);
                if ifIndex != () {
                    wasm:Expression[]? rendered = renderedRegion[ifIndex.toString()];
                    if rendered != () {
                        ifCode.push(...rendered);
                    }
                }
                else {
                    ifCode = buildBasicBlock(scaffold, module, code.blocks[lastInsn.ifTrue]);
                }
                wasm:Expression ifBody = module.block((), ifCode, 2, "None");
                if ifCode.length() == 1 {
                    ifBody = ifCode[0];
                }
                wasm:Expression[] elseCode = [];
                if elseIndex != () {
                    wasm:Expression[]? rendered = renderedRegion[elseIndex.toString()];
                    if rendered != () {
                        elseCode.push(...rendered);
                    }
                }
                else {
                    elseCode = buildBasicBlock(scaffold, module, code.blocks[lastInsn.ifFalse]);
                }
                wasm:Expression elseBody = module.block((), elseCode, 2, "None");
                if ifCode.length() == 1 {
                    elseBody = elseCode[0];
                }
                if lastInsn.ifFalse == region.exit {
                    curr.push(...header);
                    curr.push(module.addIf(condition, ifBody), elseBody);
                }
                else {
                    curr.push(...header);
                    curr.push(module.addIf(condition, ifBody, elseBody));
                }
                processedBlocks.push(entry.label, lastInsn.ifFalse, lastInsn.ifTrue);
            }
            else {
                panic error("last insn of multiple header should be a conditional branch");
            }
        }
        else if region.ty == "Loop" {
            wasm:Expression[] loopBody = [];
            wasm:Expression? loopExit = ();
            string exitLabel = "";
            string bodyLabel = "";
            string loopLabel = "$block$" + region.entry.toString() + "$break";
            bir:BasicBlock entry = code.blocks[region.entry];
            bir:Insn insn = entry.insns[entry.insns.length() - 1];
            if insn is bir:CondBranchInsn {
                exitLabel = "$block$" + insn.ifFalse.toString() + "$break";
                bodyLabel = "$block$" + insn.ifTrue.toString() + "$break";
            }
            wasm:Expression loopHeader = module.block(bodyLabel, buildBasicBlock(scaffold, module, entry), 2 , "None");
            processedBlocks.push(entry.label);
            if exit != () {
                int? regIndex = checkForEntry(code.regions, exit);
                if processedBlocks.indexOf(exit) == () {
                    loopExit = module.block((), buildBasicBlock(scaffold, module, code.blocks[exit]), 2 , "None");
                    processedBlocks.push(exit);
                }
                else if regIndex != () {
                    wasm:Expression[]? renderdExit = renderedRegion[regIndex.toString()];
                    if renderdExit != () {
                        loopExit = module.block((), renderdExit, 2 , "None");
                    }
                }
                foreach int i in (entry.label + 1)..<exit {
                    int? bodIndex = checkForEntry(code.regions, i);
                    if processedBlocks.indexOf(i) == () {
                        loopBody.push(module.block((), buildBasicBlock(scaffold, module, code.blocks[i]), 2 , "None"));
                        processedBlocks.push(i);
                    }
                    else if bodIndex != () {
                        wasm:Expression[]? rendered = renderedRegion[bodIndex.toString()];
                        if rendered != () {
                            loopBody.push(...rendered);
                        }
                    }
                }
            }
                wasm:Expression Lbody = module.block((), loopBody, 2, "None");
                    wasm:Expression loop = module.loop(loopLabel, [loopHeader, Lbody]);
                    wasm:Expression l = module.block(exitLabel, [loop], 1, "None");
            curr.push(l);
            if loopExit != () {
                curr.push(loopExit);
                }
            }
            else {
            int last = code.regions.length();
            if exit != () {
                last = exit;
                    }
            foreach int j in region.entry..<last {
                int? bodIndex = checkForEntry(code.regions, j);
                if processedBlocks.indexOf(j) == () {
                    processedBlocks.push(j);
                    curr.push(...buildBasicBlock(scaffold, module, code.blocks[j]));
                }
                else if bodIndex != () {
                    wasm:Expression[]? rendered = renderedRegion[bodIndex.toString()];
                    if rendered != () {
                        curr.push(...rendered);
                    }
                }
            }
        }
        if region.ty != "Loop" {
            blocks.push(...curr);
        }
        renderedRegion[index.toString()] = curr;
        index = index - 1;
    }
    wasm:Expression[]? parent = renderedRegion["0"];
    if parent != () {
        return module.block((), parent, parent.length(), "None");
    }
    return module.nop();
}

function buildBasicBlock(Scaffold scaffold, wasm:Module module, bir:BasicBlock block, bir:RegionType? ty = (), boolean isBranchBacward = false) returns wasm:Expression[] {
    wasm:Expression[] body = [];
    foreach var insn in block.insns {
        if insn is bir:IntArithmeticBinaryInsn {
            body.push(buildArithmeticBinary(module, scaffold, insn));
        }
        else if insn is bir:CompareInsn {
            body.push(buildCompare(module, insn));
        }
        else if insn is bir:EqualityInsn {
            body.push(buildEquality(module, insn));
        }
        else if insn is bir:CondNarrowInsn {
            body.push(buildCondNarrow(module, insn));
        }
        else if insn is bir:BooleanNotInsn {
            body.push(buildBooleanNotInsn(module, insn));
        }
        else if insn is bir:RetInsn {
            body.push(buildRet(module, insn));
        }
        else if insn is bir:AssignInsn {
            wasm:Expression? expr = buildAssign(module, insn);
            if expr != () {
                body.push(expr);
            }
        }
        else if insn is bir:CallInsn {
            body.push(buildCall(module, insn));
        }
        else if insn is bir:BranchInsn {
            if isBranchBacward {
                body.push(buildBranch(module, insn));
            }
        }
        else if insn is bir:CondBranchInsn {
            body.push(buildCondBranch(module, insn, ty));
        }
        else {
            continue;
        }
    }
    return body;
}

function buildBranch(wasm:Module module, bir:BranchInsn insn) returns wasm:Expression {
    int trueLabel = insn.dest;
    return module.br("$block$" + trueLabel.toString() + "$break");
}

function buildCondBranch(wasm:Module module, bir:CondBranchInsn insn, bir:RegionType? ty = ()) returns wasm:Expression {
    bir:Register operand = insn.operand;
    wasm:Type? condType = operandType(operand.semType);
    if condType != () {
        if ty == "Multiple" {
            return module.localGet(operand.number, condType);
        }
        wasm:Expression ifBr = module.br("$block$" + insn.ifTrue.toString() + "$break");
        wasm:Expression elseBr = module.br("$block$" + insn.ifFalse.toString() + "$break");
        return module.addIf(module.localGet(operand.number, condType), ifBr, elseBr);
    }
    panic error("impossible");

}

function buildRet(wasm:Module module, bir:RetInsn insn) returns wasm:Expression {
    wasm:Expression? retVal = getOperand(module, insn.operand);
    return module.addReturn(retVal);
}

function buildCall(wasm:Module module, bir:CallInsn insn) returns wasm:Expression {
    wasm:Expression[] args = [];
    bir:FunctionOperand ref = insn.func;
    foreach var arg in insn.args {
        wasm:Expression? argExpr = getOperand(module, arg);
        if argExpr != () {
            args.push(argExpr);
        }
    }
    if ref is bir:FunctionRef {
        wasm:Type? resultTy = operandType(insn.result.semType);
        if resultTy != () {
            wasm:Expression call = module.call(ref.symbol.identifier, args, args.length(), resultTy);
            if resultTy != "None" {
                return module.localSet(insn.result.number, call);
            }
            return call;
        }
    }
    panic error("invalid");
}

function buildAssign(wasm:Module module, bir:AssignInsn insn) returns wasm:Expression? {
    wasm:Type? operandTy = operandType(insn.result.semType);
    if operandTy != () {
        wasm:Expression? assign = getOperand(module, insn.operand);
        if assign != () {
            return module.localSet(insn.result.number, assign);
        }
        return ();
    }
    return ();
}

function buildCondNarrow(wasm:Module module, bir:CondNarrowInsn insn) returns wasm:Expression {
    bir:Register operand = insn.operand;
    wasm:Type? operandTy = operandType(insn.operand.semType);
    if operandTy != () {
        return module.localSet(insn.result.number, module.localGet(operand.number, <wasm:Type>operandTy));
    }
    panic error("impossible");
}

function buildCompare(wasm:Module module, bir:CompareInsn insn) returns wasm:Expression {
    wasm:Expression? operand1 = getOperand(module, insn.operands[0]);
    wasm:Expression? operand2 = getOperand(module, insn.operands[1]);
    wasm:Type ty = "i32";
    if operandType(insn.operands[0].semType) == "i64" || operandType(insn.operands[1].semType) == "i64" {
        ty = "i64";
    }
    wasm:Op? operation = ();
    if ty == "i64" {
        operation = signedInt64CompareOps[insn.op];
    }
    else if ty == "i32" {
        operation = signedInt32CompareOps[insn.op];
    }
    if operand1 != () && operand2 != () && operation != () {
        return module.localSet(insn.result.number, module.binary(operation, operand1, operand2));
    }
    panic error("unknown operation");
}

function buildArithmeticBinary(wasm:Module module, Scaffold scaffold, bir:IntArithmeticBinaryInsn insn) returns wasm:Expression {
    wasm:Op? operation = signedInt64ArithmeticOps[insn.op];
    if operation != () {
        wasm:Expression? operand1 = getOperand(module, insn.operands[0]);
        wasm:Expression? operand2 = getOperand(module, insn.operands[1]);
        if operand1 != () && operand2 != () {
            wasm:Expression oper = module.localSet(insn.result.number, module.binary(operation, operand1, operand2));
            return oper;
        }
    }
    panic error("unimplemented");
}

function buildEquality(wasm:Module module, bir:EqualityInsn insn) returns wasm:Expression {
        wasm:Expression? operand1 = getOperand(module, insn.operands[0]);
        wasm:Expression? operand2 = getOperand(module, insn.operands[1]);
        wasm:Type ty = "i32";
        if operandType(insn.operands[0].semType) == "i64" || operandType(insn.operands[1].semType) == "i64" {
            ty = "i64";
        }
        if operand1 != ()  && operand2 != () {
            bir:EqualityOp operation = insn.op;
            wasm:Op op = "i32.eq";
            if operation == "==" {
                if ty == "i64" {
                    op = "i64.eq";
                }
            }
            else if operation == "!=" {
                op = "i32.ne";
                if ty == "i64" {
                    op = "i64.ne";
                }
            }
            wasm:Type? retType = operandType(insn.result.semType);
            if retType != () && retType != "None" {
                return module.localSet(insn.result.number, module.binary(op, operand1, operand2));
            }
            return module.binary(op, operand1, operand2);
        }
        panic error("impossible");
}

function buildBooleanNotInsn(wasm:Module module, bir:BooleanNotInsn insn) returns wasm:Expression {
    int op1 = insn.operand.number;
    return module.localSet(insn.result.number, module.binary("i32.xor", module.localGet(op1, "i32"), module.addConst({ i32: 1 })));
}

function operandType(bir:SemType operand) returns wasm:Type? {
    bir:SemType op = t:widenToUniformTypes(operand);
    if op == t:BOOLEAN {
        return "i32";
    }
    else if op == t:INT {
        return "i64";
    }
    else if op == t:NIL {
        return "None";
    }
    return ();
}

function getOperand(wasm:Module module, bir:Operand operand) returns wasm:Expression? {
    wasm:Type? ty = operandType(operand.semType);
    if operand is bir:Register {
        if ty != () && ty != "None" {
            return module.localGet(operand.number, <wasm:Type>ty);
        }
        else if ty == "None" {
            return ();
        }
        panic error("impossible");
    }
    else {
        if ty == "i64" {
            t:SingleValue val = operand.value;
            if val is int {
                return module.addConst({ i64: val });
            }
        }
        else if ty == "i32" {
            t:SingleValue val = operand.value;
            if val is boolean {
                int intVal = 0;
                if val {
                    intVal = 1;
                }
                return module.addConst({ i32: intVal });
            }
        }
        else if ty == "None" {
            return ();
        }
        panic error("impossible");
    }
}

public function compileModule(bir:Module mod, string? outputFilename) returns io:Error? {
    do {
	    string[] module = check buildModule(mod);
        if outputFilename != () {
            return io:fileWriteLines(outputFilename, module);
        }
    }
    on fail var e {
        io:println(e);
    }
}

final readonly & map<wasm:Op> signedInt64ArithmeticOps = {
    "+": "i64.add",
    "-": "i64.sub",
    "*": "i64.mul",
    "/": "i64.div_s",
    "%": "i64.rem_s"
};

final readonly & map<wasm:Op> signedInt32CompareOps = {
    "<": "i32.lt_s",
    "<=": "i32.le_s",
    ">": "i32.gt_s",
    ">=": "i32.ge_s",
    "==": "i32.eq",
    "!=": "i32.ne"
};

final readonly & map<wasm:Op> signedInt64CompareOps = {
    "<": "i64.lt_s",
    "<=": "i64.le_s",
    ">": "i64.gt_s",
    ">=": "i64.ge_s",
    "==": "i64.eq",
    "!=": "i64.ne"
};