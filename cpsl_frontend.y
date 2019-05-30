
%{
// C declarations
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "../parse_tree.h"
#include "../symbol_table.h"
#include "../preprocess.h"

extern int yylex(void);
extern int yyerror(const char*);
Program *pt_root;
%}

/* Bison declarations */

%code requires {
    #include "../parse_tree.h"
    #include "../symbol_table.h"
}

%verbose

%union {
    Program *program_ptr;
    ConstDecl *c_decl_ptr;
    struct {ConstDeclList *head; ConstDeclList *tail;} c_decl_l;
    TypeDecl *t_decl_ptr;
    struct {TypeDeclList *head; TypeDeclList *tail;} t_decl_l;
    Type *type_ptr;
    SimpleType *simple_type_ptr;
    RecordType *record_type_ptr;
    struct {RecordTypeList *head; RecordTypeList *tail;} record_type_l;
    struct {IdentList *head; IdentList *tail;} ident_l;
    ArrayType *array_type_ptr;
    VarDecl *v_decl_ptr;
    struct {VarDeclList *head; VarDeclList *tail;} v_decl_l;
    SubroutineDecl *s_decl_ptr;
    struct {SubroutineDeclList *head; SubroutineDeclList *tail;} s_decl_l;
    ProcedureDecl *p_decl_ptr;
    FunctionDecl *f_decl_ptr;
    struct {FormalParameterList *head; FormalParameterList *tail;} fp_l;
    FormalParameter *fp_ptr;
    Body *body_ptr;
    Block *block_ptr;
    struct {StatementList *head; StatementList *tail;} stmt_l;
    Statement *stmt_ptr;
    AssignStatement *assign_ptr;
    IfStatement *if_ptr;
    struct {ElseIfList *head; ElseIfList *tail;} elseif_l;
    WhileStatement *while_ptr;
    RepeatStatement *repeat_ptr;
    ForStatement *for_ptr;
    StopStatement *stop_ptr;
    ReturnStatement *return_ptr;
    ReadStatement *read_ptr;
    struct {ReadList *head; ReadList *tail;} read_l;
    WriteStatement *write_ptr;
    struct {WriteList *head; WriteList *tail;} write_l;
    PCallStatement *pcall_ptr;
    struct {ArgumentList *head; ArgumentList *tail;} arg_l;
    NullStatement *null_ptr;
    Expression *expr_ptr;
    LValue *lval_ptr;
    bool bool_literal;
    int int_literal;
    float float_literal;
    char char_literal;
    char *str_literal;
}

%token ARRAY_TOK;
%token BEGIN_TOK;
%token CHR_TOK;
%token CONST_TOK;
%token DO_TOK;
%token DOWNTO_TOK;
%token ELSE_TOK;
%token ELSEIF_TOK;
%token END_TOK;
%token FOR_TOK;
%token FORWARD_TOK;
%token FUNCTION_TOK;
%token IF_TOK;
%token OF_TOK;
%token ORD_TOK;
%token PRED_TOK;
%token PROCEDURE_TOK;
%token READ_TOK;
%token RECORD_TOK;
%token REF_TOK;
%token REPEAT_TOK;
%token RETURN_TOK;
%token STOP_TOK;
%token SUCC_TOK;
%token THEN_TOK;
%token TO_TOK;
%token TYPE_TOK;
%token UNTIL_TOK;
%token VAR_TOK;
%token WHILE_TOK;
%token WRITE_TOK;
%token INTEGER_TOK;
%token CHAR_TOK;
%token FLOAT_TOK;
%token BOOLEAN_TOK;
%token TRUE_TOK;
%token FALSE_TOK;
%token INT_LITERAL_TOK;
%token FLOAT_LITERAL_TOK;
%token CHAR_LITERAL_TOK;
%token STRING_LITERAL_TOK;
%token SEMICOLON_TOK;
%token COLON_TOK;
%token COMMA_TOK;
%token LBRACKET_TOK;
%token RBRACKET_TOK;

%token IDENTIFIER_TOK;

/* operators */
%token ASSIGN_TOK;
%token MEMBER_TOK;
%token RPAREN_TOK;
%left OR_TOK;
%left AND_TOK;
%precedence NOT_TOK;
%nonassoc EQUALS_TOK;
%nonassoc NEQ_TOK;
%nonassoc LT_TOK;
%nonassoc GT_TOK;
%nonassoc LE_TOK;
%nonassoc GE_TOK;
%left ADD_TOK;
%left SUB_TOK;
%left MOD_TOK;
%left MUL_TOK;
%left DIV_TOK;
%precedence UMINUS_TOK;
%token LPAREN_TOK;

%type <program_ptr> Program;
%type <c_decl_ptr> ConstantDecl;
%type <c_decl_l> ConstantDeclList;
%type <t_decl_ptr> TypeDecl;
%type <t_decl_l> TypeDeclList;
%type <type_ptr> Type;
%type <simple_type_ptr> SimpleType;
%type <record_type_ptr> RecordType;
%type <record_type_l> RecordTypeList;
%type <il_ptr> IdentList
%type <array_type_ptr> ArrayType;
%type <v_decl_ptr> VarDecl;
%type <vdl_ptr> VarDeclList;
%type <s_decl_ptr> SubroutineDecl;
%type <sdl_ptr> SubroutineDeclList;
%type <p_decl_ptr> ProcedureDecl;
%type <f_decl_ptr> FunctionDecl;
%type <fpl_decl> FormalParameterList;
%type <fp_ptr> FormalParameter;
%type <body_ptr> Body;
%type <block_ptr> Block;
%type <sl_ptr> StatementList;
%type <stmt_ptr> Statement;
%type <assign_ptr> Assignment;
%type <if_ptr> IfStatement;
%type <eil_ptr> ElseIfList;
%type <while_ptr> WhileStatement;
%type <repeat_ptr> RepeatStatement;
%type <for_ptr> ForStatement;
%type <stop_ptr> StopStatement;
%type <return_ptr> ReturnStatement;
%type <read_ptr> ReadStatement;
%type <rl_ptr> ReadList;
%type <write_ptr> WriteStatement;
%type <wl_ptr> WriteList;
%type <pcall_ptr> ProcedureCall;
%type <al_ptr> ArgumentList;
%type <null_ptr> NullStatement;
%type <expr_ptr> Expression;
%type <lval_ptr> LValue;
%type <int_literal> INT_LITERAL_TOK;
%type <float_literal> FLOAT_LITERAL_TOK;
%type <char_literal> CHAR_LITERAL_TOK;
%type <str_literal> STRING_LITERAL_TOK;
%type <bool_literal> TRUE_TOK;
%type <bool_literal> FALSE_TOK;

%%

/* grammar rules */

Program:
    Block MEMBER_TOK
    {
        Program *p = malloc(sizeof(Program));
        p->c_decl = NULL;
        p->t_decl = NULL;
        p->v_decl = NULL;
        p->s_decl = NULL;
        p->block = $1;
        $$ = p;
    }
    | ConstantDecl
    {
        Program *p = malloc(sizeof(Program));
        p->c_decl = $1;
        p->t_decl = NULL;
        p->v_decl = NULL;
        p->s_decl = NULL;
        $<program_ptr>$ = p;
    }
    Block MEMBER_TOK
    {
        Program *p = $<program_ptr>2;
        p->block = $3;
        $$ = p;
    }
    | TypeDecl
    {
        Program *p = malloc(sizeof(Program));
        p->c_decl = NULL;
        p->t_decl = $1;
        p->v_decl = NULL;
        p->s_decl = NULL;
        $<program_ptr>$ = p;
    }
    Block MEMBER_TOK
    {
        Program *p = $<program_ptr>2;
        p->block = $3;
        $$ = p;
    }
    | VarDecl
    {
        Program *p = malloc(sizeof(Program));
        p->c_decl = NULL;
        p->t_decl = NULL;
        p->v_decl = $1;
        p->s_decl = NULL;
        $<program_ptr>$ = p;
    }
    Block MEMBER_TOK
    {
        Program *p = $<program_ptr>2;
        p->block = $3;
        $$ = p;
    }
    | SubroutineDecl
    {
        Program *p = malloc(sizeof(Program));
        p->c_decl = NULL;
        p->t_decl = NULL;
        p->v_decl = NULL;
        p->s_decl = $1;
        $<program_ptr>$ = p;
    }
    Block MEMBER_TOK
    {
        Program *p = $<program_ptr>2;
        p->block = $3;
        $$ = p;
    }
    | ConstantDecl TypeDecl
    {
        Program *p = malloc(sizeof(Program));
        p->c_decl = $1;
        p->t_decl = $2;
        p->v_decl = NULL;
        p->s_decl = NULL;
        $<program_ptr>$ = p;
    }
    Block MEMBER_TOK
    {
        Program *p = $<program_ptr>3;
        p->block = $4;
        $$ = p;
    }
    | ConstantDecl VarDecl
    {
        Program *p = malloc(sizeof(Program));
        p->c_decl = $1;
        p->t_decl = NULL;
        p->v_decl = $2;
        p->s_decl = NULL;
        $<program_ptr>$ = p;
    }
    Block MEMBER_TOK
    {
        Program *p = $<program_ptr>3;
        p->block = $4;
        $$ = p;
    }
    | ConstantDecl SubroutineDecl
    {
        Program *p = malloc(sizeof(Program));
        p->c_decl = $1;
        p->t_decl = NULL;
        p->v_decl = NULL;
        p->s_decl = $2;
        $<program_ptr>$ = p;
    }
    Block MEMBER_TOK
    {
        Program *p = $<program_ptr>3;
        p->block = $4;
        $$ = p;
    }
    | TypeDecl VarDecl
    {
        Program *p = malloc(sizeof(Program));
        p->c_decl = NULL;
        p->t_decl = $1;
        p->v_decl = $2;
        p->s_decl = NULL;
        $<program_ptr>$ = p;
    }
    Block MEMBER_TOK
    {
        Program *p = $<program_ptr>3;
        p->block = $4;
        $$ = p;
    }
    | TypeDecl SubroutineDecl
    {
        Program *p = malloc(sizeof(Program));
        p->c_decl = NULL;
        p->t_decl = $1;
        p->v_decl = NULL;
        p->s_decl = $2;
        $<program_ptr>$ = NULL;
    }
    Block MEMBER_TOK
    {
        Program *p = $<program_ptr>3;
        p->block = $4;
        $$ = p;
    }
    | VarDecl SubroutineDecl
    {
        Program *p = malloc(sizeof(Program));
        p->c_decl = NULL;
        p->t_decl = NULL;
        p->v_decl = $1;
        p->s_decl = $2;
        $<program_ptr>$ = p;
    }
    Block MEMBER_TOK
    {
        Program *p = $<program_ptr>3;
        p->block = $4;
        $$ = p;
    }
    | ConstantDecl TypeDecl VarDecl
    {
        Program *p = malloc(sizeof(Program));
        p->c_decl = $1;
        p->t_decl = $2;
        p->v_decl = $3;
        p->s_decl = NULL;
        $<program_ptr>$ = p;
    }
    Block MEMBER_TOK
    {
        Program *p = $<program_ptr>4;
        p->block = $5;
        $$ = p;
    }
    | ConstantDecl TypeDecl SubroutineDecl
    {
        Program *p = malloc(sizeof(Program));
        p->c_decl = $1;
        p->t_decl = $2;
        p->v_decl = NULL;
        p->s_decl = $3;
        $<program_ptr>$ = p;
    }
    Block MEMBER_TOK
    {
        Program *p = $<program_ptr>4;
        p->block = $5;
        $$ = p;
    }
    | ConstantDecl VarDecl SubroutineDecl
    {
        Program *p = malloc(sizeof(Program));
        p->c_decl = $1;
        p->t_decl = NULL;
        p->v_decl = $2;
        p->s_decl = $3;
        $<program_ptr>$ = p;
    }
    Block MEMBER_TOK
    {
        Program *p = $<program_ptr>4;
        p->block = $5;
        $$ = p;
    }
    | TypeDecl VarDecl SubroutineDecl
    {
        Program *p = malloc(sizeof(Program));
        p->c_decl = NULL;
        p->t_decl = $1;
        p->v_decl = $2;
        p->s_decl = $3;
        $<program_ptr>$ = p;
    }
    Block MEMBER_TOK
    {
        Program *p = $<program_ptr>4;
        p->block = $5;
        $$ = p;
    }
    | ConstantDecl TypeDecl VarDecl SubroutineDecl
    {
        Program *p = malloc(sizeof(Program));
        p->c_decl = $1;
        p->t_decl = $2;
        p->v_decl = $3;
        p->s_decl = $4;
        $<program_ptr>$ = p;
    }
    Block MEMBER_TOK
    {
        Program *p = $<program_ptr>5;
        p->block = $6;
        $$ = p;
    }

ConstantDecl:
    CONST_TOK ConstantDeclList
    {
        ConstDecl *c_decl = malloc(sizeof(ConstDecl));
        c_decl->cdl_head = $2.head;
        c_decl->cdl_tail = $2.tail;
        $$ = c_decl;
    }

ConstantDeclList:
    IDENTIFIER_TOK EQUALS_TOK Expression SEMICOLON_TOK
    {
        $$.head = NULL;
        $$.tail = NULL;
    }
    | ConstantDeclList IDENTIFIER_TOK EQUALS_TOK Expression SEMICOLON_TOK
    {
        $$.head = NULL;
        $$.tail = NULL;
    }

SubroutineDecl:
    SubroutineDeclList
    {
        $$ = NULL;
    }

SubroutineDeclList:
    ProcedureDecl
    {
        $$ = NULL;
    }
    | FunctionDecl
    {
        $$ = NULL;
    }
    | SubroutineDeclList ProcedureDecl
    {
        $$ = NULL;
    }
    | SubroutineDeclList FunctionDecl
    {
        $$ = NULL;
    }

ProcedureDecl:
    PROCEDURE_TOK IDENTIFIER_TOK LPAREN_TOK FormalParameterList RPAREN_TOK SEMICOLON_TOK FORWARD_TOK SEMICOLON_TOK
    {
        $$ = NULL;
    }
    | PROCEDURE_TOK IDENTIFIER_TOK LPAREN_TOK FormalParameterList RPAREN_TOK SEMICOLON_TOK Body SEMICOLON_TOK
    {
        $$ = NULL;
    }

FunctionDecl:
    FUNCTION_TOK IDENTIFIER_TOK LPAREN_TOK FormalParameterList RPAREN_TOK COLON_TOK Type SEMICOLON_TOK FORWARD_TOK SEMICOLON_TOK
    {
        $$ = NULL;
    }
    | FUNCTION_TOK IDENTIFIER_TOK LPAREN_TOK FormalParameterList RPAREN_TOK COLON_TOK Type SEMICOLON_TOK Body SEMICOLON_TOK
    {
        $$ = NULL;
    }

FormalParameterList:
    %empty
    {
        $$ = NULL;
    }
    | FormalParameter
    {
        $$ = NULL;
    }
    | FormalParameterList SEMICOLON_TOK FormalParameter
    {
        $$ = NULL;
    }

FormalParameter:
    IdentList COLON_TOK Type
    {
        $$ = NULL;
    }
    | VAR_TOK IdentList COLON_TOK Type
    {
        $$ = NULL;
    }
    | REF_TOK IdentList COLON_TOK Type
    {
        $$ = NULL;
    }

/* TODO will have to add mid-rule actions here, too */
Body:
    Block
    {
        $$ = NULL;
    }
    | ConstantDecl Block
    {
        $$ = NULL;
    }
    | TypeDecl Block
    {
        $$ = NULL;
    }
    | VarDecl Block
    {
        $$ = NULL;
    }
    | ConstantDecl TypeDecl Block
    {
        $$ = NULL;
    }
    | ConstantDecl VarDecl Block
    {
        $$ = NULL;
    }
    | TypeDecl VarDecl Block
    {
        $$ = NULL;
    }
    | ConstantDecl TypeDecl VarDecl Block
    {
        $$ = NULL;
    }

Block:
    BEGIN_TOK StatementList END_TOK
    {
        $$ = NULL;
    }

TypeDecl:
    TYPE_TOK TypeDeclList
    {
        $$ = NULL;
    }

TypeDeclList:
    IDENTIFIER_TOK EQUALS_TOK Type SEMICOLON_TOK
    {
        $$.head = NULL;
        $$.tail = NULL;
    }
    | TypeDeclList IDENTIFIER_TOK EQUALS_TOK Type SEMICOLON_TOK
    {
        $$.head = NULL;
        $$.tail = NULL;
    }

Type:
    SimpleType
    {
        $$ = NULL;
    }
    | RecordType
    {
        $$ = NULL;
    }
    | ArrayType
    {
        $$ = NULL;
    }

SimpleType:
    INTEGER_TOK
    {
        $$ = NULL;
    }
    | CHAR_TOK
    {
        $$ = NULL;
    }
    | FLOAT_TOK
    {
        $$ = NULL;
    }
    | BOOLEAN_TOK
    {
        $$ = NULL;
    }
    | IDENTIFIER_TOK
    {
        $$ = NULL;
    }

RecordType:
    RECORD_TOK END_TOK
    {
        $$ = NULL;
    }
    | RECORD_TOK RecordTypeList END_TOK
    {
        $$ = NULL;
    }

RecordTypeList:
    IdentList COLON_TOK Type SEMICOLON_TOK
    {
        $$.head = NULL;
        $$.tail = NULL;
    }
    | RecordTypeList IdentList COLON_TOK Type SEMICOLON_TOK
    {
        $$.head = NULL;
        $$.tail = NULL;
    }

ArrayType:
    ARRAY_TOK LBRACKET_TOK Expression COLON_TOK Expression RBRACKET_TOK OF_TOK Type
    {
        $$ = NULL;
    }

IdentList:
    IDENTIFIER_TOK
    {
        $$ = NULL;
    }
    | IdentList COMMA_TOK IDENTIFIER_TOK
    {
        $$ = NULL;
    }

VarDecl:
    VAR_TOK VarDeclList
    {
        $$ = NULL;
    }

VarDeclList:
    IdentList COLON_TOK Type SEMICOLON_TOK
    {
        $$ = NULL;
    }
    | VarDeclList IdentList COLON_TOK Type SEMICOLON_TOK
    {
        $$ = NULL;
    }

StatementList:
    Statement
    {
        $$ = NULL;
    }
    | StatementList SEMICOLON_TOK Statement
    {
        $$ = NULL;
    }

Statement:
    Assignment
    {
        $$ = NULL;
    }
    | IfStatement
    {
        $$ = NULL;
    }
    | WhileStatement
    {
        $$ = NULL;
    }
    | RepeatStatement
    {
        $$ = NULL;
    }
    | ForStatement
    {
        $$ = NULL;
    }
    | StopStatement
    {
        $$ = NULL;
    }
    | ReturnStatement
    {
        $$ = NULL;
    }
    | ReadStatement
    {
        $$ = NULL;
    }
    | WriteStatement
    {
        $$ = NULL;
    }
    | ProcedureCall
    {
        $$ = NULL;
    }
    | NullStatement
    {
        $$ = NULL;
    }

Assignment:
    LValue ASSIGN_TOK Expression
    {
        $$ = NULL;
    }

IfStatement:
    IF_TOK Expression THEN_TOK StatementList END_TOK
    {
        $$ = NULL;
    }
    | IF_TOK Expression THEN_TOK StatementList ELSE_TOK StatementList END_TOK
    {
        $$ = NULL;
    }
    | IF_TOK Expression THEN_TOK StatementList ElseIfList END_TOK
    {
        $$ = NULL;
    }
    | IF_TOK Expression THEN_TOK StatementList ElseIfList ELSE_TOK StatementList END_TOK
    {
        $$ = NULL;
    }

ElseIfList:
    ELSEIF_TOK Expression THEN_TOK StatementList
    {
        $$ = NULL;
    }
    | ElseIfList ELSEIF_TOK Expression THEN_TOK StatementList
    {
        $$ = NULL;
    }

WhileStatement:
    WHILE_TOK Expression DO_TOK StatementList END_TOK
    {
        $$ = NULL;
    }

RepeatStatement:
    REPEAT_TOK StatementList UNTIL_TOK Expression
    {
        $$ = NULL;
    }

ForStatement:
    FOR_TOK IDENTIFIER_TOK ASSIGN_TOK Expression TO_TOK Expression DO_TOK StatementList END_TOK
    {
        $$ = NULL;
    }
    | FOR_TOK IDENTIFIER_TOK ASSIGN_TOK Expression DOWNTO_TOK Expression DO_TOK StatementList END_TOK
    {
        $$ = NULL;
    }

StopStatement:
    STOP_TOK
    {
        $$ = NULL;
    }

ReturnStatement:
    RETURN_TOK
    {
        $$ = NULL;
    }
    | RETURN_TOK Expression
    {
        $$ = NULL;
    }

ReadStatement:
    READ_TOK LPAREN_TOK ReadList RPAREN_TOK
    {
        $$ = NULL;
    }

ReadList:
    LValue
    {
        $$ = NULL;
    }
    | ReadList COMMA_TOK LValue
    {
        $$ = NULL;
    }

WriteStatement:
    WRITE_TOK LPAREN_TOK WriteList RPAREN_TOK
    {
        $$ = NULL;
    }

WriteList:
    Expression
    {
        $$ = NULL;
    }
    | WriteList COMMA_TOK Expression
    {
        $$ = NULL;
    }

ProcedureCall:
    IDENTIFIER_TOK LPAREN_TOK ArgumentList RPAREN_TOK
    {
        $$ = NULL;
    }

ArgumentList:
    %empty
    {
        $$ = NULL;
    }
    | Expression
    {
        $$ = NULL;
    }
    | ArgumentList COMMA_TOK Expression
    {
        $$ = NULL;
    }

NullStatement:
    %empty
    {
        $$ = NULL;
    }

Expression:
    Expression OR_TOK Expression
    {
        $$ = NULL;
    }
    | Expression AND_TOK Expression
    {
        $$ = NULL;
    }
    | Expression EQUALS_TOK Expression
    {
        $$ = NULL;
    }
    | Expression NEQ_TOK Expression
    {
        $$ = NULL;
    }
    | Expression LE_TOK Expression
    {
        $$ = NULL;
    }
    | Expression GE_TOK Expression
    {
        $$ = NULL;
    }
    | Expression LT_TOK Expression
    {
        $$ = NULL;
    }
    | Expression GT_TOK Expression
    {
        $$ = NULL;
    }
    | Expression ADD_TOK Expression
    {
        $$ = NULL;
    }
    | Expression SUB_TOK Expression
    {
        $$ = NULL;
    }
    | Expression MUL_TOK Expression
    {
        $$ = NULL;
    }
    | Expression DIV_TOK Expression
    {
        $$ = NULL;
    }
    | Expression MOD_TOK Expression
    {
        $$ = NULL;
    }
    | NOT_TOK Expression
    {
        $$ = NULL;
    }
    | SUB_TOK Expression %prec UMINUS_TOK
    {
        $$ = NULL;
    }
    | LPAREN_TOK Expression RPAREN_TOK
    {
        $$ = NULL;
    }
    | IDENTIFIER_TOK LPAREN_TOK ArgumentList RPAREN_TOK
    {
        $$ = NULL;
    }
    | CHR_TOK LPAREN_TOK Expression RPAREN_TOK
    {
        $$ = NULL;
    }
    | ORD_TOK LPAREN_TOK Expression RPAREN_TOK
    {
        $$ = NULL;
    }
    | PRED_TOK LPAREN_TOK Expression RPAREN_TOK
    {
        $$ = NULL;
    }
    | SUCC_TOK LPAREN_TOK Expression RPAREN_TOK
    {
        $$ = NULL;
    }
    | LValue
    {
        $$ = NULL;
    }
    | INT_LITERAL_TOK
    {
        $$ = NULL;
    }
    | FLOAT_LITERAL_TOK
    {
        $$ = NULL;
    }
    | CHAR_LITERAL_TOK
    {
        $$ = NULL;
    }
    | STRING_LITERAL_TOK
    {
        $$ = NULL;
    }
    | TRUE_TOK
    {
        $$ = NULL;
    }
    | FALSE_TOK
    {
        $$ = NULL;
    }

LValue:
    IDENTIFIER_TOK
    {
        $$ = NULL;
    }
    | LValue MEMBER_TOK IDENTIFIER_TOK
    {
        $$ = NULL;
    }
    | LValue LBRACKET_TOK Expression RBRACKET_TOK
    {
        $$ = NULL;
    }

%%

// C support functions

