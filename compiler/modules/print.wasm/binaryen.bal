import ballerina/io;
public type IntType "i64"|"i32";
public type Type "None"|IntType;

public type Op "AddInt32"|"SubInt32"|"MulInt32"|"DivSInt32"|"DivUInt32"|"RemSInt32"|"RemUInt32"|"EqInt32"|"NeInt32"|"LtSInt32"|"LtUInt32"|"LeSInt32"|"LeUInt32"|"GtSInt32"|"GtUInt32"|"GeSInt32"|"GeUInt32";

type Function record {
    Expression body;
    Type[] vars = [];
    string name;
    string? module = ();
    string? base = ();
    Type[] params = [];
    Type? results = ();
};

type Export record {
    string value;
    string name;
};

type Expression record {
    string? code = ();
};

type Call record {
    *Expression;
    Expression[] operands;
    string target;
    boolean isReturn = false;
    Type ty;
};

type LocalGet record {
    *Expression;
    int index;
    Type ty;
};

type Const record {
    *Expression;
    Literal value;
};

type Return record {
    *Expression;
    Expression? value = ();
};

type Nop record {
    *Expression;
};

type WasmBlock record {
    *Expression;
    Expression[] body = [];
    string? name = ();
};

type If record {
    *Expression;
    Expression condition;
    WasmBlock? elseBody;
    WasmBlock ifBody;
};

type Break record {
    *Expression;
    string label;
};

type WasmLoop record {
    *Expression;
    Expression[] loopBody = [];
    string name;
};

type LiteralInt32 record {
    int i32;
};

type LiteralInt64 record {
    int i64;
};

type Literal LiteralInt32|LiteralInt64;

class Module {
    private Function[] functions = [];
    private string[] imports = [];
    private string[] exports = [];

    function call(string target, Expression[] operands, int numOperands, Type returnType) returns Expression {
        string[] callInst = ["(call $", target];
        foreach int i in 0...numOperands - 1 {
            string? code = operands[i].code;
            if code != () {
                callInst.push(code);
        }
        }
        callInst.push(")");
        return { code: "".'join(...callInst) };
    }

    function localGet(int index, Type ty) returns Expression {
        return { code: "(local.get $" + index.toString() + ")" };
    }

    function addConst(Literal value) returns Expression {
        if value is LiteralInt32 {
            return { code: "(i32.const "+ value.i32.toString() + ")" };
        }
        else {
            return { code: "(i64.const "+ value.i64.toString() + ")" };
        }
    }

    function addReturn(Expression? value = ()) returns Expression {
        string[] inst = ["(return"];
        if value != () {
            string? code = value.code;
            if code != () {
                inst.push(code);
        }
        }
        inst.push(")");
        return { code: " ".'join(...inst) };
    }

    function nop() returns Expression {
        return { code: "(block )" };
    }

    function addFunction(string name, Type[] params, Type results, Type[] varTypes, int numVarTypes, Expression body) {
        Function func = {
            name: name,
            params: params,
            results: results,
            vars: varTypes,
            body: body
        };
        self.functions.push(func);
    }

    function addFunctionImport(string internalName, string externalModuleName, string externalBaseName, Type params, Type results)  {
        string[] funcDef = ["(import \"", externalModuleName, "\" \"", externalBaseName, "\" (func $", internalName, " (param ", params, ")"];
        if results != "None" {
            funcDef.push("(param ");
            funcDef.push(results);
            funcDef.push(")))");
        }
        else{
            funcDef.push("))");
        }
        self.imports.push("".'join(...funcDef));
    }

    function addFunctionExport(string internalName, string externalName) {
        string funcDef = "(export \"" + externalName + "\"" +  " (func $" + internalName + "))";
        self.exports.push(funcDef);
    }

    function binary(Op op, Expression left, Expression right) returns Expression {
        string? leftCode = left.code;
        string? rightCode = right.code;
        string[]  binInst = [];
        if leftCode != () && rightCode != () {
        if op == "AddInt32" {
                binInst.push("(i32.add");
        }
        else if op == "GtSInt32" {
                binInst.push("(i32.gt_s");
        }
        else if op == "MulInt32" {
                binInst.push("(i32.mul");
            }
            else if op == "RemSInt32" {
                binInst.push("(i32.rem_s");
        }
        else {
                panic error("unimplemented");
        }
            binInst.push(leftCode);
            binInst.push(rightCode);
            binInst.push(")");
            return { code : " ".'join(...binInst) };
        }
        panic error("invalid");
    }

    function localSet(int index, Expression value) returns Expression {
        string? code = value.code;
        if code != () {
            return { code : "(local.set $" + index.toString() + code + " )" };
        }
        panic error("invalid");
    }

    function block(string? name, Expression[] children, int numChildren, Type ty) returns Expression {
        WasmBlock block = {
            body : children,
            name : name
        };
        return block;
    }

    // BinaryenModuleDispose and BinaryenModulePrint
    function finish() {
        string[] module = [];
        module.push("(module ");
        foreach string imp in self.imports {
            module.push(" " + imp);
        }
        foreach string exp in self.exports {
            module.push(" " + exp);
        }
        foreach Function func in self.functions {
            string funcParams = "";
            string localParams = "";
            int varCount = 0;
            foreach int i in 0...func.params.length() - 1 {
                funcParams += " (param $" + varCount.toString() + " " + func.params[i] + ")";
                varCount += 1;
            }
            foreach int i in 0...func.vars.length() - 1 {
                    localParams += "(local $" + varCount.toString() + " " + func.vars[i] + ")";
                varCount += 1;
            }
            string funcDef = " (func $" + func.name + funcParams + localParams;
            module.push(funcDef);
            string? funcBody = func.body.code;
            if funcBody != () {
            string[] noSeperateCmd = ["local.get","return","br", "i32.const"];
            int spaces = 2;
            string cmd = "";
            string currentCmd = "";
            boolean cmdIn = false;
                foreach string chr in funcBody {
                if chr == "(" {
                    if containCharacter(cmd) {
                        module.push(cmd);
                    }
                    spaces += 1;
                    cmdIn = true;
                    cmd = printSpaces(spaces);
                    cmd += "(";
                }
                else if chr == ")" {
                    if noSeperateCmd.filter(c => c == getCommand(currentCmd)).length() > 0 {
                        cmd += ")";
                        module.push(cmd);
                        cmd = printSpaces(spaces);
                        currentCmd = "";
                    }
                    else {
                        if containCharacter(cmd) {
                            module.push(cmd);
                        }
                        cmd = printSpaces(spaces);
                        cmd += ")";
                        module.push(cmd);
                        cmd = "";
                    }
                    spaces -= 1;
                }
                else {
                    if chr == " " && cmdIn {
                        currentCmd = cmd;
                        cmdIn = false;
                    }
                    cmd += chr;
                    }
                }
            }
            module.push(" )");
        }
        module.push(")");
        string cmds = "\n".'join(...module);
        io:println(cmds);
    }

}

function printSpaces(int spaceCount) returns string {
    string spaces = "";
    foreach int i in 0...spaceCount - 1 {
        spaces += " ";
    }
    return spaces;
}

function containCharacter(string text) returns boolean {
    foreach string chr in text {
        if chr != " " {
            return true;
        }
    }
    return false;
}

function getCommand(string cmd) returns string {
    string result = "";
    foreach string chr in cmd {
        if chr != " " && chr != "(" {
            result += chr;
        }
    }
    return result;
}