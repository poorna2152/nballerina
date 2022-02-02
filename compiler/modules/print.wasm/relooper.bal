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
    Block inner;
    Shape? next = ();
};

type MultipleShape record {
    Shape? next = ();
    map<Shape> handledBlocks = {};
}; 

type LoopShape record {
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
    private Shape? root = ();
    private int shapeId = 1;

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

    function checkExistence(Block[]? blocks, int id) returns boolean {
        if blocks != () {
            foreach Block b in blocks {
                if b.id == id {
                    return true;
                }
            }
            return false;
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
            next: self.calculate(validBlocks, nextEntries)
        };
        return simple;
    }

    function createLoopShape(Block[] blocks, Block[] entries) returns Shape {
        Block[] nextEntries = [];
        Block[] innerBlocks = entries.clone();
        Block[] validBlocks = blocks.clone();
        Block[] queue = entries.clone();
        while queue.length() > 0 {
            Block curr = queue.remove(0);
            foreach Block prev in curr.branchesIn {
                if !self.checkExistence(innerBlocks, prev.id) {
                    queue.push(prev);
                    innerBlocks.push(prev);
                    validBlocks = validBlocks.filter(b => b.id != prev.id);
                }
            }
            validBlocks = validBlocks.filter(b => b.id != curr.id);
        }
        foreach Block entry in entries {
            entry.branchesIn = entry.branchesIn.filter(b => !self.checkExistence(innerBlocks, b.id));
        }
        foreach Block inner in innerBlocks {
            foreach BlockBranchMap block in inner.branchesOut {
                if self.checkExistence(validBlocks, block.block.id) {
                    block.block.branchesIn = block.block.branchesIn.filter(b => !self.checkExistence(innerBlocks, b.id));
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
            Block? owner = ownership[curr.id.toString()];
            if owner == () {
                continue;
            }
            else {
                Block[]? ownerGroup = independentGroups[owner.id.toString()];
                if ownerGroup != () {
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
            Block? owner = ownership[curr.id.toString()];
            if owner == () {
                continue;
            }
            else {
                foreach BlockBranchMap child in curr.branchesOut {
                    int? index = ownership.keys().indexOf(child.block.id.toString());
                    if index == () {
                        queue.push(child.block);
                        ownership[child.block.id.toString()] = owner;
                        Block[]? group = independentGroups[owner.id.toString()];
                        if group != () {
                            group.push(child.block);            
                            independentGroups[owner.id.toString()] = group;
                        }
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
        foreach Block entry in entries {
            Block[]? group = independentGroups[entry.id.toString()];
            if group != () {
                foreach Block child in group {
                    foreach Block parent in child.branchesIn {
                        if ownership[parent.id.toString()] != ownership[child.id.toString()] {
                            self.invalidateChildren(child, ownership, independentGroups);
                            break;
                        }
                    }
                }
            }
        }
        foreach Block entry in entries {
            Block[]? group = independentGroups[entry.id.toString()];
            if group != () {
                if group.length() == 0 {
                    _ = independentGroups.remove(entry.id.toString());
                }
            }
            else {
                _ = independentGroups.remove(entry.id.toString());
            }
        }
        return independentGroups;
    }

    function createMultipleShape(Block[] blocks, Block[] entries, map<Block[]> independentGroups) returns Shape {
        Block[] nextEntries = [];
        Block[] validBlocks = blocks.clone();
        MultipleShape multiple = {};
        foreach Block entry in entries {
            Block[]? group  = independentGroups[entry.id.toString()];
            if group == () {
                nextEntries.push(entry);
            }
            else {
                validBlocks = validBlocks.filter(b => b.id != entry.id);
                foreach Block currInner in group {
                    validBlocks = validBlocks.filter(b => b.id != currInner.id);
                    foreach BlockBranchMap child in currInner.branchesOut {
                        if !self.checkExistence(group, child.block.id) {
                            Block curr = child.block;
                            curr.branchesIn = curr.branchesIn.filter(b => !self.checkExistence(group, b.id));
                            if !self.checkExistence(nextEntries, curr.id) {
                                nextEntries.push(curr);
                            }
                        }
                    }
                }
                Shape? handledBlock = self.calculate(group, [entry]);
                if handledBlock != () {
                    multiple.handledBlocks[entry.id.toString()] = handledBlock;
                }
            }
        }
        multiple.next = self.calculate(validBlocks, nextEntries);
        return multiple;
    }

    function calculate(Block[] validBlocks, Block[] entries) returns Shape? {
        if entries.length() == 1 {
            Block entry = entries[0];
            if entry.branchesIn.length() == 0 {
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

    function renderShape(Shape sh, string? label = ()) returns Expression[] {
        if sh is SimpleShape {
            return self.renderSimpleShape(sh, label);
        }
        else if sh is MultipleShape {
            return self.renderMultipleShape(sh);
        }
        else {
            return self.renderLoopShape(sh);
        }
    }

    function renderSimpleShape(SimpleShape simple, string? labelPrev = ()) returns Expression[] {
        Expression[] children = [];
        Shape? next = simple.next;
        WasmBlock innerBlock = {};
        WasmBlock nextBlock = {};
        children.push(innerBlock);
        innerBlock.body.push(simple.inner.code);
        if next != () {
            if next is MultipleShape {
                MultipleShape multiple = next;
                string label =  "$block$" + self.shapeId.toString() + "$break";
                self.shapeId += 1;
                innerBlock.name = label;
                simple.next = multiple.next;
                next = multiple.next;
                Expression? condition = ();
                WasmBlock? ifBody = ();
                WasmBlock? elseBody = ();
                boolean isCond = false;
                foreach BlockBranchMap blockBranch in simple.inner.branchesOut {
                    Expression? tempCondition = blockBranch.branch.condition;
                    if tempCondition != () {
                        condition = tempCondition;
                        isCond = true;
                    }
                    Shape? handledBlock = multiple.handledBlocks[blockBranch.block.id.toString()];
                    if isCond && handledBlock != () {
                        Expression[] ifCode = self.renderShape(handledBlock);
                        WasmBlock ifBlock = {};
                        Break br = { label : label };
                        WasmBlock ifBreakBlock = {
                            body: [br]
                        };
                        if ifCode.length() == 1 {
                            Expression bodyBlock = ifCode[0];
                            if bodyBlock is WasmBlock {
                                foreach Expression expr in bodyBlock.body {
                                    ifBlock.body.push(expr);
                                }      
                            }                      
                        }
                        else {
                            ifBlock.name = label;
                            foreach Expression expr in ifCode {
                               ifBlock.body.push(expr);                            
                            }
                        }
                        ifBlock.body.push(ifBreakBlock);
                        ifBody = ifBlock;
                        isCond = false;
                    }
                    else {
                        WasmBlock elseBlock = {};
                        Break br = { label : label };
                        if multiple.handledBlocks.length() == 2 && handledBlock != () {
                            Expression[] elseCode = self.renderShape(handledBlock);
                            if elseCode.length() == 1 {
                                Expression bodyBlock = elseCode[0];
                                if bodyBlock is WasmBlock {
                                    foreach Expression expr in bodyBlock.body {
                                        elseBlock.body.push(expr);
                                    }
                                }
                            }
                            else {
                                elseBlock.name = label;
                                foreach Expression expr in elseCode {
                                    elseBlock.body.push(expr);
                                }
                            }
                            WasmBlock elseBreak = {
                                body: [br]
                            };
                            elseBlock.body.push(elseBreak);
                        }
                        else {
                            elseBlock.body.push(br);
                        }
                        elseBody = elseBlock;
                    }
                }
                if condition != () && ifBody != () {
                    If ifExpr = {
                        condition : condition,
                        ifBody : ifBody,
                        elseBody : elseBody
                    };
                    innerBlock.body.push(ifExpr);
                }
            }
            else {
                Expression? condition = ();
                WasmBlock? ifBody = ();
                WasmBlock? elseBody = ();
                foreach BlockBranchMap item in simple.inner.branchesOut {
                    if item.branch.condition != () {
                        condition = item.branch.condition;
                        string blockName = "$block$" + self.shapeId.toString() + "$break";
                        self.shapeId = self.shapeId + 1;
                        innerBlock.name = blockName;
                        Break br = { label: blockName };
                        WasmBlock bl = {
                            body: [br]
                        };
                        ifBody = bl;
                        Break brL = { label: <string>labelPrev };
                        WasmBlock blL = {
                            body: [brL]
                        };
                        elseBody = blL;
                    }
                }
                if condition != () && ifBody != () {
                    If ifExpr = {
                        condition : condition,
                        ifBody : ifBody,
                        elseBody : elseBody
                    };
                    innerBlock.body.push(ifExpr);
                }
            }
            if next != () {
                Expression[] nextExprs = self.renderShape(next);
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
        return children;
    }

    function renderLoopShape(LoopShape loop) returns Expression[] {
        Shape? inner = loop.inner;
        Shape? next = loop.next;
        Expression[] innerExpr = [];
        Expression[] nextExpr = [];
        Expression[] children = [];
        WasmBlock nextBlock = {};
        string blockName = "$block$" + self.shapeId.toString() + "$break";
        self.shapeId = self.shapeId + 1;
        string loopName = "$shape$" + self.shapeId.toString() + "$continue";
        self.shapeId = self.shapeId + 1;
        WasmBlock outerBlock = { name : blockName };
        WasmLoop loopBlock = { name : loopName };
        outerBlock.body.push(loopBlock);
        if inner != () {
            innerExpr = self.renderShape(inner, blockName);
            Break breakLoop = { label: loopName };
            innerExpr.push(breakLoop);
            loopBlock.loopBody = innerExpr;
        }
        children.push(outerBlock);
        if next != () {
            nextExpr = self.renderShape(next);
            nextBlock.body = nextExpr;
        }
        children.push(nextBlock);
        return children;
    }

    function renderMultipleShape(MultipleShape multiple) returns Expression[] {
        panic error("unimplemented");
    }

    function makeBlockText(Expression[] result, int spacesCount) returns string {
        Expression curr;
        string[] currStr = [];
        while result.length() > 0 {
            curr = result.remove(0);
            if curr is WasmBlock {
                string? name = curr.name;
                if name != () {
                    currStr.push("(block ");
                    currStr.push(name);
                }
                else {
                    currStr.push("(block ");
                }
                foreach Expression expr in curr.body {
                    currStr.push(self.makeBlockText([expr], spacesCount + 1));
                }
                currStr.push(")");
            }
            else if curr is WasmLoop {
                string? name = curr.name;
                if name != () {
                    currStr.push("(loop ");
                    currStr.push(name);
                }
                else {
                    currStr.push("(loop ");
                }
                foreach Expression expr in curr.loopBody {
                    currStr.push(self.makeBlockText([expr], spacesCount + 1));
                }
                currStr.push(")");
            }
            else if curr is If {
                If ifExpr = curr;
                WasmBlock? elseBody = ifExpr.elseBody;
                currStr.push("(if ");
                string? conditionCode = ifExpr.condition.code;
                if conditionCode != () {
                    currStr.push(conditionCode);
                }
                currStr.push(self.makeBlockText([ifExpr.ifBody], spacesCount + 1));
                if elseBody != () {
                    currStr.push(self.makeBlockText([elseBody], spacesCount + 1));
                }
                currStr.push(")");
            }
            else if curr is Break {
                currStr.push("(br ");
                currStr.push(curr.label);
                currStr.push(")");
            }
            else {
                string? code = curr.code;
                if code != () {
                    currStr.push(code);
                }
            }
        }
        return "".'join(...currStr);
    }

    function render(Block body, int labelHelper) returns Expression {
        self.root = self.calculate(self.blocks, [body]);
        Expression[] result = [];
        Shape? parent = self.root;
        if parent != () {
            result = self.renderShape(parent);
        }
        return {code: self.makeBlockText(result, 1)};
    }

}