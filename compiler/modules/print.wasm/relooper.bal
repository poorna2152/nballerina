class Relooper {

    private Module module;

    function init(Module module) {
        self.module  = module;
    }

    function addBranch(Block fromB, Block to, Expression? condition = ()) {
        panic error("unimplemented");
    }

    function addBlock(Expression code) returns Block {
        panic error("unimplemented");
    }

    function renderAndDispose(Block body, int labelHelper) returns Expression {
        panic error("unimplemented");
    }

}


class Block {

}