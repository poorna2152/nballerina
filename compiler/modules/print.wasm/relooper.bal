class Relooper {

    private BinaryenModule module;

    function init(BinaryenModule module) {
        self.module  = module;
    }

    function addBranch(RelooperBlock fromB, RelooperBlock to, BinaryenExpression? condition = ()) {
        panic error("unimplemented");
    }

    function addBlock(BinaryenExpression code) returns RelooperBlock {
        panic error("unimplemented");
    }

    function renderAndDispose(RelooperBlock body, int labelHelper) returns BinaryenExpression {
        panic error("unimplemented");
    }

}


class RelooperBlock {

}