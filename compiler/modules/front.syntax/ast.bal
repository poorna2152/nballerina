import wso2/nballerina.types as t;
import wso2/nballerina.bir;
import wso2/nballerina.err;


public type ModulePart record {|
    ImportDecl? importDecl;
    ModuleLevelDefn[] defns;
|};

public type ModuleLevelDefn FunctionDefn|ConstDefn|TypeDefn;

public type Visibility "public"?;

public type ImportDecl record {|
    string org;
    string module;
|};

public type FunctionDefn record {|
    readonly string name;
    Visibility vis;
    FunctionTypeDesc typeDesc;
    string[] paramNames;
    Stmt[] body;
    err:Position pos;
    // This is filled in during analysis
    bir:FunctionSignature? signature = ();
|};

public type ResolvedConst readonly & [t:SemType, t:Value];
public type ConstDefn record {|
    readonly string name;
    Visibility vis;
    Expr expr;
    err:Position pos;
    ResolvedConst|false? resolved = ();    
|};

public type Stmt VarDeclStmt|AssignStmt|CallStmt|ReturnStmt|IfElseStmt|MatchStmt|WhileStmt|ForeachStmt|BreakStmt|ContinueStmt;
public type CallStmt FunctionCallExpr|MethodCallExpr;
public type Expr IntLiteralExpr|ConstValueExpr|BinaryExpr|UnaryExpr|FunctionCallExpr|MethodCallExpr|VarRefExpr|TypeCastExpr|TypeTestExpr|ConstructorExpr|MemberAccessExpr;
public type ConstructorExpr ListConstructorExpr|MappingConstructorExpr;
public type SimpleConstExpr ConstValueExpr|VarRefExpr|IntLiteralExpr|SimpleConstNegateExpr;

public type AssignStmt record {|
    LExpr lValue;
    Expr expr;
|};

// L-value expression
public type LExpr VarRefExpr|MemberAccessLExpr;

public type ReturnStmt record {|
    Expr returnExpr;
|};

public type IfElseStmt record {|
    Expr condition;
    Stmt[] ifTrue;
    Stmt[] ifFalse;
|};

public type MatchStmt record {|
    Expr expr;
    MatchClause[] clauses;
|};

public type MatchClause record {|
    MatchPattern[] patterns;
    Stmt[] block;
|};

public type MatchPattern ConstPattern|WildcardMatchPattern;

const WildcardMatchPattern = "_";

public type ConstPattern record {|
    SimpleConstExpr expr;
    err:Position pos;
|};

public type WhileStmt record {|
    Expr condition;
    Stmt[] body;
|};

public type ForeachStmt record {|
    string varName;
    RangeExpr range;
    Stmt[] body;
|};

public type BreakStmt "break";

public type ContinueStmt "continue";

public type VarDeclStmt record {|
    InlineTypeDesc td;
    string varName;
    Expr initExpr;
    // For now this should be filled in during parse
    // using a prebuilt Semtype such as `t:INT`.
    // Later on will support references to public type definitions,
    // and it will be filled in later.
    t:SemType? semType = ();
    boolean isFinal;
|};

public type BinaryArithmeticOp "+" | "-" | "*" | "/" | "%";
public type BinaryBitwiseOp "|" | "^" | "&" | "<<" | ">>" | ">>>";
public type BinaryRelationalOp "<" | ">" | "<=" | ">=";
public type BinaryEqualityOp  "==" | "!=" | "===" | "!==";
public type RangeOp  "..." | "..<";

public type BinaryExprOp BinaryArithmeticOp|BinaryRelationalOp|BinaryEqualityOp;

public type UnaryExprOp "-" | "!" | "~";

public type BinaryExpr BinaryRelationalExpr|BinaryEqualityExpr|BinaryArithmeticExpr|BinaryBitwiseExpr;

// We use different operator names so things work better with match statements
public type BinaryExprBase record {|
    Expr left;
    Expr right;
|};

public type BinaryEqualityExpr record {|
    *BinaryExprBase;
    BinaryEqualityOp equalityOp;
|};

public type BinaryRelationalExpr record {|
    *BinaryExprBase;
    BinaryRelationalOp relationalOp;
|};

public type BinaryArithmeticExpr record {|
    *BinaryExprBase;
    BinaryArithmeticOp arithmeticOp;
    err:Position pos;
|};

public type BinaryBitwiseExpr record {|
    *BinaryExprBase;
    BinaryBitwiseOp bitwiseOp; 
|};

public type UnaryExpr record {|
    UnaryExprOp op;
    Expr operand;
    err:Position pos;
|};

public type SimpleConstNegateExpr record {|
    *UnaryExpr;
    // JBUG #32099 should be "-" 
    UnaryExprOp op = "-";
    IntLiteralExpr|ConstValueExpr operand;
|};

public type FunctionCallExpr record {|
    string? prefix = ();
    string funcName;
    Expr[] args;
    // We can get public type/defn mismatch errors here
    err:Position pos;
|};

public type MethodCallExpr record {|
    string methodName;
    Expr target;
    Expr[] args;
    err:Position pos;
|};

public type ListConstructorExpr record {|
    Expr[] members;
    // JBUG adding this field makes match statement in codeGenExpr fail 
    // t:SemType? expectedType = ();
|};

public type MappingConstructorExpr record {|
    Field[] fields;
    // t:SemType? expectedType = ();
|};

public type Field record {|
    err:Position pos; // position of name for now
    string name;
    Expr value;
|};

public type MemberAccessExpr record {|
    Expr container;
    Expr index;
    err:Position pos;
|};

// JBUG gets a bad, sad if this uses *MemberAccessExpr and overrides container
public type MemberAccessLExpr record {|
    VarRefExpr container;
    Expr index;
    err:Position pos;
|};

public type RangeExpr record {|
    Expr lower;
    Expr upper;
|};

public type VarRefExpr record {|
    string varName;
|};

public type TypeCastExpr record {|
    InlineTypeDesc td;
    Expr operand;
    err:Position pos;
    t:SemType semType;
|};

public type TypeTestExpr record {|
    InlineTypeDesc td;
    // Use `left` here so this is distinguishable from TypeCastExpr and ConstValueExpr
    Expr left;
    t:SemType semType;
|};

public type ConstValueExpr record {|
    ()|boolean|int|string value;
    // This is non-nil when the static public type of the expression
    // contains more than one shape.
    // When it contains exactly one shape, then the shape is
    // the shape of the value.
    t:SemType? multiSemType = ();
|};

public type NumericLiteralExpr IntLiteralExpr|FpLiteralExpr;

public type IntLiteralBase 10|16;

// The public type of value represented by an int-literal
// depends on the contextually expected public type, which
// we do not know at parse time.
public type IntLiteralExpr record {|
    IntLiteralBase base;
    string digits;
    err:Position pos;
|};

const FLOAT_TYPE_SUFFIX = "f";

public type FpLiteralExpr record {|
    // This is the literal without the public type suffix
    string untypedLiteral;
    FLOAT_TYPE_SUFFIX? typeSuffix;
    err:Position pos;
|};

// Types

// This is the subtype of TypeDesc that we currently allow
// within expressions and statements.
public type InlineTypeDesc InlineLeafTypeDesc|InlineArrayTypeDesc|InlineMapTypeDesc;

public const ANY = "any";

public type InlineLeafTypeDesc "boolean"|"int"|"string"|ANY;

public type InlineArrayTypeDesc record {|
    *ListTypeDesc;
    TypeDesc[0] members = [];
    // JBUG if we use a string literal instead of a reference to a const,
    // this gets an error about attempting to make a non-public symbol visible
    ANY rest = ANY;
|};


public type InlineMapTypeDesc record {|
    *MappingTypeDesc;
    FieldDesc[0] fields = [];
    ANY rest = ANY;
|};

public type TypeDefn record {|
    readonly string name;
    Visibility vis;
    TypeDesc td;
    err:Position pos;
    t:SemType? semType = ();
    int cycleDepth = -1;
|};

public type TypeDesc LeafTypeDesc|BinaryTypeDesc|ConstructorTypeDesc|TypeDescRef|SingletonTypeDesc;

public type ConstructorTypeDesc ListTypeDesc|MappingTypeDesc|FunctionTypeDesc|ErrorTypeDesc;

public type ListTypeDesc record {|
    TypeDesc[] members;
    TypeDesc rest;
    t:ListDefinition? defn = ();
|};

public type FieldDesc record {|
    string name;
    TypeDesc typeDesc;
|};

public type MappingTypeDesc record {|
    FieldDesc[] fields;
    TypeDesc rest;
    t:MappingDefinition? defn = ();
|};

public type FunctionTypeDesc record {|
    // XXX need to handle rest public type
    TypeDesc[] args;
    TypeDesc ret;
    t:FunctionDefinition? defn = ();
|};

public type ErrorTypeDesc record {|
    TypeDesc detail;
|};

public type BinaryTypeOp "|" | "&";

public type BinaryTypeDesc record {|
    BinaryTypeOp op;
    TypeDesc left;
    TypeDesc right;
|};

public type TypeDescRef record {|
    string ref;
    err:Position pos;
|};

public type SingletonTypeDesc record {|
    (string|float|int|boolean) value;
|};

public type BuiltinIntSubtypeDesc "sint8"|"uint8"|"sint16"|"uint16"|"sint32"|"uint32";
public type BuiltInTypeDesc "any"|"boolean"|"decimal"|"error"|"float"|"handle"|"int"|"json"
                  |"never"|"readonly"|"string"|"typedesc"|"xml"|"()";
public type LeafTypeDesc BuiltInTypeDesc|BuiltinIntSubtypeDesc;
