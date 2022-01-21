import ballerina/test
@test:Config {}

public function printTrue() returns error? {
    Module module = new;
    Type[] localTypes = ["i32"];
    module.addFunctionImport("println", "console", "log", "i32", "None");
    Expression b = module.localGet(0, "i32");
    Expression[] thenCallOperands = [module.addConst({ i32: 1 })];
    Expression thenCall = module.call("println", thenCallOperands, 1, "None");
    Relooper relooper = new(module);
    Block bb0 = relooper.addBlock(module.nop());
    Block bb1 = relooper.addBlock(thenCall);
    Block bb2 = relooper.addBlock(module.addReturn());
    relooper.addBranch(bb0, bb2);
    relooper.addBranch(bb1, bb2);
    relooper.addBranch(bb0, bb1, b);
    Expression body = relooper.render(bb0, 0);
    module.addFunction("printTrue", localTypes, "None", [], 1, body);
    module.addFunctionExport("printTrue", "printTrue");
    module.finish();
}
