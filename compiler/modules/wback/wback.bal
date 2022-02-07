import ballerina/io;

import wso2/nballerina.err;
import wso2/nballerina.bir;
import wso2/nballerina.print.wasm;

type BuildError err:Semantic|err:Unimplemented;

type ImportedFunction record {|
    readonly bir:ExternalSymbol symbol;
    bir:FunctionSignature signature;
|};

table<ImportedFunction> key(symbol) importedFunctions = table[];

function buildModule(bir:Module mod) returns string[]|BuildError {
    bir:FunctionDefn[] functionDefns = mod.getFunctionDefns();
    wasm:Module module = new;
    wasm:Relooper relooper = new(module);
    foreach int i in 0 ..< functionDefns.length() {
        relooper.reset();
        bir:FunctionCode code = check mod.generateFunctionCode(i);
        check bir:verifyFunctionCode(mod, functionDefns[i], code);
        wasm:Expression body = buildFunctionBody(module, relooper, code);
        string funcName = functionDefns[i].symbol.identifier;
        wasm:Type[] params = [];
        wasm:Type[] locals = [];
        // Assuming all params are i32
        foreach int j in 0..< functionDefns[i].signature.paramTypes.length() {
            params.push(<wasm:Type> "i32");
        }
        // Assuming local variables in the function is equal to the number of registers in bir minus number of param types
        // Assuming all local variables are of type i32
        int numLocalVars = code.registers.length() - functionDefns[i].signature.paramTypes.length();
        foreach int j in (params.length() - 1)..<numLocalVars {
            locals.push(<wasm:Type> "i32");
        }
        module.addFunction(funcName, params, "None", locals, 0, body);
        module.addFunctionExport(funcName, funcName);
    }
    return module.finish();
}

function buildFunctionBody(wasm:Module module, wasm:Relooper relooper, bir:FunctionCode code) returns wasm:Expression {
    wasm:Block[] blocks = [];
    foreach var b in code.blocks {
        wasm:Block? bl = buildBasicBlock(module, relooper, b);
        if bl != () {
            blocks.push(bl);
        }
    }
    foreach int i in 0...blocks.length() - 1 {
        buildBranching(module, relooper, code.blocks[i], blocks, i);
    }
    return relooper.render(blocks[0], 0);
}

function buildBasicBlock(wasm:Module module, wasm:Relooper relooper, bir:BasicBlock block) returns wasm:Block? {
    wasm:Expression[] body = [];
    foreach var insn in block.insns {
        if insn is bir:IntArithmeticBinaryInsn {
            body.push(buildArithmeticBinary(module, insn));
        }
        else if insn is bir:IntCompareInsn {
            body.push(buildIntCompare(module, insn));
        }
        else if insn is bir:BooleanCompareInsn {
            body.push(buildBooleanCompare(module, insn));
        }
        else if insn is bir:EqualInsn {
            body.push(buildEqual(module, insn));
        }
        else if insn is bir:IntNegateInsn {
            body.push(buildIntNegateInsn(module, insn));
        }
        else if insn is bir:BooleanNotInsn {
            body.push(buildBooleanNotInsn(module, insn));
        }
        else if insn is bir:RetInsn {
            body.push(buildRet(module, insn));
        }
        else if insn is bir:AssignInsn {
            body.push(buildAssign(module, insn));
        }
        else if insn is bir:CallInsn {
            body.push(buildCall(module, insn));
        }
        // else if insn is bir:CatchInsn {
        //     // nothing to do
        //     // scaffold.panicAddress uses this to figure out where to store the panic info
        // }
        // else if insn is bir:AbnormalRetInsn {
        //     check buildAbnormalRet(builder, scaffold, insn);
        // }
        else {
            continue;
        }
    }
    wasm:Block? blockBody = ();
    if body.length() == 0 {
        body.push(module.nop());
    }
    if body.length() > 1 {
        wasm:Expression bodyBlock = module.block((), body, body.length(), "None");
        blockBody = relooper.addBlock(bodyBlock);
    }
    else {
        blockBody = relooper.addBlock(body[0]);
    }
    return blockBody;
}

function buildBranching(wasm:Module module, wasm:Relooper relooper, bir:BasicBlock block, wasm:Block[] blocks, int index) {
    foreach var insn in block.insns {
        if insn is bir:BranchInsn {
            buildBranch(module, relooper, insn, blocks, index);
        }
        else if insn is bir:CondBranchInsn {
            buildCondBranch(module, relooper, insn, blocks, index);
        }
        else {
            continue;
        }
    }
}

function buildBranch(wasm:Module module, wasm:Relooper relooper, bir:BranchInsn insn, wasm:Block[] blocks, int curr) {
    int dest = insn.dest;
    relooper.addBranch(blocks[curr], blocks[dest]);
}

function buildCondBranch(wasm:Module module, wasm:Relooper relooper, bir:CondBranchInsn insn, wasm:Block[] blocks, int curr) {
    int falseLabel = insn.ifFalse;
    int trueLabel = insn.ifTrue;
    bir:Register operand = insn.operand;
    relooper.addBranch(blocks[curr], blocks[trueLabel], module.localGet(operand.number, "i32"));
    relooper.addBranch(blocks[curr], blocks[falseLabel]);
}

function buildRet(wasm:Module module, bir:RetInsn insn) returns wasm:Expression {
    return module.addReturn();
}

function buildCall(wasm:Module module, bir:CallInsn insn) returns wasm:Expression {
    wasm:Expression[] args = [];
    foreach var arg in insn.args {
        if arg is bir:Register {
            args.push(module.localGet(arg.number, "i32"));
        }
        else if arg is int {
            args.push(module.addConst({ i32: arg }));
        }
    }
    bir:FunctionOperand ref = insn.func;
    if ref is bir:FunctionRef {
        bir:Symbol symbol = ref.symbol;
        if symbol is bir:ExternalSymbol {
            if !importedFunctions.hasKey(symbol) {
                ImportedFunction func = {
                    signature: ref.signature,
                    symbol: symbol
                };
                importedFunctions.add(func);
                module.addFunctionImport(ref.symbol.identifier, <string>symbol.module.organization, symbol.module.names[0], "i32", "None");
            }
        }
    }
    return module.call((<bir:FunctionRef>insn.func).symbol.identifier, args, args.length(), "None");
}

function buildAssign(wasm:Module module, bir:AssignInsn insn) returns wasm:Expression {
    bir:Operand operand = insn.operand;
    if operand is bir:ConstOperand {
        if operand is boolean {
            int op = 1;
            if operand == false {
                op = 0;
            }
            return module.localSet(insn.result.number, module.addConst({ i32: op }));
        }
        else if operand is int {
            return module.localSet(insn.result.number, module.addConst({ i32: operand  }));
        }
        panic error("impossible");
    }
    else {
        return module.localSet(insn.result.number, module.localGet(operand.number, "i32"));
    }
}

function buildIntCompare(wasm:Module module, bir:IntCompareInsn insn) returns wasm:Expression {
    wasm:Op? operation = signedInt32CompareOps[insn.op];
    if operation != () {
        bir:IntOperand op1 = insn.operands[0];
        bir:IntOperand op2 = insn.operands[1];
        wasm:Expression? operand1 = ();
        wasm:Expression? operand2 = ();
        if op1 is bir:Register {
            operand1 = module.localGet(op1.number, "i32");
        }
        else {
            operand1 = module.addConst({ i32: op1 });
        }
        if op2 is bir:Register {
            operand2 = module.localGet(op2.number, "i32");
        }
        else {
            operand2 = module.addConst({ i32: op2 });
        }
        if operand1 != () && operand2 != () {
            return module.localSet(insn.result.number, module.binary(operation, operand1, operand2));
        }
    }
    panic error("unknown operation");
}

function buildArithmeticBinary(wasm:Module module, bir:IntArithmeticBinaryInsn insn) returns wasm:Expression {
    wasm:Op? operation = signedInt32ArithmeticOps[insn.op];
    if operation != () {
        bir:IntOperand op1 = insn.operands[0];
        bir:IntOperand op2 = insn.operands[1];
        wasm:Expression? operand1 = ();
        wasm:Expression? operand2 = ();
        if op1 is bir:Register {
            operand1 = module.localGet(op1.number, "i32");
        }
        else {
            operand1 = module.addConst({ i32: op1});
        }
        if op2 is bir:Register {
            operand2 = module.localGet(op2.number, "i32");
        }
        else {
            operand2 = module.addConst({ i32: op2});
        }
        if operand1 != () && operand2 != () {
            return module.localSet(insn.result.number, module.binary(operation, operand1, operand2));
        }
    }
    panic error("unimplemented");
}

function buildEqual(wasm:Module module, bir:EqualInsn insn) returns wasm:Expression {
        bir:Operand op1 = insn.operands[0];
        bir:Operand op2 = insn.operands[1];
        wasm:Expression? operand1 = ();
        wasm:Expression? operand2 = ();
        if op1 is bir:Register {
            operand1 = module.localGet(op1.number, "i32");
        }
        else {
            int op = 0;
            if op1 == true {
                op = 1;
            }
            operand1 = module.addConst({ i32: op });
        }
        if op2 is bir:Register {
            operand2 = module.localGet(op2.number, "i32");
        }
        else {
            int op = 0;
            if op2 == true {
                op = 1;
            }
            operand2 = module.addConst({ i32: op });
        }
        if operand1 != ()  && operand2 != () {
            return module.binary("EqInt32", operand1, operand2);
        }
        panic error("impossible");
}

function buildIntNegateInsn(wasm:Module module, bir:IntNegateInsn insn) returns wasm:Expression {
    return module.localSet(insn.result.number, module.binary("MulInt32", module.addConst({ i32: -1 }), module.localGet(insn.operand.number, "i32")));
}

function buildBooleanCompare(wasm:Module module, bir:BooleanCompareInsn insn) returns wasm:Expression {
    wasm:Op? operation = signedInt32CompareOps[insn.op];
    if operation != () {
        bir:BooleanOperand op1 = insn.operands[0];
        bir:BooleanOperand op2 = insn.operands[1];
        wasm:Expression? operand1 = ();
        wasm:Expression? operand2 = ();
        if op1 is bir:Register {
            operand1 = module.localGet(op1.number, "i32");
        }
        else {
            if op1 == true {
                operand1 = module.addConst({ i32: 1 });
            }
            else {
                operand1 = module.addConst({ i32: 0 });
            }
        }
        if op2 is bir:Register {
            operand2 = module.localGet(op2.number, "i32");
        }
        else {
            if op2 == true {
                operand2 = module.addConst({ i32: 1 });
            }
            else {
                operand2 = module.addConst({ i32: 0 });
            }
        }
        if operand1 != () && operand2 != () {
            return module.localSet(insn.result.number, module.binary(operation, operand1, operand2));
        }
    }
    panic error("unimplemented");
}

function buildBooleanNotInsn(wasm:Module module, bir:BooleanNotInsn insn) returns wasm:Expression {
    int op1 = insn.operand.number;
    return module.localSet(insn.result.number, module.binary("XorInt32", module.localGet(op1, "i32"), module.addConst({ i32: 0 })));
}

public function compileModule(bir:Module mod, string? outputFilename) returns err:Any|io:Error? {
    string[] module = check buildModule(mod);
    return io:fileWriteLines("./main.wat", module);
}

final readonly & map<wasm:Op> signedInt32ArithmeticOps = {
    "+": "AddInt32",
    "-": "SubInt32",
    "*": "MulInt32",
    "/": "DivSInt32",
    "%": "RemSInt32"
};

final readonly & map<wasm:Op> signedInt32CompareOps = {
    "<": "LtSInt32",
    "<=": "LeSInt32",
    ">": "GtSInt32",
    ">=": "GeSInt32",
    "==": "EqInt32",
    "!=": "NeInt32"
};
