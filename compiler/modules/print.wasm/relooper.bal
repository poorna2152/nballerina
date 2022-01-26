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

    function invalidateChildren(Block block, map<Block?> ownership, map<Block[]> independentGroups) {
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
            else {
                continue;
            }
        }
        foreach Block entry in entries {
            Block[]? group = independentGroups[entry.id.toString()];
            Block[] toInvalidate =[];
            if group != () {
                foreach Block child in group {
                    foreach Block parent in child.branchesIn {
                        if ownership[parent.id.toString()] != ownership[child.id.toString()] {
                            self.invalidateChildren(child,ownership,independentGroups);
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
                    Block[] removed = independentGroups.remove(entry.id.toString());
                }
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
                Block[]? group = independentGroups[entry.id.toString()];
                if group != () {
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
                    Shape? handledBlock = self.calculate(group, currEntries);
                    if handledBlock != () {
                        multiple.handledBlocks[entry.id.toString()] = handledBlock;
                    }
                }
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
        if sh is SimpleShape {
            return self.renderSimpleShape(sh);
        }
        else if sh is MultipleShape {
            return self.renderMultipleShape(sh);
        }
        else {
            return self.renderLoopShape(sh);
        }
    }

    function renderSimpleShape(SimpleShape simple) returns Expression[] {
        Expression[] children = [];
        WasmBlock innerBlock = {};
        WasmBlock nextBlock = {};
        Shape? next = simple.next;
        children.push(innerBlock);
        if next != () {
            WasmBlock simpleInnerBlock = {
                body: [simple.inner.code]
            };
            innerBlock.body.push(simpleInnerBlock);
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
                    else if handledBlock != () {
                        WasmBlock elseBlock = {};
                        Break br = { label : label };
                        if multiple.handledBlocks.keys().length() == 2 {
                            Expression[] elseCode = self.renderShape(handledBlock);
                            foreach Expression expr in elseCode {
                                elseBlock.body.push(expr);                            
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
                io:println("unimplemented");
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

    function printSpaces(int spaceCount) returns string {
        string spaces = "";
        foreach int i in 0...spaceCount {
            spaces += " ";
        }
        return spaces;
    }

    function makeBlockText(Expression[] result, int spacesCount) returns string {
        Expression curr;
        string[] currStr = [];
        while result.length() > 0 {
            curr = result.remove(0);
            if curr is WasmBlock {
                string? name = curr.name;
                if name != () {
                    currStr.push(self.printSpaces(spacesCount));
                    currStr.push("(block ");
                    currStr.push(name);
                    currStr.push("\n");
                }
                else {
                    currStr.push(self.printSpaces(spacesCount));
                    currStr.push("(block");
                    currStr.push("\n");
                }
                foreach Expression expr in curr.body {
                    currStr.push(self.makeBlockText([expr], spacesCount + 1));
                }
                currStr.push(self.printSpaces(spacesCount));
                currStr.push(")\n");
            }
            else if curr is If {
                If ifExpr = curr;
                WasmBlock? elseBody = ifExpr.elseBody;
                currStr.push(self.printSpaces(spacesCount));
                currStr.push("(if\n");
                string? conditionCode = ifExpr.condition.code;
                if conditionCode != () {
                    currStr.push(self.printSpaces(spacesCount + 1));
                    currStr.push(conditionCode);
                    currStr.push("\n");
                }
                currStr.push(self.makeBlockText([ifExpr.ifBody], spacesCount + 1));
                if elseBody != () {
                    currStr.push(self.makeBlockText([elseBody], spacesCount + 1));
                }
                currStr.push(self.printSpaces(spacesCount));
                currStr.push(")\n");
            }
            else if curr is Break {
                currStr.push(self.printSpaces(spacesCount));
                currStr.push("(br ");
                currStr.push(curr.label);
                currStr.push(")\n");
            }
            else {
                string? code = curr.code;
                if code != () {
                    currStr.push(self.printSpaces(spacesCount));
                    currStr.push(code);
                    currStr.push("\n");
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
