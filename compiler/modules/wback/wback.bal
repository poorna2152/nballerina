import ballerina/io;

import wso2/nballerina.err;
import wso2/nballerina.bir;
import wso2/nballerina.print.wasm;

type BuildError err:Semantic|err:Unimplemented;

final bir:ModuleId runtimeModule = {
    organization: "ballerinai",
    names: ["runtime"]
};

function buildModule(bir:Module mod) returns BuildError? {
    bir:FunctionDefn[] functionDefns = mod.getFunctionDefns();
    wasm:Module module = new;
    wasm:Relooper relooper = new(module);
    foreach int i in 0 ..< functionDefns.length() {
        bir:FunctionCode code = check mod.generateFunctionCode(i);
        check bir:verifyFunctionCode(mod, functionDefns[i], code);
        wasm:Expression body = buildFunctionBody(module, relooper, code);
        string funcName = functionDefns[i].symbol.identifier;
        wasm:Type[] params = [];
        foreach int j in 0...functionDefns[i].signature.paramTypes.length() - 1 {
            params.push(<wasm:Type> "i32");
        }
        module.addFunction(funcName, params, "None", [], 0, body);
        module.finish();
    }
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
    boolean found = false;
    foreach var insn in block.insns {
        if insn is bir:RetInsn {
            found = true;
            body.push(buildRet(module, relooper, insn));
        }
        else if insn is bir:CallInsn {
            found = true;
            body.push(buildCall(module, relooper, insn));
        }
        else {
            continue;
        }
    }
    wasm:Block? blockBody = ();
    if !found {
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
    relooper.addBranch(blocks[curr], blocks[trueLabel], module.localGet(<int>operand.number, "i32"));
    relooper.addBranch(blocks[curr], blocks[falseLabel]);
}

function buildRet(wasm:Module module, wasm:Relooper relooper, bir:RetInsn insn) returns wasm:Expression {
    return module.addReturn();
}

function buildCall(wasm:Module module, wasm:Relooper relooper, bir:CallInsn insn) returns wasm:Expression {
    wasm:Expression[] args = [];
    foreach var arg in insn.args {
        if arg is int {
            args.push(module.addConst({ i32: arg }));
        }
    }
    return module.call((<bir:FunctionRef>insn.func).symbol.identifier, args, args.length(), "None");
}

public function compileModule(bir:Module mod, string? outputFilename) returns err:Any|io:Error? {
    _ = check buildModule(mod);
}