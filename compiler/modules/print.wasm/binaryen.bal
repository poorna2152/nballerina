public type BinaryenIntType "i64"|"i32"|"i16"|"i8"|"i1";

public type BinaryenType "None"|BinaryenIntType;

class BinaryenModule {

    function addFunctionImport(string internalName, string externalModuleName, string externalBaseName, BinaryenType params, BinaryenType results) {
        panic error("unimplemented");
    }

    function localGet(int index, BinaryenType ty) returns BinaryenExpression {
        panic error("unimplemented");
    }

    function addFunctionExport(string internalName, string externalName) {
        panic error("unimplemented");
    }

    function addFunction(string name, BinaryenType params, BinaryenType results, BinaryenType[] varTypes, int numVarTypes, BinaryenExpression body) {
        panic error("unimplemented");
    }

    function print() {
        panic error("unimplemented");
    }

    function dispose() {
        panic error("unimplemented");
    }
}



class BinaryenExpression {

}

function makeConst(BinaryenExpression expr) returns BinaryenExpression {
    panic error("unimplemented");
}

function makeLiteralInt32(int value) returns BinaryenExpression {
    panic error("unimplemented");
}

function makeNop() returns BinaryenExpression {
    panic error("unimplemented");
}

function makeReturn(BinaryenExpression? exp = ()) returns BinaryenExpression {
    panic error("unimplemented");
}

function makeCall(string name, BinaryenExpression[] operands, int numOperands, BinaryenType returnVal) returns BinaryenExpression {
    panic error("unimplemented");
}
