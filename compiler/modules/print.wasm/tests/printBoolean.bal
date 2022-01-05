import ballerina/test;
@test:Config{}
l
public function printBoolean() returns error? {

    Module module = new;

    Type[] localTypes = ["i32"];

    module.addFunctionImport("println", "console", "log", "i32", "None");


    // Get the arguement b
    Expression b = module.localGet(0, "i32");

    // Then call (b == true)
    Expression[] thencallOperands = [makeConst(makeLiteralInt32(1))];
    Expression thenCall = makeCall("println", thencallOperands, 1, "None");

    // Else call (b == false)
    Expression[] elsecallOperands = [makeConst(makeLiteralInt32(0))];
    Expression elseCall = makeCall("println", elsecallOperands, 1, "None");

  
    Relooper relooper = new(module);
    Block bb0 = relooper.addBlock(makeNop());
    Block bb1 = relooper.addBlock(thenCall);
    Block bb2 = relooper.addBlock(elseCall);
    Block bb3 = relooper.addBlock(makeReturn());


    relooper.addBranch(bb1, bb3);
    relooper.addBranch(bb2, bb3);
    relooper.addBranch(bb0, bb2, b);
    relooper.addBranch(bb0, bb1);

    Expression body = relooper.renderAndDispose(bb0, 0);
    
    module.addFunction("printBoolean", "i32", "None", [], 0, body);
    module.addFunctionExport("printBoolean", "printBoolean");

    // Print it out
    module.print();

    // Clean up the module, which owns all the objects we created above
    module.dispose();
  
}