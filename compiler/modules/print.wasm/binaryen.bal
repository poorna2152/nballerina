public type IntType "i64"|"i32";
public type Type "None"|IntType;

public type Op "AddInt32"|"SubInt32"|"MulInt32"|"DivSInt32"|"DivUInt32"|"RemSInt32"|"RemUInt32"|"EqInt32"|"NeInt32"|"LtSInt32"|"LtUInt32"|"LeSInt32"|"LeUInt32"|"GtSInt32"|"GtUInt32"|"GeSInt32"|"GeUInt32";

type Function record {
    Expression? body = ();
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
    private string[] functions = [];
    private string[] imports = [];
    private string[] exports = [];

    function call(string target, Expression[] operands, int numOperands, Type returnType) returns Expression {
        string operandsStr = "";
        foreach int i in 0...numOperands - 1 {
            if i == numOperands - 1 {
                operandsStr += <string>operands[i].code;
            }
            else {
                operandsStr += <string>operands[i].code + "\n";
            }
        }
        return { code: "(call $"+ target + operandsStr + ")" };
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
        if value != () {
            return { code: "(return " + <string>(<Expression>value).code + ")" };     
        }
        return { code: "(return)" };
    }

    function nop() returns Expression {
        return { code: "(block )" };
    }
         
    function addFunction(string name, Type[] params, Type results, Type[] varTypes, int numVarTypes, Expression body) {
        string funcParams = "";
        string localParams = "";
        int varCount = 0;
        foreach int i in 0...params.length() - 1 {
            funcParams += " (param $" + varCount.toString() + " " + params[i] + ")";
            varCount += 1;
        }
        foreach int i in 0...varTypes.length() - 1 {
            if i == varTypes.length() - 1 {
                localParams += "  (local $" + varCount.toString() + " " + varTypes[i] + ")";                
            }
            else {
                localParams += "  (local $" + varCount.toString() + " " + varTypes[i] + ")\n";
            }
            varCount += 1;
        }
        string funcDef = "(func $" + name + funcParams + "\n" + localParams + "\n" + <string>body.code + " )\n";
        self.functions.push(funcDef);  
    }

    function addFunctionImport(string internalName, string externalModuleName, string externalBaseName, Type params, Type results)  {
        string funcDef = "(import \"" + externalModuleName + "\" \"" + externalBaseName + "\" (func $" + internalName + " (param " + params + ")";
        if results != "None" {
            funcDef += "(param " + results+ ")))";
        }
        else{
            funcDef += "))";
        }
        self.imports.push(funcDef);
    }

    function addFunctionExport(string internalName, string externalName) {
        string funcDef = "(export \"" + externalName + "\"" +  " (func $" + internalName + "))";
        self.exports.push(funcDef);
    }

    function binary(Op op, Expression left, Expression right) returns Expression {
        if op == "AddInt32" {
            return { code : "(i32.add\n " + <string>left.code + "\n " + <string>right.code + "\n)"};
        }
        else if op == "GtSInt32" {
            return { code : "(i32.gt_s\n " + <string>left.code + "\n " + <string>right.code + "\n)"};
        }
        else if op == "MulInt32" {
            return { code : "(i32.mul\n " + <string>left.code + "\n " + <string>right.code + "\n)"};
        }
        else {
            return { code : "(i32.rem_s\n " + <string>left.code + "\n " + <string>right.code + "\n)"};
        }
    }

    function localSet(int index, Expression value) returns Expression {
        return { code : "(local.set $" + index.toString() + "\n " + <string>value.code + "\n)" };
    }

    function block(string? name, Expression[] children, int numChildren, Type ty) returns Expression {
        WasmBlock block = {
            body : children,
            name : name
        };
        return block;
    }

    // BinaryenModuleDispose and BinaryenModulePrint
    function finish(){
        io:println("(module");
        foreach string imp in self.imports {
            io:println(" "+ imp);
        }
        foreach string exp in self.exports {
            io:println(" "+ exp);
        }
        foreach string func in self.functions {
            io:print(" ");
            io:print(func);   
        }
        io:println(")");
    }
                                            
}