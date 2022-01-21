public type IntType "i64"|"i32";
public type Type "None"|IntType;

type Function record {

};

type Export record {
     
};

type Expression record {
    string? code = ();
    string ty = "Base";
};

type WASMBlock record {
    string ty = "Block";
    Expression[] body = [];
    string? name = ();
    string? code = ();
};

type IfExpr record  {
    string ty = "If";
    Expression? condition = ();
    WASMBlock? elseBody = ();
    WASMBlock? ifBody = ();
    string? code = ();
    string? label = ();
};

type Break record {
    string ty = "Break";
    string? code = ();
    string? label = ();
};

type LiteralInt32 record {
    int i32;
    string ty = "i32";
};

type LiteralInt64 record {
    int i64;
    string ty = "i64";
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
        if value.ty == "i32" {
            return { code: "(i32.const "+ (<LiteralInt32>value).i32.toString() + ")" };
        }
        else {
            return { code: "(i64.const "+ (<LiteralInt64>value).i64.toString() + ")" };
        }
    }

    function addReturn(Expression? value = ()) returns Expression {
        if value != () {
            return { code: "(return " + <string>(<Expression>value).code + ")" };     
        }
        return { code: "(return)" };
    }

    function nop() returns Expression {
        return { code: "nop" };
    }
         
    function addFunction(string name, Type[] params, Type results, Type[] varTypes, int numVarTypes, Expression body) {
        string funcParams = "";
        foreach int i in 0...numVarTypes - 1 {
            funcParams += " (param $" + i.toString() + " " + params[i] + ")";
        }
        string funcDef = "(func $" + name + funcParams + "\n" + <string>body.code + " )\n";
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
            int spaceCount = 2;
            boolean skip = true;
            io:print(" ");
            io:print(func);   
        }
        io:println(")");
    }
                                            
}
