public type IntType "i64"|"i32";

public type Type "None"|IntType;

class Module {

    function addFunctionImport(string internalName, string externalModuleName, string externalBaseName, Type params, Type results) {
        panic error("unimplemented");
    }

    function localGet(int index, Type ty) returns Expression {
        panic error("unimplemented");
    }

    function addFunctionExport(string internalName, string externalName) {
        panic error("unimplemented");
    }

    function addFunction(string name, Type params, Type results, Type[] varTypes, int numVarTypes, Expression body) {
        panic error("unimplemented");
    }

    function print() {
        panic error("unimplemented");
    }

    function dispose() {
        panic error("unimplemented");
    }
}



class Expression {

}

function makeConst(Expression expr) returns Expression {
    panic error("unimplemented");
}

function makeLiteralInt32(int value) returns Expression {
    panic error("unimplemented");
}

function makeNop() returns Expression {
    panic error("unimplemented");
}

function makeReturn(Expression? exp = ()) returns Expression {
    panic error("unimplemented");
}

function makeCall(string name, Expression[] operands, int numOperands, Type returnVal) returns Expression {
    panic error("unimplemented");
}
