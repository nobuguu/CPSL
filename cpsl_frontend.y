
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
    Identifier *ident_ptr;
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
%type <ident_l> IdentList
%type <array_type_ptr> ArrayType;
%type <v_decl_ptr> VarDecl;
%type <v_decl_l> VarDeclList;
%type <s_decl_ptr> SubroutineDecl;
%type <s_decl_l> SubroutineDeclList;
%type <p_decl_ptr> ProcedureDecl;
%type <f_decl_ptr> FunctionDecl;
%type <fp_l> FormalParameterList;
%type <fp_ptr> FormalParameter;
%type <body_ptr> Body;
%type <block_ptr> Block;
%type <stmt_l> StatementList;
%type <stmt_ptr> Statement;
%type <assign_ptr> Assignment;
%type <if_ptr> IfStatement;
%type <elseif_l> ElseIfList;
%type <while_ptr> WhileStatement;
%type <repeat_ptr> RepeatStatement;
%type <for_ptr> ForStatement;
%type <stop_ptr> StopStatement;
%type <return_ptr> ReturnStatement;
%type <read_ptr> ReadStatement;
%type <read_l> ReadList;
%type <write_ptr> WriteStatement;
%type <write_l> WriteList;
%type <pcall_ptr> ProcedureCall;
%type <arg_l> ArgumentList;
%type <null_ptr> NullStatement;
%type <expr_ptr> Expression;
%type <lval_ptr> LValue;
%type <ident_ptr> Identifier;
%type <int_literal> INT_LITERAL_TOK;
%type <float_literal> FLOAT_LITERAL_TOK;
%type <char_literal> CHAR_LITERAL_TOK;
%type <str_literal> STRING_LITERAL_TOK;
%type <bool_literal> TRUE_TOK;
%type <bool_literal> FALSE_TOK;
%type <str_literal> IDENTIFIER_TOK;

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
        for (ConstDeclList *c = c_decl->cdl_head; c != NULL; c = c->next) {
            add_to_table(ST_CONST, c->ident, c->expr);
        }
        $$ = c_decl;
    }

ConstantDeclList:
    Identifier EQUALS_TOK Expression SEMICOLON_TOK
    {
        ConstDeclList *c_decl_l = malloc(sizeof(ConstDeclList));
        c_decl_l->ident = $1;
        c_decl_l->expr = $3;
        c_decl_l->next = NULL;
        c_decl_l->prev = NULL;
        $$.head = c_decl_l;
        $$.tail = c_decl_l;
    }
    | ConstantDeclList Identifier EQUALS_TOK Expression SEMICOLON_TOK
    {
        ConstDeclList *c_decl_l = malloc(sizeof(ConstDeclList));
        c_decl_l->ident = $2;
        c_decl_l->expr = $4;
        c_decl_l->next = NULL;
        c_decl_l->prev = $1.tail;
        $1.tail->next = c_decl_l;
        $$.head = $1.head;
        $$.tail = c_decl_l;
    }

SubroutineDecl:
    SubroutineDeclList
    {
        SubroutineDecl *s_decl = malloc(sizeof(SubroutineDecl));
        s_decl->sdl_head = $1.head;
        s_decl->sdl_tail = $1.tail;
        for (SubroutineDeclList *s = s_decl->sdl_head; s != NULL; s = s->next) {
        }
        $$ = s_decl;
    }

SubroutineDeclList:
    ProcedureDecl
    {
        SubroutineDeclList *s_decl_l = malloc(sizeof(SubroutineDeclList));
        s_decl_l->tag = SDL_PROC;
        s_decl_l->sdl_union.p_decl = $1;
        s_decl_l->next = NULL;
        s_decl_l->prev = NULL;
        $$.head = s_decl_l;
        $$.tail = s_decl_l;
    }
    | FunctionDecl
    {
        SubroutineDeclList *s_decl_l = malloc(sizeof(SubroutineDeclList));
        s_decl_l->tag = SDL_FUNC;
        s_decl_l->sdl_union.f_decl = $1;
        s_decl_l->next = NULL;
        s_decl_l->prev = NULL;
        $$.head = s_decl_l;
        $$.tail = s_decl_l;
    }
    | SubroutineDeclList ProcedureDecl
    {
        SubroutineDeclList *s_decl_l = malloc(sizeof(SubroutineDeclList));
        s_decl_l->tag = SDL_PROC;
        s_decl_l->sdl_union.p_decl = $2;
        s_decl_l->next = NULL;
        s_decl_l->prev = $1.tail;
        $1.tail->next = s_decl_l;
        $$.head = $1.head;
        $$.tail = s_decl_l;
    }
    | SubroutineDeclList FunctionDecl
    {
        SubroutineDeclList *s_decl_l = malloc(sizeof(SubroutineDeclList));
        s_decl_l->tag = SDL_FUNC;
        s_decl_l->sdl_union.f_decl = $2;
        s_decl_l->next = NULL;
        s_decl_l->prev = $1.tail;
        $1.tail->next = s_decl_l;
        $$.head = $1.head;
        $$.tail = s_decl_l;
    }

ProcedureDecl:
    PROCEDURE_TOK Identifier LPAREN_TOK FormalParameterList RPAREN_TOK SEMICOLON_TOK
    {
        ProcedureDecl *p_decl = malloc(sizeof(ProcedureDecl));
        p_decl->ident = $2;
        p_decl->fpl_head = $4.head;
        p_decl->fpl_tail = $4.tail;
        $<p_decl_ptr>$ = p_decl;
        push_table();
    }
    FORWARD_TOK SEMICOLON_TOK
    {
        ProcedureDecl *p_decl = $<p_decl_ptr>6;
        p_decl->body = NULL;
        $$ = p_decl;
    }
    | PROCEDURE_TOK Identifier LPAREN_TOK FormalParameterList RPAREN_TOK SEMICOLON_TOK
    {
        ProcedureDecl *p_decl = malloc(sizeof(ProcedureDecl));
        p_decl->ident = $2;
        p_decl->fpl_head = $4.head;
        p_decl->fpl_tail = $4.tail;
        $<p_decl_ptr>$ = p_decl;
        push_table();
    }
    Body SEMICOLON_TOK
    {
        ProcedureDecl *p_decl = $<p_decl_ptr>6;
        p_decl->body = $8;
        $$ = p_decl;
    }

FunctionDecl:
    FUNCTION_TOK Identifier LPAREN_TOK FormalParameterList RPAREN_TOK COLON_TOK Type SEMICOLON_TOK
    {
        FunctionDecl *f_decl = malloc(sizeof(FunctionDecl));
        f_decl->ident = $2;
        f_decl->fpl_head = $4.head;
        f_decl->fpl_tail = $4.tail;
        f_decl->return_type = $7;
        $<f_decl_ptr>$ = f_decl;
        push_table();
    }
    FORWARD_TOK SEMICOLON_TOK
    {
        FunctionDecl *f_decl = $<f_decl_ptr>8;
        f_decl->body = NULL;
    }
    | FUNCTION_TOK Identifier LPAREN_TOK FormalParameterList RPAREN_TOK COLON_TOK Type SEMICOLON_TOK
    {
        FunctionDecl *f_decl = malloc(sizeof(FunctionDecl));
        f_decl->ident = $2;
        f_decl->fpl_head = $4.head;
        f_decl->fpl_tail = $4.tail;
        f_decl->return_type = $7;
        $<f_decl_ptr>$ = f_decl;
        push_table();
    }
    Body SEMICOLON_TOK
    {
        FunctionDecl *f_decl = $<f_decl_ptr>8;
        f_decl->body = $10;
        $$ = f_decl;
    }

FormalParameterList:
    %empty
    {
        $$.head = NULL;
        $$.tail = NULL;
    }
    | FormalParameter
    {
        FormalParameterList *fp_l = malloc(sizeof(FormalParameterList));
        fp_l->param = $1;
        fp_l->next = NULL;
        fp_l->prev = NULL;
        $$.head = fp_l;
        $$.tail = fp_l;
    }
    | FormalParameterList SEMICOLON_TOK FormalParameter
    {
        FormalParameterList *fp_l = malloc(sizeof(FormalParameterList));
        fp_l->param = $3;
        fp_l->next = NULL;
        fp_l->prev = $1.tail;
        $1.tail->next = fp_l;
        $$.head = $1.head;
        $$.tail = fp_l;
    }

FormalParameter:
    IdentList COLON_TOK Type
    {
        FormalParameter *param = malloc(sizeof(FormalParameter));
        param->tag = FP_VAR;
        param->type = $3;
        param->il_head = $1.head;
        param->il_tail = $1.tail;
        $$ = param;
    }
    | VAR_TOK IdentList COLON_TOK Type
    {
        FormalParameter *param = malloc(sizeof(FormalParameter));
        param->tag = FP_VAR;
        param->type = $4;
        param->il_head = $2.head;
        param->il_tail = $2.tail;
        $$ = param;
    }
    | REF_TOK IdentList COLON_TOK Type
    {
        FormalParameter *param = malloc(sizeof(FormalParameter));
        param->tag = FP_REF;
        param->type = $4;
        param->il_head = $2.head;
        param->il_tail = $2.tail;
        $$ = param;
    }

Body:
    Block
    {
        Body *b = malloc(sizeof(Body));
        b->c_decl = NULL;
        b->t_decl = NULL;
        b->v_decl = NULL;
        b->block = $1;
        $$ = b;
    }
    | ConstantDecl
    {
        Body *b = malloc(sizeof(Body));
        b->c_decl = $1;
        b->t_decl = NULL;
        b->v_decl = NULL;
        $<body_ptr>$ = b;
    }
    Block
    {
        Body *b = $<body_ptr>2;
        b->block = $3;
        $$ = b;
    }
    | TypeDecl
    {
        Body *b = malloc(sizeof(Body));
        b->c_decl = NULL;
        b->t_decl = $1;
        b->v_decl = NULL;
        $<body_ptr>$ = b;
    }
    Block
    {
        Body *b = $<body_ptr>2;
        b->block = $3;
        $$ = b;
    }
    | VarDecl
    {
        Body *b = malloc(sizeof(Body));
        b->c_decl = NULL;
        b->t_decl = NULL;
        b->v_decl = $1;
        $<body_ptr>$ = b;
    }
    Block
    {
        Body *b = $<body_ptr>2;
        b->block = $3;
        $$ = b;
    }
    | ConstantDecl TypeDecl
    {
        Body *b = malloc(sizeof(Body));
        b->c_decl = $1;
        b->t_decl = $2;
        b->v_decl = NULL;
        $<body_ptr>$ = b;
    }
    Block
    {
        Body *b = $<body_ptr>3;
        b->block = $4;
        $$ = b;
    }
    | ConstantDecl VarDecl
    {
        Body *b = malloc(sizeof(Body));
        b->c_decl = $1;
        b->t_decl = NULL;
        b->v_decl = $2;
        $<body_ptr>$ = b;
    }
    Block
    {
        Body *b = $<body_ptr>3;
        b->block = $4;
        $$ = b;
    }
    | TypeDecl VarDecl
    {
        Body *b = malloc(sizeof(Body));
        b->c_decl = NULL;
        b->t_decl = $1;
        b->v_decl = $2;
        $<body_ptr>$ = b;
    }
    Block
    {
        Body *b = $<body_ptr>3;
        b->block = $4;
        $$ = b;
    }
    | ConstantDecl TypeDecl VarDecl
    {
        Body *b = malloc(sizeof(Body));
        b->c_decl = $1;
        b->t_decl = $2;
        b->v_decl = $3;
        $<body_ptr>$ = b;
    }
    Block
    {
        Body *b = $<body_ptr>4;
        b->block = $5;
        $$ = b;
    }

Block:
    BEGIN_TOK StatementList END_TOK
    {
        Block *b = malloc(sizeof(Block));
        b->sl_head = $2.head;
        b->sl_tail = $2.tail;
        $$ = b;
    }

TypeDecl:
    TYPE_TOK TypeDeclList
    {
        TypeDecl *t_decl = malloc(sizeof(TypeDecl));
        t_decl->tdl_head = $2.head;
        t_decl->tdl_tail = $2.tail;
        $$ = t_decl;
    }

TypeDeclList:
    Identifier EQUALS_TOK Type SEMICOLON_TOK
    {
        TypeDeclList *t_decl_l = malloc(sizeof(TypeDeclList));
        t_decl_l->ident = $1;
        t_decl_l->type = $3;
        t_decl_l->next = NULL;
        t_decl_l->prev = NULL;
        $$.head = t_decl_l;
        $$.tail = t_decl_l;
    }
    | TypeDeclList Identifier EQUALS_TOK Type SEMICOLON_TOK
    {
        TypeDeclList *t_decl_l = malloc(sizeof(TypeDeclList));
        t_decl_l->ident = $2;
        t_decl_l->type = $4;
        t_decl_l->next = NULL;
        t_decl_l->prev = $1.tail;
        $1.tail->next = t_decl_l;
        $$.head = $1.head;
        $$.tail = t_decl_l;
    }

Type:
    SimpleType
    {
        /* TODO simple types are redeclarations of builtin types or
        previously defined types, so look them up instead of building a new one */
        Type *t = malloc(sizeof(Type));
        t->tag = TYPE_SIMPLE;
        t->type_union.simple = $1;
        $$ = t;
    }
    | RecordType
    {
        Type *t = malloc(sizeof(Type));
        t->tag = TYPE_RECORD;
        t->type_union.record = $1;
        $$ = t;
    }
    | ArrayType
    {
        Type *t = malloc(sizeof(Type));
        t->tag = TYPE_ARRAY;
        t->type_union.array = $1;
        $$ = t;
    }

SimpleType:
    INTEGER_TOK
    {
        SimpleType *s = malloc(sizeof(SimpleType));
        Identifier *ident = malloc(sizeof(Identifier));
        ident->name = strdup("integer");
        s->ident = ident;
        $$ = s;
    }
    | CHAR_TOK
    {
        SimpleType *s = malloc(sizeof(SimpleType));
        Identifier *ident = malloc(sizeof(Identifier));
        ident->name = strdup("char");
        s->ident = ident;
        $$ = s;
    }
    | FLOAT_TOK
    {
        SimpleType *s = malloc(sizeof(SimpleType));
        Identifier *ident = malloc(sizeof(Identifier));
        ident->name = strdup("float");
        s->ident = ident;
        $$ = s;
    }
    | BOOLEAN_TOK
    {
        SimpleType *s = malloc(sizeof(SimpleType));
        Identifier *ident = malloc(sizeof(Identifier));
        ident->name = strdup("boolean");
        s->ident = ident;
        $$ = s;
    }
    | Identifier
    {
        SimpleType *s = malloc(sizeof(SimpleType));
        s->ident = $1;
        $$ = s;
    }

RecordType:
    RECORD_TOK END_TOK
    {
        RecordType *r = malloc(sizeof(RecordType));
        r->rtl_head = NULL;
        r->rtl_tail = NULL;
        $$ = r;
    }
    | RECORD_TOK RecordTypeList END_TOK
    {
        RecordType *r = malloc(sizeof(RecordType));
        r->rtl_head = $2.head;
        r->rtl_tail = $2.tail;
        $$ = r;
    }

RecordTypeList:
    IdentList COLON_TOK Type SEMICOLON_TOK
    {
        RecordTypeList *record_type_l = malloc(sizeof(RecordTypeList));
        record_type_l->il_head = $1.head;
        record_type_l->il_tail = $1.tail;
        record_type_l->type = $3;
        record_type_l->next = NULL;
        record_type_l->prev = NULL;
        $$.head = record_type_l;
        $$.tail = record_type_l;
    }
    | RecordTypeList IdentList COLON_TOK Type SEMICOLON_TOK
    {
        RecordTypeList *record_type_l = malloc(sizeof(RecordTypeList));
        record_type_l->il_head = $2.head;
        record_type_l->il_tail = $2.tail;
        record_type_l->type = $4;
        record_type_l->next = NULL;
        record_type_l->prev = $1.head;
        $1.tail->next = record_type_l;
        $$.head = $1.head;
        $$.tail = record_type_l;
    }

ArrayType:
    ARRAY_TOK LBRACKET_TOK Expression COLON_TOK Expression RBRACKET_TOK OF_TOK Type
    {
        ArrayType *a = malloc(sizeof(ArrayType));
        a->begin_expr = $3;
        a->end_expr = $5;
        a->type = $8;
        $$ = a;
    }

IdentList:
    Identifier
    {
        IdentList *ident_l = malloc(sizeof(IdentList));
        ident_l->ident = $1;
        ident_l->next = NULL;
        ident_l->prev = NULL;
        $$.head = ident_l;
        $$.tail = ident_l;
    }
    | IdentList COMMA_TOK Identifier
    {
        IdentList *ident_l = malloc(sizeof(IdentList));
        ident_l->ident = $3;
        ident_l->next = NULL;
        ident_l->prev = $1.tail;
        $1.tail->next = ident_l;
        $$.head = $1.head;
        $$.tail = ident_l;
    }

VarDecl:
    VAR_TOK VarDeclList
    {
        VarDecl *v_decl = malloc(sizeof(VarDecl));
        v_decl->vdl_head = $2.head;
        v_decl->vdl_tail = $2.tail;
        $$ = v_decl;
    }

VarDeclList:
    IdentList COLON_TOK Type SEMICOLON_TOK
    {
        VarDeclList *v_decl_l = malloc(sizeof(VarDeclList));
        v_decl_l->il_head = $1.head;
        v_decl_l->il_tail = $1.tail;
        v_decl_l->type = $3;
        v_decl_l->next = NULL;
        v_decl_l->prev = NULL;
        $$.head = v_decl_l;
        $$.tail = v_decl_l;
    }
    | VarDeclList IdentList COLON_TOK Type SEMICOLON_TOK
    {
        VarDeclList *v_decl_l = malloc(sizeof(VarDeclList));
        v_decl_l->il_head = $2.head;
        v_decl_l->il_tail = $2.tail;
        v_decl_l->type = $4;
        v_decl_l->next = NULL;
        v_decl_l->prev = $1.tail;
        $1.tail->next = v_decl_l;
        $$.head = $1.head;
        $$.tail = v_decl_l;
    }

StatementList:
    Statement
    {
        StatementList *stmt_l = malloc(sizeof(StatementList));
        stmt_l->stmt = $1;
        stmt_l->next = NULL;
        stmt_l->prev = NULL;
        $$.head = stmt_l;
        $$.tail = stmt_l;
    }
    | StatementList SEMICOLON_TOK Statement
    {
        StatementList *stmt_l = malloc(sizeof(StatementList));
        stmt_l->stmt = $3;
        stmt_l->next = NULL;
        stmt_l->prev = $1.tail;
        $1.tail->next = stmt_l;
        $$.head = $1.head;
        $$.tail = stmt_l;
    }

Statement:
    Assignment
    {
        Statement *s = malloc(sizeof(Statement));
        s->tag = STMT_ASSIGN;
        s->stmt_union.assign_stmt = $1;
        $$ = s;
    }
    | IfStatement
    {
        Statement *s = malloc(sizeof(Statement));
        s->tag = STMT_IF;
        s->stmt_union.if_stmt = $1;
        $$ = s;
    }
    | WhileStatement
    {
        Statement *s = malloc(sizeof(Statement));
        s->tag = STMT_WHILE;
        s->stmt_union.while_stmt = $1;
        $$ = s;
    }
    | RepeatStatement
    {
        Statement *s = malloc(sizeof(Statement));
        s->tag = STMT_REPEAT;
        s->stmt_union.repeat_stmt = $1;
        $$ = s;
    }
    | ForStatement
    {
        Statement *s = malloc(sizeof(Statement));
        s->tag = STMT_FOR;
        s->stmt_union.for_stmt = $1;
        $$ = s;
    }
    | StopStatement
    {
        Statement *s = malloc(sizeof(Statement));
        s->tag = STMT_STOP;
        s->stmt_union.stop_stmt = $1;
        $$ = s;
    }
    | ReturnStatement
    {
        Statement *s = malloc(sizeof(Statement));
        s->tag = STMT_RETURN;
        s->stmt_union.return_stmt = $1;
        $$ = s;
    }
    | ReadStatement
    {
        $$ = NULL;
        Statement *s = malloc(sizeof(Statement));
        s->tag = STMT_READ;
        s->stmt_union.read_stmt = $1;
        $$ = s;
    }
    | WriteStatement
    {
        $$ = NULL;
        Statement *s = malloc(sizeof(Statement));
        s->tag = STMT_WRITE;
        s->stmt_union.write_stmt = $1;
        $$ = s;
    }
    | ProcedureCall
    {
        $$ = NULL;
        Statement *s = malloc(sizeof(Statement));
        s->tag = STMT_PCALL;
        s->stmt_union.pcall_stmt = $1;
        $$ = s;
    }
    | NullStatement
    {
        Statement *s = malloc(sizeof(Statement));
        s->tag = STMT_NULL;
        s->stmt_union.null_stmt = $1;
        $$ = s;
    }

Assignment:
    LValue ASSIGN_TOK Expression
    {
        AssignStatement *assign = malloc(sizeof(AssignStatement));
        assign->lvalue = $1;
        assign->expr = $3;
        $$ = assign;
    }

IfStatement:
    IF_TOK Expression THEN_TOK StatementList END_TOK
    {
        IfStatement *if_stmt = malloc(sizeof(IfStatement));
        if_stmt->if_cond = $2;
        if_stmt->if_sl_head = $4.head;
        if_stmt->if_sl_tail = $4.tail;
        if_stmt->eil_head = NULL;
        if_stmt->eil_tail = NULL;
        if_stmt->else_sl_head = NULL;
        if_stmt->else_sl_tail = NULL;
        $$ = if_stmt;
    }
    | IF_TOK Expression THEN_TOK StatementList ELSE_TOK StatementList END_TOK
    {
        IfStatement *if_stmt = malloc(sizeof(IfStatement));
        if_stmt->if_cond = $2;
        if_stmt->if_sl_head = $4.head;
        if_stmt->if_sl_tail = $4.tail;
        if_stmt->eil_head = NULL;
        if_stmt->eil_tail = NULL;
        if_stmt->else_sl_head = $6.head;
        if_stmt->else_sl_tail = $6.tail;
        $$ = if_stmt;
    }
    | IF_TOK Expression THEN_TOK StatementList ElseIfList END_TOK
    {
        IfStatement *if_stmt = malloc(sizeof(IfStatement));
        if_stmt->if_cond = $2;
        if_stmt->if_sl_head = $4.head;
        if_stmt->if_sl_tail = $4.tail;
        if_stmt->eil_head = $5.head;
        if_stmt->eil_tail = $5.tail;
        if_stmt->else_sl_head = NULL;
        if_stmt->else_sl_tail = NULL;
        $$ = if_stmt;
    }
    | IF_TOK Expression THEN_TOK StatementList ElseIfList ELSE_TOK StatementList END_TOK
    {
        IfStatement *if_stmt = malloc(sizeof(IfStatement));
        if_stmt->if_cond = $2;
        if_stmt->if_sl_head = $4.head;
        if_stmt->if_sl_tail = $4.tail;
        if_stmt->eil_head = $5.head;
        if_stmt->eil_tail = $5.tail;
        if_stmt->else_sl_head = $7.head;
        if_stmt->else_sl_tail = $7.tail;
        $$ = if_stmt;
    }

ElseIfList:
    ELSEIF_TOK Expression THEN_TOK StatementList
    {
        ElseIfList *ei_l = malloc(sizeof(ElseIfList));
        ei_l->ei_cond = $2;
        ei_l->ei_sl_head = $4.head;
        ei_l->ei_sl_tail = $4.tail;
        ei_l->next = NULL;
        ei_l->prev = NULL;
        $$.head = ei_l;
        $$.tail = ei_l;
    }
    | ElseIfList ELSEIF_TOK Expression THEN_TOK StatementList
    {
        ElseIfList *ei_l = malloc(sizeof(ElseIfList));
        ei_l->ei_cond = $3;
        ei_l->ei_sl_head = $5.head;
        ei_l->ei_sl_tail = $5.tail;
        ei_l->next = NULL;
        ei_l->prev = $1.tail;
        $1.tail->next = ei_l;
        $$.head = $1.head;
        $$.tail = ei_l;
    }

WhileStatement:
    WHILE_TOK Expression DO_TOK StatementList END_TOK
    {
        WhileStatement *while_stmt = malloc(sizeof(WhileStatement));
        while_stmt->while_cond = $2;
        while_stmt->while_sl_head = $4.head;
        while_stmt->while_sl_tail = $4.tail;
        $$ = while_stmt;
    }

RepeatStatement:
    REPEAT_TOK StatementList UNTIL_TOK Expression
    {
        RepeatStatement *repeat_stmt = malloc(sizeof(RepeatStatement));
        repeat_stmt->repeat_cond = $4;
        repeat_stmt->repeat_sl_head = $2.head;
        repeat_stmt->repeat_sl_tail = $2.tail;
        $$ = repeat_stmt;
    }

ForStatement:
    FOR_TOK Identifier ASSIGN_TOK Expression TO_TOK Expression
    {
        ForStatement *for_stmt = malloc(sizeof(ForStatement));
        for_stmt->tag = FOR_UP;
        for_stmt->loop_var = $2;
        for_stmt->begin_expr = $4;
        for_stmt->end_expr = $6;
        $<for_ptr>$ = for_stmt;
    }
    DO_TOK StatementList END_TOK
    {
        ForStatement *for_stmt = $<for_ptr>7;
        for_stmt->for_sl_head = $9.head;
        for_stmt->for_sl_tail = $9.tail;
    }
    | FOR_TOK Identifier ASSIGN_TOK Expression DOWNTO_TOK Expression
    {
        ForStatement *for_stmt = malloc(sizeof(ForStatement));
        for_stmt->tag = FOR_DOWN;
        for_stmt->loop_var = $2;
        for_stmt->begin_expr = $4;
        for_stmt->end_expr = $6;
        $<for_ptr>$ = for_stmt;
    }
    DO_TOK StatementList END_TOK
    {
        ForStatement *for_stmt = $<for_ptr>7;
        for_stmt->for_sl_head = $9.head;
        for_stmt->for_sl_tail = $9.tail;
    }

StopStatement:
    STOP_TOK
    {
        /* stop statement has no members */
        $$ = malloc(sizeof(StopStatement));
    }

ReturnStatement:
    RETURN_TOK
    {
        ReturnStatement *return_stmt = malloc(sizeof(ReturnStatement));
        return_stmt->return_val = NULL;
        $$ = return_stmt;
    }
    | RETURN_TOK Expression
    {
        ReturnStatement *return_stmt = malloc(sizeof(ReturnStatement));
        return_stmt->return_val = $2;
        $$ = return_stmt;
    }

ReadStatement:
    READ_TOK LPAREN_TOK ReadList RPAREN_TOK
    {
        ReadStatement *read_stmt = malloc(sizeof(ReadStatement));
        read_stmt->rl_head = $3.head;
        read_stmt->rl_tail = $3.tail;
        $$ = read_stmt;
    }

ReadList:
    LValue
    {
        ReadList *read_l = malloc(sizeof(ReadList));
        read_l->lvalue = $1;
        read_l->next = NULL;
        read_l->prev = NULL;
        $$.head = read_l;
        $$.tail = read_l;
    }
    | ReadList COMMA_TOK LValue
    {
        ReadList *read_l = malloc(sizeof(ReadList));
        read_l->lvalue = $3;
        read_l->next = NULL;
        read_l->prev = $1.tail;
        $1.tail->next = read_l;
        $$.head = $1.head;
        $$.tail = read_l;
    }

WriteStatement:
    WRITE_TOK LPAREN_TOK WriteList RPAREN_TOK
    {
        WriteStatement *write_stmt = malloc(sizeof(WriteStatement));
        write_stmt->wl_head = $3.head;
        write_stmt->wl_tail = $3.tail;
        $$ = write_stmt;
    }

WriteList:
    Expression
    {
        WriteList *write_l = malloc(sizeof(WriteList));
        write_l->expr = $1;
        write_l->next = NULL;
        write_l->prev = NULL;
        $$.head = write_l;
        $$.tail = write_l;
    }
    | WriteList COMMA_TOK Expression
    {
        WriteList *write_l = malloc(sizeof(WriteList));
        write_l->expr = $3;
        write_l->next = NULL;
        write_l->prev = $1.tail;
        $1.tail->next = write_l;
        $$.head = $1.head;
        $$.tail = write_l;
    }

ProcedureCall:
    Identifier LPAREN_TOK ArgumentList RPAREN_TOK
    {
        PCallStatement *pcall_stmt = malloc(sizeof(PCallStatement));
        pcall_stmt->ident = $1;
        pcall_stmt->al_head = $3.head;
        pcall_stmt->al_tail = $3.tail;
        $$ = pcall_stmt;
    }

ArgumentList:
    %empty
    {
        $$.head = NULL;
        $$.tail = NULL;
    }
    | Expression
    {
        ArgumentList *arg_l = malloc(sizeof(ArgumentList));
        arg_l->expr = $1;
        arg_l->next = NULL;
        arg_l->prev = NULL;
        $$.head = arg_l;
        $$.tail = arg_l;
    }
    | ArgumentList COMMA_TOK Expression
    {
        ArgumentList *arg_l = malloc(sizeof(ArgumentList));
        arg_l->expr = $3;
        arg_l->next = NULL;
        arg_l->prev = $1.head;
        $1.head->next = arg_l;
        $$.head = $1.head;
        $$.tail = arg_l;
    }

NullStatement:
    %empty
    {
        /* null statement has no members */
        $$ = malloc(sizeof(NullStatement));
    }

Expression:
    Expression OR_TOK Expression
    {
        Expression *e = malloc(sizeof(Expression));
        e->tag = EXPR_OR;
        e->expr_union.bin_op.left = $1;
        e->expr_union.bin_op.right = $3;
        $$ = e;
    }
    | Expression AND_TOK Expression
    {
        Expression *e = malloc(sizeof(Expression));
        e->tag = EXPR_AND;
        e->expr_union.bin_op.left = $1;
        e->expr_union.bin_op.right = $3;
        $$ = e;
    }
    | Expression EQUALS_TOK Expression
    {
        Expression *e = malloc(sizeof(Expression));
        e->tag = EXPR_EQ;
        e->expr_union.bin_op.left = $1;
        e->expr_union.bin_op.right = $3;
        $$ = e;
    }
    | Expression NEQ_TOK Expression
    {
        Expression *e = malloc(sizeof(Expression));
        e->tag = EXPR_NEQ;
        e->expr_union.bin_op.left = $1;
        e->expr_union.bin_op.right = $3;
        $$ = e;
    }
    | Expression LE_TOK Expression
    {
        Expression *e = malloc(sizeof(Expression));
        e->tag = EXPR_LE;
        e->expr_union.bin_op.left = $1;
        e->expr_union.bin_op.right = $3;
        $$ = e;
    }
    | Expression GE_TOK Expression
    {
        Expression *e = malloc(sizeof(Expression));
        e->tag = EXPR_GE;
        e->expr_union.bin_op.left = $1;
        e->expr_union.bin_op.right = $3;
        $$ = e;
    }
    | Expression LT_TOK Expression
    {
        Expression *e = malloc(sizeof(Expression));
        e->tag = EXPR_LT;
        e->expr_union.bin_op.left = $1;
        e->expr_union.bin_op.right = $3;
        $$ = e;
    }
    | Expression GT_TOK Expression
    {
        Expression *e = malloc(sizeof(Expression));
        e->tag = EXPR_GT;
        e->expr_union.bin_op.left = $1;
        e->expr_union.bin_op.right = $3;
        $$ = e;
    }
    | Expression ADD_TOK Expression
    {
        Expression *e = malloc(sizeof(Expression));
        e->tag = EXPR_ADD;
        e->expr_union.bin_op.left = $1;
        e->expr_union.bin_op.right = $3;
        $$ = e;
    }
    | Expression SUB_TOK Expression
    {
        Expression *e = malloc(sizeof(Expression));
        e->tag = EXPR_SUB;
        e->expr_union.bin_op.left = $1;
        e->expr_union.bin_op.right = $3;
        $$ = e;
    }
    | Expression MUL_TOK Expression
    {
        Expression *e = malloc(sizeof(Expression));
        e->tag = EXPR_MUL;
        e->expr_union.bin_op.left = $1;
        e->expr_union.bin_op.right = $3;
        $$ = e;
    }
    | Expression DIV_TOK Expression
    {
        Expression *e = malloc(sizeof(Expression));
        e->tag = EXPR_DIV;
        e->expr_union.bin_op.left = $1;
        e->expr_union.bin_op.right = $3;
        $$ = e;
    }
    | Expression MOD_TOK Expression
    {
        Expression *e = malloc(sizeof(Expression));
        e->tag = EXPR_MOD;
        e->expr_union.bin_op.left = $1;
        e->expr_union.bin_op.right = $3;
        $$ = e;
    }
    | NOT_TOK Expression
    {
        Expression *e = malloc(sizeof(Expression));
        e->tag = EXPR_NOT;
        e->expr_union.un_op = $2;
        $$ = e;
    }
    | SUB_TOK Expression %prec UMINUS_TOK
    {
        Expression *e = malloc(sizeof(Expression));
        e->tag = EXPR_UMINUS;
        e->expr_union.un_op = $2;
        $$ = e;
    }
    | LPAREN_TOK Expression RPAREN_TOK
    {
        Expression *e = malloc(sizeof(Expression));
        e->tag = EXPR_UMINUS;
        e->expr_union.un_op = $2;
        $$ = e;
    }
    | Identifier LPAREN_TOK ArgumentList RPAREN_TOK
    {
        Expression *e = malloc(sizeof(Expression));
        e->tag = EXPR_FCALL;
        e->expr_union.fcall.ident = $1;
        e->expr_union.fcall.al_head = $3.head;
        e->expr_union.fcall.al_tail = $3.tail;
        $$ = e;
    }
    | CHR_TOK LPAREN_TOK Expression RPAREN_TOK
    {
        Expression *e = malloc(sizeof(Expression));
        e->tag = EXPR_CHR;
        e->expr_union.un_op = $3;
        $$ = e;
    }
    | ORD_TOK LPAREN_TOK Expression RPAREN_TOK
    {
        Expression *e = malloc(sizeof(Expression));
        e->tag = EXPR_ORD;
        e->expr_union.un_op = $3;
        $$ = e;
    }
    | PRED_TOK LPAREN_TOK Expression RPAREN_TOK
    {
        Expression *e = malloc(sizeof(Expression));
        e->tag = EXPR_PRED;
        e->expr_union.un_op = $3;
        $$ = e;
    }
    | SUCC_TOK LPAREN_TOK Expression RPAREN_TOK
    {
        Expression *e = malloc(sizeof(Expression));
        e->tag = EXPR_SUCC;
        e->expr_union.un_op = $3;
        $$ = e;
    }
    | LValue
    {
        Expression *e = malloc(sizeof(Expression));
        e->tag = EXPR_LVALUE;
        e->expr_union.lvalue = $1;
        $$ = e;
    }
    | INT_LITERAL_TOK
    {
        Expression *e = malloc(sizeof(Expression));
        e->tag = EXPR_INT;
        e->expr_union.int_literal = $1;
        $$ = e;
    }
    | FLOAT_LITERAL_TOK
    {
        Expression *e = malloc(sizeof(Expression));
        e->tag = EXPR_FLOAT;
        e->expr_union.float_literal = $1;
        $$ = e;
    }
    | CHAR_LITERAL_TOK
    {
        Expression *e = malloc(sizeof(Expression));
        e->tag = EXPR_CHAR;
        e->expr_union.char_literal = $1;
        $$ = e;
    }
    | STRING_LITERAL_TOK
    {
        Expression *e = malloc(sizeof(Expression));
        e->tag = EXPR_STR;
        e->expr_union.str_literal = $1;
        $$ = e;
    }
    | TRUE_TOK
    {
        Expression *e = malloc(sizeof(Expression));
        e->tag = EXPR_BOOL;
        e->expr_union.bool_literal = $1;
        $$ = e;
    }
    | FALSE_TOK
    {
        Expression *e = malloc(sizeof(Expression));
        e->tag = EXPR_BOOL;
        e->expr_union.bool_literal = $1;
        $$ = e;
    }

LValue:
    Identifier
    {
        LValue *lvalue = malloc(sizeof(LValue));
        lvalue->tag = LV_IDENT;
        lvalue->lv_union.ident = $1;
        $$ = lvalue;
    }
    | LValue MEMBER_TOK Identifier
    {
        LValue *lvalue = malloc(sizeof(LValue));
        lvalue->tag = LV_MEMBER;
        lvalue->lv_union.lv_member.ident = $3;
        lvalue->lv_union.lv_member.parent_lv = $1;
        $$ = lvalue;
    }
    | LValue LBRACKET_TOK Expression RBRACKET_TOK
    {
        LValue *lvalue = malloc(sizeof(LValue));
        lvalue->tag = LV_ARRAY;
        lvalue->lv_union.lv_array.index_expr = $3;
        lvalue->lv_union.lv_array.parent_lv = $1;
        $$ = lvalue;
    }

Identifier:
    IDENTIFIER_TOK
    {
        Identifier *ident = malloc(sizeof(Identifier));
        ident->name = $1;
        $$ = ident;
    }

%%

// C support functions

