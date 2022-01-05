public function main() returns error? {

    BinaryenModule module = new;

    BinaryenType[] localTypes = ["i32"];

    module.addFunctionImport("println", "console", "log", "i32", "None");


    // Get the arguement b
    BinaryenExpression b = module.localGet(0, "i32");

    // Then call (b == true)
    BinaryenExpression[] thencallOperands = [makeConst(makeLiteralInt32(1))];
    BinaryenExpression thenCall = makeCall("println", thencallOperands, 1, "None");

    // Else call (b == false)
    BinaryenExpression[] elsecallOperands = [makeConst(makeLiteralInt32(0))];
    BinaryenExpression elseCall = makeCall("println", elsecallOperands, 1, "None");

  
    Relooper relooper = new(module);
    RelooperBlock bb0 = relooper.addBlock(makeNop());
    RelooperBlock bb1 = relooper.addBlock(thenCall);
    RelooperBlock bb2 = relooper.addBlock(elseCall);
    RelooperBlock bb3 = relooper.addBlock(makeReturn());


    relooper.addBranch(bb1, bb3);
    relooper.addBranch(bb2, bb3);
    relooper.addBranch(bb0, bb2, b);
    relooper.addBranch(bb0, bb1);

    BinaryenExpression body = relooper.renderAndDispose(bb0, 0);
    
    module.addFunction("printBoolean", "i32", "None", [], 0, body);
    module.addFunctionExport("printBoolean", "printBoolean");

    // Print it out
    module.print();

    // Clean up the module, which owns all the objects we created above
    module.dispose();
  
}