public type IntType "i64"|"i32";
public type Type "None"|IntType;

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
    Expression? condition = ();
    WasmBlock? elseBody = ();
    WasmBlock? ifBody = ();
    string? label = ();
};

type Break record {
    *Expression;
    string? label = ();
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
    private Export[] exports = [];

    function call(string target, Expression[] operands, int numOperands, Type returnType) returns Expression {
        Call call = {
            target : target,
            operands : operands,
            ty : returnType
        };
        return call;
    }

    function localGet(int index, Type ty) returns Expression {
        LocalGet localGet = {
            index: index,
            ty : ty
        };
        return localGet;
    }

    function addConst(Literal value) returns Expression {
        Const constVal = {
            value : value
        };
        return constVal;
    }

    function addReturn(Expression? value = ()) returns Expression {
        Return ret = {
            value : value
        };
        return ret;
    }

    function nop() returns Expression {
        Nop nop = {};
        return nop;
    }
         
    function addFunction(string name, Type[] params, Type results, Type[] varTypes, int numVarTypes, Expression body) {
        Function func = {
            name : name,
            body : body,
            params : params,
            results : results,
            vars : varTypes 
        };
        self.functions.push(func);  
    }

    function addFunctionImport(string internalName, string externalModuleName, string externalBaseName, Type[] params, Type results)  {
         Function func = {
            name : internalName,
            module : externalModuleName,
            base : externalBaseName,
            results : results,
            params : params 
        };
        self.functions.push(func);
    }

    function addFunctionExport(string internalName, string externalName) {
        Export exportFunc = {
            value : internalName,
            name : externalName
        };
        self.exports.push(exportFunc);
    }

    // BinaryenModuleDispose and BinaryenModulePrint
    function finish(){
        panic error("unimplemented");
    }
                                            
}
