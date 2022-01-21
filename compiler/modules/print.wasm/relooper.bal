type Block record {
    Expression code;
    int id;
    BlockBranchMap[] branchesOut = [];
    Block[] branchesIn =[];
};

type Branch record {
    Expression? condition =();
};

type BlockBranchMap record {
    Branch branch;
    Block block;
};

type SimpleShape record {
    string ty = "Simple";
    Block inner;
    Shape? next = ();
};

type MultipleShape record {
    string ty = "Multiple";
    Shape? next = ();
    map<Shape?> handledBlocks = {};
}; 

type LoopShape record {
    string ty = "Loop";
    Shape? inner;
    Shape? next;
};

type Shape SimpleShape|MultipleShape|LoopShape;

class Relooper {
    private Module module;
    private Branch[] branches =[];
    private Block[] blocks = [];
    private int blockId = 1;
    private Block[] entries =[];
    private Block root = ();

    function init(Module module) {
        self.module = module;
    }

    function addBranch(Block fromB, Block to, Expression? condition = ()) {
        Branch branch = {
            condition: condition
        };
        BlockBranchMap blockBranch = {
            block: to,
            branch: branch
        };
        fromB.branchesOut.push(blockBranch);
        to.branchesIn.push(fromB);
    }

    function addBlock(Expression code) returns Block {
        Block block = {
            code: code,
            id: self.blockId
        };
        self.blockId = self.blockId + 1;
        self.blocks.push(block);
        return block;
    }

    function checkExistence(Block[] blocks, int id) returns boolean {
        foreach Block b in blocks {
            if b.id == id {
                return true;
            }
        }
        return false;
    } 

    function createSimpleShape(Block[] blocks, Block entry) returns Shape {
        Block[] nextEntries = [];
        foreach BlockBranchMap next in entry.branchesOut {
            if self.checkExistence(blocks, next.block.id) {
                nextEntries.push(next.block);
            }
            next.block.branchesIn = next.block.branchesIn.filter(b => b.id != entry.id);
        }
        Block[] validBlocks = blocks.filter(b => b.id != entry.id);
        SimpleShape simple = {
            inner: entry,
            next: self.calculate(validBlocks,nextEntries)
        };
        return simple;
    }

    function createLoopShape(Block[] blocks, Block[] entries) returns Shape {
        Block[] nextEntries = [];
        Block[] innerBlocks = [];
        Block[] validBlocks = blocks.clone();
        foreach Block entry in entries {
            foreach Block prev in entry.branchesIn {
                if innerBlocks.indexOf(prev) == () {
                    innerBlocks.push(prev);
                    validBlocks = blocks.filter(b => b.id != prev.id);
                }
            }    
        }
        foreach Block inner in innerBlocks {
            foreach BlockBranchMap block in inner.branchesOut {
                if innerBlocks.indexOf(block.block) == () {
                    nextEntries.push(block.block);
                }
            }
        }
        LoopShape loop = {
            inner: self.calculate(innerBlocks, entries),
            next : self.calculate(validBlocks, nextEntries)
        };
        return loop;
    }

    function invalidateChildren(Block block, map<Block?> ownership, map<Block[]?> independentGroups) {
        Block[] queue = [block];
        while queue.length() > 0 {
            Block curr = queue.remove(0);
            int? index = ownership.keys().indexOf(curr.id.toString());
            if index == () {
                continue;
            }
            else {
                Block? owner = ownership[curr.id.toString()];
                if owner == () {
                    continue;
                }
                else {
                    Block[] ownerGroup = <Block[]>independentGroups[owner.id.toString()];
                    ownerGroup = ownerGroup.filter(b => b.id != curr.id);
                    independentGroups[owner.id.toString()] = ownerGroup;
                    ownership[curr.id.toString()] = ();
                    foreach BlockBranchMap child in curr.branchesOut {
                        queue.push(child.block);
                    }
                }
            }
        }
    }

    function findIndependentBlocks(Block[] entries) returns map<Block[]> {
        map<Block[]> independentGroups = {};
        map<Block?> ownership = {};
        foreach Block entry in entries {
            ownership[entry.id.toString()] = entry;
            independentGroups[entry.id.toString()] = [entry];
        }
        Block[] queue = entries.clone();
        while queue.length() > 0 {
            Block curr = queue.remove(0);
            int? index = ownership.keys().indexOf(curr.id.toString());
            if index != () {
                Block? owner = ownership[curr.id.toString()];
                if owner == () {
                    continue;
                }
                else {
                    foreach BlockBranchMap child in curr.branchesOut {
                        index = ownership.keys().indexOf(child.block.id.toString());
                        if index == () {
                            queue.push(child.block);
                            ownership[child.block.id.toString()] = owner;
                            Block[] group = <Block[]>independentGroups[owner.id.toString()];
                            group.push(child.block);            
                            independentGroups[owner.id.toString()] = group;
                        }
                        else {
                            Block? existingOwner = ownership[child.block.id.toString()];
                            if existingOwner == () {
                                continue;
                            }
                            else if existingOwner.id != owner.id {
                                self.invalidateChildren(child.block, ownership, independentGroups);
                            } 
                        }
                    }
                }
            }
            else {
                continue;
            }
        }
        foreach Block entry in entries {
            Block[] group = <Block[]>independentGroups[entry.id.toString()];
            Block[] toInvalidate =[];
            foreach Block child in group {
                foreach Block parent in child.branchesIn {
                    if ownership[parent.id.toString()] != ownership[child.id.toString()] {
                        self.invalidateChildren(child,ownership,independentGroups);
                        break;
                    }
                }
            }
        }
        foreach Block entry in entries {
            Block[] group = <Block[]>independentGroups[entry.id.toString()];
            if group.length() == 0 {
                Block[] removed = independentGroups.remove(entry.id.toString());
            }
        }
        return independentGroups;
    }

    function createMultipleShape(Block[] blocks, Block[] entries, map<Block[]> independentGroups) returns Shape {
        Block[] nextEntries = [];
        Block[] validBlocks = blocks.clone();
        MultipleShape multiple = {};
        Block[] currEntries = [];
        foreach Block entry in entries {
            int? index = independentGroups.keys().indexOf(entry.id.toString());
            if index == () {
                nextEntries.push(entry);
            }
            else {
                currEntries = [];
                currEntries.push(entry);
                validBlocks = validBlocks.filter(b => b.id != entry.id);
                Block[] group = <Block[]>independentGroups[entry.id.toString()];
                foreach Block currInner in group {
                    validBlocks = validBlocks.filter(b => b.id != currInner.id);
                    foreach BlockBranchMap item in currInner.branchesOut {
                        if !self.checkExistence(group, item.block.id) {
                            Block curr = item.block;
                            foreach Block prev in curr.branchesIn {
                                index = entries.indexOf(prev);
                                if index != () {
                                    curr.branchesIn = curr.branchesIn.filter(b => b.id != prev.id);
                                }
                            }
                            if !self.checkExistence(nextEntries, item.block.id) {
                                curr.branchesIn = curr.branchesIn.filter(prev => !self.checkExistence(group, prev.id));
                                nextEntries.push(curr);
                            }
                        }
                    }
                }
                multiple.handledBlocks[entry.id.toString()] = self.calculate(group, currEntries);
            }
        }
        multiple.next = self.calculate(validBlocks,nextEntries);
        return multiple;
    }

    function calculate(Block[] validBlocks, Block[] entries) returns Shape? {
        if entries.length() == 1 {
            Block entry = entries[0];
            int inCount = 0;
            foreach Block prev in entry.branchesIn {
                if self.checkExistence(validBlocks, prev.id) {
                    inCount += 1;
                }
            }
            if inCount == 0 {
                return self.createSimpleShape(validBlocks,entry);
            }
            else {
                return self.createLoopShape(validBlocks, entries);
            }
        }
        else if entries.length() > 0 {
            map<Block[]> independentGroups = self.findIndependentBlocks(entries);
            if independentGroups.keys().length() > 0 {
                return self.createMultipleShape(validBlocks, entries, independentGroups);
            }
            return self.createLoopShape(validBlocks, entries);
        }
        else {
            return ();
        }
    }

    function renderShape(Shape sh) returns Expression[] {
        if sh.ty == "Simple" {
            return self.renderSimpleShape(<SimpleShape>sh);
        }
        else if sh.ty == "Multiple" {
            return self.renderMultipleShape(<MultipleShape>sh);
        }
        else {
            return self.renderLoopShape(<LoopShape>sh);
        }
    }

    function renderSimpleShape(SimpleShape simple) returns Expression[] {
        Expression[] children = [];
        WASMBlock innerBlock = {};
        WASMBlock nextBlock = {};
        children.push(innerBlock);
        if simple.next != () {
            WASMBlock simpleInnerBlock = {
                body: [simple.inner.code]
            };
            innerBlock.body.push(simpleInnerBlock);
            if (<Shape>simple.next).ty == "Multiple" {
                MultipleShape multiple = <MultipleShape>simple.next;
                string label =  "$block$" + self.shapeId.toString() + "$break";
                self.shapeId += 1;
                innerBlock.name = label;
                simple.next = multiple.next;
                Expression condition;
                IfExpr ifExpr = {
                    label: label
                };
                boolean isCond = false;
                foreach BlockBranchMap blockBranch in simple.inner.branchesOut {
                    if blockBranch.branch.condition != () {
                        condition = <Expression>blockBranch.branch.condition;
                        ifExpr.condition = condition;
                        isCond = true;
                    }
                    if isCond {
                        Expression[] ifCode = self.renderShape(<Shape>multiple.handledBlocks[blockBranch.block.id.toString()]);
                        WASMBlock ifBlock = {};
                        WASMBlock ifBreakBlock = {
                            body: [<Break>{ label : label }]
                        };
                        if ifCode.length() == 1 {
                            foreach Expression expr in (<WASMBlock>ifCode[0]).body {
                                ifBlock.body.push(expr);
                            }                            
                        }
                        else {
                            ifBlock.name = label;
                            foreach Expression expr in ifCode {
                               ifBlock.body.push(expr);                            
                            }
                        }
                        ifBlock.body.push(ifBreakBlock);
                        ifExpr.ifBody = ifBlock;
                        isCond = false;
                    }
                    else {
                        WASMBlock elseBlock = {};
                        if multiple.handledBlocks.keys().length() == 2 {
                            Expression[] elseCode = self.renderShape(<Shape>multiple.handledBlocks[blockBranch.block.id.toString()]);
                            foreach Expression expr in elseCode {
                                elseBlock.body.push(expr);                            
                            }
                            WASMBlock elseBreak = {
                                body: [<Break>{ label : label }]
                            };
                            elseBlock.body.push(elseBreak);
                        }
                        else {
                            elseBlock.body.push(<Break>{ label : label });
                        }
                        ifExpr.elseBody = elseBlock;
                    }
                }
                innerBlock.body.push(ifExpr);
            }
            else {
                io:println("unimplemented");
            }
            if simple.next != () {
                Expression[] nextExprs = self.renderShape(<Shape>simple.next);
                if nextExprs.length() == 1 {
                    children.push(nextExprs[0]);
                }
                else{
                    foreach Expression expr in  nextExprs{
                        nextBlock.body.push(expr);
                    }
                    children.push(nextBlock);
                }
            }
            
        }
        else {
            innerBlock.body.push(simple.inner.code);
        }
        return children;
    }

    function renderLoopShape(LoopShape loop) returns Expression[] {
        panic error("unimplemented");

    }

    function renderMultipleShape(MultipleShape multiple) returns Expression[] {
        panic error("unimplemented");
    }

    function render(Block body, int labelHelper) returns Expression {
        self.root = self.calculate(self.blocks, [body]);
        // TODO:mapping between relooper blocks and WASM blocks
        return {code: "Hello World"};    
    }

}
