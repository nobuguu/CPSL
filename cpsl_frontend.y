
%{
// C declarations
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "../parse_tree.h"
#include "../symbol_table.h"

extern int yylex(void);
extern int yyerror(const char*);
%}

/* Bison declarations */

%code requires {
    #include "../parse_tree.h"
}

%verbose

%union {
    ParseTree *pt_node;
    /*ParseTreeList pt_list;*/
    struct {ParseTree *list_head; ParseTree *list_tail;} pt_list;
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

%type <int_literal> INT_LITERAL_TOK;
%type <float_literal> FLOAT_LITERAL_TOK;
%type <char_literal> CHAR_LITERAL_TOK;
%type <str_literal> STRING_LITERAL_TOK;
%type <bool_literal> TRUE_TOK;
%type <bool_literal> FALSE_TOK;
%type <pt_node> Program ConstantDecl SubroutineDecl FunctionDecl ProcedureDecl
%type <pt_node> FormalParameter Body Block TypeDecl Type SimpleType RecordType
%type <pt_node> ArrayType VarDecl Statement Assignment
%type <pt_node> IfStatement WhileStatement ForStatement StopStatement ReturnStatement ReadStatement
%type <pt_node> RepeatStatement
%type <pt_node> WriteStatement ProcedureCall NullStatement Expression LValue
%type <str_literal> IDENTIFIER_TOK
%type <pt_list> ConstantDeclList SubroutineDeclList FormalParameterList
%type <pt_list> TypeDeclList RecordTypeList IdentList VarDeclList StatementList
%type <pt_list> ElseIfList ReadList WriteList ArgumentList

%%

/* grammar rules */

Program:
    Block MEMBER_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_PROGRAM;
        p->pt_union.program.c_decl = NULL;
        p->pt_union.program.t_decl = NULL;
        p->pt_union.program.v_decl = NULL;
        p->pt_union.program.s_decl = NULL;
        p->pt_union.program.block = $1;
        $$ = p;
    }
    | ConstantDecl Block MEMBER_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_PROGRAM;
        p->pt_union.program.c_decl = $1;
        p->pt_union.program.t_decl = NULL;
        p->pt_union.program.v_decl = NULL;
        p->pt_union.program.s_decl = NULL;
        p->pt_union.program.block = $2;
        $$ = p;
    }
    | TypeDecl Block MEMBER_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_PROGRAM;
        p->pt_union.program.c_decl = NULL;
        p->pt_union.program.t_decl = $1;
        p->pt_union.program.v_decl = NULL;
        p->pt_union.program.s_decl = NULL;
        p->pt_union.program.block = $2;
        $$ = p;
    }
    | VarDecl Block MEMBER_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_PROGRAM;
        p->pt_union.program.c_decl = NULL;
        p->pt_union.program.t_decl = NULL;
        p->pt_union.program.v_decl = $1;
        p->pt_union.program.s_decl = NULL;
        p->pt_union.program.block = $2;
        $$ = p;
    }
    | SubroutineDecl Block MEMBER_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_PROGRAM;
        p->pt_union.program.c_decl = NULL;
        p->pt_union.program.t_decl = NULL;
        p->pt_union.program.v_decl = NULL;
        p->pt_union.program.s_decl = $1;
        p->pt_union.program.block = $2;
        $$ = p;
    }
    | ConstantDecl TypeDecl Block MEMBER_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_PROGRAM;
        p->pt_union.program.c_decl = $1;
        p->pt_union.program.t_decl = $2;
        p->pt_union.program.v_decl = NULL;
        p->pt_union.program.s_decl = NULL;
        p->pt_union.program.block = $3;
        $$ = p;
    }
    | ConstantDecl VarDecl Block MEMBER_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_PROGRAM;
        p->pt_union.program.c_decl = $1;
        p->pt_union.program.t_decl = NULL;
        p->pt_union.program.v_decl = $2;
        p->pt_union.program.s_decl = NULL;
        p->pt_union.program.block = $3;
        $$ = p;
    }
    | ConstantDecl SubroutineDecl Block MEMBER_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_PROGRAM;
        p->pt_union.program.c_decl = $1;
        p->pt_union.program.t_decl = NULL;
        p->pt_union.program.v_decl = NULL;
        p->pt_union.program.s_decl = $2;
        p->pt_union.program.block = $3;
        $$ = p;
    }
    | TypeDecl VarDecl Block MEMBER_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_PROGRAM;
        p->pt_union.program.c_decl = NULL;
        p->pt_union.program.t_decl = $1;
        p->pt_union.program.v_decl = $2;
        p->pt_union.program.s_decl = NULL;
        p->pt_union.program.block = $3;
        $$ = p;
    }
    | TypeDecl SubroutineDecl Block MEMBER_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_PROGRAM;
        p->pt_union.program.c_decl = NULL;
        p->pt_union.program.t_decl = $1;
        p->pt_union.program.v_decl = NULL;
        p->pt_union.program.s_decl = $2;
        p->pt_union.program.block = $3;
        $$ = p;
    }
    | VarDecl SubroutineDecl Block MEMBER_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_PROGRAM;
        p->pt_union.program.c_decl = NULL;
        p->pt_union.program.t_decl = NULL;
        p->pt_union.program.v_decl = $1;
        p->pt_union.program.s_decl = $2;
        p->pt_union.program.block = $3;
        $$ = p;
    }
    | ConstantDecl TypeDecl VarDecl Block MEMBER_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_PROGRAM;
        p->pt_union.program.c_decl = $1;
        p->pt_union.program.t_decl = $2;
        p->pt_union.program.v_decl = $3;
        p->pt_union.program.s_decl = NULL;
        p->pt_union.program.block = $4;
        $$ = p;
    }
    | ConstantDecl TypeDecl SubroutineDecl Block MEMBER_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_PROGRAM;
        p->pt_union.program.c_decl = $1;
        p->pt_union.program.t_decl = $2;
        p->pt_union.program.v_decl = NULL;
        p->pt_union.program.s_decl = $3;
        p->pt_union.program.block = $4;
        $$ = p;
    }
    | ConstantDecl VarDecl SubroutineDecl Block MEMBER_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_PROGRAM;
        p->pt_union.program.c_decl = $1;
        p->pt_union.program.t_decl = NULL;
        p->pt_union.program.v_decl = $2;
        p->pt_union.program.s_decl = $3;
        p->pt_union.program.block = $4;
        $$ = p;
    }
    | TypeDecl VarDecl SubroutineDecl Block MEMBER_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_PROGRAM;
        p->pt_union.program.c_decl = NULL;
        p->pt_union.program.t_decl = $1;
        p->pt_union.program.v_decl = $2;
        p->pt_union.program.s_decl = $3;
        p->pt_union.program.block = $4;
        $$ = p;
    }
    | ConstantDecl TypeDecl VarDecl SubroutineDecl Block MEMBER_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_PROGRAM;
        p->pt_union.program.c_decl = $1;
        p->pt_union.program.t_decl = $2;
        p->pt_union.program.v_decl = $3;
        p->pt_union.program.s_decl = $4;
        p->pt_union.program.block = $5;
        $$ = p;
    }

ConstantDecl:
    CONST_TOK ConstantDeclList
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_C_DECL;
        p->pt_union.c_decl.cdl_head = $2.list_head;
        p->pt_union.c_decl.cdl_tail = $2.list_tail;
        $$ = p;
    }

ConstantDeclList:
    IDENTIFIER_TOK EQUALS_TOK Expression SEMICOLON_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        ParseTree *ident = malloc(sizeof(ParseTree));
        p->pt_tag = PT_C_DECL_L;
        ident->pt_tag = PT_IDENT;
        ident->pt_union.identifier.name = strdup($1);
        p->pt_union.c_decl_l.next = NULL;
        p->pt_union.c_decl_l.prev = NULL;
        p->pt_union.c_decl_l.ident = ident;
        p->pt_union.c_decl_l.expr = $3;

        //decl, insert ident into symbol table
        add_to_table(ST_CONST, ident, p);

        $$.list_head = p;
        $$.list_tail = p;
    }
    | ConstantDeclList IDENTIFIER_TOK EQUALS_TOK Expression SEMICOLON_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        ParseTree *ident = malloc(sizeof(ParseTree));
        p->pt_tag = PT_C_DECL_L;
        ident->pt_tag = PT_IDENT;
        ident->pt_union.identifier.name = strdup($2);
        p->pt_union.c_decl_l.next = NULL;
        p->pt_union.c_decl_l.prev = $1.list_tail;
        p->pt_union.c_decl_l.ident = ident;
        p->pt_union.c_decl_l.expr = $4;

        add_to_table(ST_CONST, ident, p);
        $$.list_tail->pt_union.c_decl_l.next = p;
        $$.list_tail = p;
        $$.list_head = $1.list_head;
    }

SubroutineDecl:
    SubroutineDeclList
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_S_DECL;
        p->pt_union.s_decl.sdl_head = $1.list_head;
        p->pt_union.s_decl.sdl_tail = $1.list_tail;
        $$ = p;
    }

SubroutineDeclList:
    ProcedureDecl
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_S_DECL_L;
        p->pt_union.s_decl_l.sd_tag = SD_PROCEDURE;
        p->pt_union.s_decl_l.sdl_union.p_decl = $1;
        p->pt_union.s_decl_l.prev = NULL;
        p->pt_union.s_decl_l.next = NULL;
        $$.list_head = p;
        $$.list_tail = p;
    }
    | FunctionDecl
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_S_DECL_L;
        p->pt_union.s_decl_l.sd_tag = SD_FUNCTION;
        p->pt_union.s_decl_l.sdl_union.f_decl = $1;
        p->pt_union.s_decl_l.prev = NULL;
        p->pt_union.s_decl_l.next = NULL;
        $$.list_head = p;
        $$.list_tail = p;
    }
    | SubroutineDeclList ProcedureDecl
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_S_DECL_L;
        p->pt_union.s_decl_l.sd_tag = SD_PROCEDURE;
        p->pt_union.s_decl_l.sdl_union.p_decl = $2;
        p->pt_union.s_decl_l.prev = $1.list_tail;
        p->pt_union.s_decl_l.next = NULL;
        $$.list_head = $1.list_head;
        $1.list_tail->pt_union.s_decl_l.next = p;
        $$.list_tail = p;
    }
    | SubroutineDeclList FunctionDecl
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_S_DECL_L;
        p->pt_union.s_decl_l.sd_tag = SD_FUNCTION;
        p->pt_union.s_decl_l.sdl_union.f_decl = $2;
        p->pt_union.s_decl_l.prev = $1.list_tail;
        p->pt_union.s_decl_l.next = NULL;
        $$.list_head = $1.list_head;
        $1.list_tail->pt_union.s_decl_l.next = p;
        $$.list_tail = p;
    }

ProcedureDecl:
    PROCEDURE_TOK IDENTIFIER_TOK LPAREN_TOK FormalParameterList RPAREN_TOK SEMICOLON_TOK FORWARD_TOK SEMICOLON_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        ParseTree *ident = malloc(sizeof(ParseTree));
        ident->pt_tag = PT_IDENT;
        ident->pt_union.identifier.name = $2;
        p->pt_tag = PT_P_DECL;
        p->pt_union.p_decl.ident = ident;
        p->pt_union.p_decl.fpl_head = $4.list_head;
        p->pt_union.p_decl.fpl_tail = $4.list_tail;
        p->pt_union.p_decl.body = NULL;

        add_to_table(ST_SUB, ident, p);
        $$ = p;
    }
    | PROCEDURE_TOK IDENTIFIER_TOK LPAREN_TOK FormalParameterList RPAREN_TOK SEMICOLON_TOK Body SEMICOLON_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        ParseTree *ident = malloc(sizeof(ParseTree));
        ident->pt_tag = PT_IDENT;
        ident->pt_union.identifier.name = $2;
        p->pt_tag = PT_P_DECL;
        p->pt_union.p_decl.ident = ident;
        p->pt_union.p_decl.fpl_head = $4.list_head;
        p->pt_union.p_decl.fpl_tail = $4.list_tail;
        p->pt_union.p_decl.body = $7;

        add_to_table(ST_SUB, ident, p);
        $$ = p;
    }

FunctionDecl:
    FUNCTION_TOK IDENTIFIER_TOK LPAREN_TOK FormalParameterList RPAREN_TOK COLON_TOK Type SEMICOLON_TOK FORWARD_TOK SEMICOLON_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        ParseTree *ident = malloc(sizeof(ParseTree));
        ident->pt_tag = PT_IDENT;
        ident->pt_union.identifier.name = $2;
        p->pt_tag = PT_F_DECL;
        p->pt_union.f_decl.ident = ident;
        p->pt_union.f_decl.fpl_head = $4.list_head;
        p->pt_union.f_decl.fpl_tail = $4.list_tail;
        p->pt_union.f_decl.return_t = $7;
        p->pt_union.f_decl.body = NULL;

        add_to_table(ST_SUB, ident, p);
        $$ = p;
    }
    | FUNCTION_TOK IDENTIFIER_TOK LPAREN_TOK FormalParameterList RPAREN_TOK COLON_TOK Type SEMICOLON_TOK Body SEMICOLON_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        ParseTree *ident = malloc(sizeof(ParseTree));
        ident->pt_tag = PT_IDENT;
        ident->pt_union.identifier.name = $2;
        p->pt_tag = PT_F_DECL;
        p->pt_union.f_decl.ident = ident;
        p->pt_union.f_decl.fpl_head = $4.list_head;
        p->pt_union.f_decl.fpl_tail = $4.list_tail;
        p->pt_union.f_decl.return_t = $7;
        p->pt_union.f_decl.body = $9;

        add_to_table(ST_SUB, ident, p);
        $$ = p;
    }

FormalParameterList:
    %empty
    {
        $$.list_head = NULL;
        $$.list_tail = NULL;
    }
    | FormalParameter
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_FORMAL_PARAM_L;
        p->pt_union.formal_param_l.param = $1;
        p->pt_union.formal_param_l.next = NULL;
        p->pt_union.formal_param_l.prev = NULL;
        $$.list_head = p;
        $$.list_tail = p;
    }
    | FormalParameterList SEMICOLON_TOK FormalParameter
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_FORMAL_PARAM_L;
        p->pt_union.formal_param_l.param = $3;
        p->pt_union.formal_param_l.next = NULL;
        p->pt_union.formal_param_l.prev = $1.list_tail;
        $1.list_tail->pt_union.formal_param_l.next = p;
        $$.list_tail = p;
        $$.list_head = $1.list_head;
    }

FormalParameter:
    IdentList COLON_TOK Type
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_FORMAL_PARAM;
        p->pt_union.formal_param.fp_tag = FP_VAR;
        p->pt_union.formal_param.il_head = $1.list_head;
        p->pt_union.formal_param.il_tail = $1.list_tail;
        p->pt_union.formal_param.type = $3;
        $$ = p;
    }
    | VAR_TOK IdentList COLON_TOK Type
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_FORMAL_PARAM;
        p->pt_union.formal_param.fp_tag = FP_VAR;
        p->pt_union.formal_param.il_head = $2.list_head;
        p->pt_union.formal_param.il_tail = $2.list_tail;
        p->pt_union.formal_param.type = $4;
        $$ = p;
    }
    | REF_TOK IdentList COLON_TOK Type
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_FORMAL_PARAM;
        p->pt_union.formal_param.fp_tag = FP_REF;
        p->pt_union.formal_param.il_head = $2.list_head;
        p->pt_union.formal_param.il_tail = $2.list_tail;
        p->pt_union.formal_param.type = $4;
        $$ = p;
    }

Body:
    Block
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_BLOCK;
        p->pt_union.body.c_decl = NULL;
        p->pt_union.body.t_decl = NULL;
        p->pt_union.body.v_decl = NULL;
        p->pt_union.body.block = $1;
        $$ = p;
    }
    | ConstantDecl Block
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_BLOCK;
        p->pt_union.body.c_decl = $1;
        p->pt_union.body.t_decl = NULL;
        p->pt_union.body.v_decl = NULL;
        p->pt_union.body.block = $2;
        $$ = p;
    }
    | TypeDecl Block
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_BLOCK;
        p->pt_union.body.c_decl = NULL;
        p->pt_union.body.t_decl = $1;
        p->pt_union.body.v_decl = NULL;
        p->pt_union.body.block = $2;
        $$ = p;
    }
    | VarDecl Block
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_BLOCK;
        p->pt_union.body.c_decl = NULL;
        p->pt_union.body.t_decl = NULL;
        p->pt_union.body.v_decl = $1;
        p->pt_union.body.block = $2;
        $$ = p;
    }
    | ConstantDecl TypeDecl Block
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_BLOCK;
        p->pt_union.body.c_decl = $1;
        p->pt_union.body.t_decl = $2;
        p->pt_union.body.v_decl = NULL;
        p->pt_union.body.block = $3;
        $$ = p;
    }
    | ConstantDecl VarDecl Block
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_BLOCK;
        p->pt_union.body.c_decl = $1;
        p->pt_union.body.t_decl = NULL;
        p->pt_union.body.v_decl = $2;
        p->pt_union.body.block = $3;
        $$ = p;
    }
    | TypeDecl VarDecl Block
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_BLOCK;
        p->pt_union.body.c_decl = NULL;
        p->pt_union.body.t_decl = $1;
        p->pt_union.body.v_decl = $2;
        p->pt_union.body.block = $3;
        $$ = p;
    }
    | ConstantDecl TypeDecl VarDecl Block
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_BLOCK;
        p->pt_union.body.c_decl = $1;
        p->pt_union.body.t_decl = $2;
        p->pt_union.body.v_decl = $3;
        p->pt_union.body.block = $4;
        $$ = p;
    }

Block:
    BEGIN_TOK StatementList END_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_BLOCK;
        p->pt_union.block.sl_head = $2.list_head;
        p->pt_union.block.sl_tail = $2.list_tail;
        $$ = p;
    }

TypeDecl:
    TYPE_TOK TypeDeclList
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_T_DECL;
        p->pt_union.t_decl.tdl_head = $2.list_head;
        p->pt_union.t_decl.tdl_tail = $2.list_tail;
    }

TypeDeclList:
    IDENTIFIER_TOK EQUALS_TOK Type SEMICOLON_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        ParseTree *ident = malloc(sizeof(ParseTree));
        ident->pt_tag = PT_IDENT;
        ident->pt_union.identifier.name = $1;
        p->pt_tag = PT_T_DECL_L;
        p->pt_union.t_decl_l.ident = ident;
        p->pt_union.t_decl_l.type = $3;
        p->pt_union.t_decl_l.next = NULL;
        p->pt_union.t_decl_l.prev = NULL;
        $$.list_head = p;
        $$.list_tail = p;
    }
    | TypeDeclList IDENTIFIER_TOK EQUALS_TOK Type SEMICOLON_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        ParseTree *ident = malloc(sizeof(ParseTree));
        ident->pt_tag = PT_IDENT;
        ident->pt_union.identifier.name = $2;
        p->pt_tag = PT_T_DECL_L;
        p->pt_union.t_decl_l.ident = ident;
        p->pt_union.t_decl_l.type = $4;
        p->pt_union.t_decl_l.next = NULL;
        $1.list_tail->pt_union.t_decl_l.next = p;
        p->pt_union.t_decl_l.prev = $1.list_tail;
        $$.list_head = $1.list_head;
        $$.list_tail = p;
    }

Type:
    SimpleType
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_TYPE;
        p->pt_union.type.tag = T_SIMPLE;
        p->pt_union.type.type_union.simple = $1;
        $$ = p;
    }
    | RecordType
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_TYPE;
        p->pt_union.type.tag = T_RECORD;
        p->pt_union.type.type_union.record = $1;
        $$ = p;
    }
    | ArrayType
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_TYPE;
        p->pt_union.type.tag = T_ARRAY;
        p->pt_union.type.type_union.array = $1;
        $$ = p;
    }

SimpleType:
    INTEGER_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_SIMPLE_TYPE;
        p->pt_union.simple_type.tag = SIMPLE_INT;
        p->pt_union.simple_type.ident = NULL;
        $$ = p;
    }
    | CHAR_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_SIMPLE_TYPE;
        p->pt_union.simple_type.tag = SIMPLE_CHAR;
        p->pt_union.simple_type.ident = NULL;
        $$ = p;
    }
    | FLOAT_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_SIMPLE_TYPE;
        p->pt_union.simple_type.tag = SIMPLE_FLOAT;
        p->pt_union.simple_type.ident = NULL;
        $$ = p;
    }
    | BOOLEAN_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_SIMPLE_TYPE;
        p->pt_union.simple_type.tag = SIMPLE_BOOLEAN;
        p->pt_union.simple_type.ident = NULL;
        $$ = p;
    }
    | IDENTIFIER_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        ParseTree *ident = malloc(sizeof(ParseTree));
        ident->pt_tag = PT_IDENT;
        ident->pt_union.identifier.name = $1;
        p->pt_tag = PT_SIMPLE_TYPE;
        p->pt_union.simple_type.tag = SIMPLE_IDENT;
        p->pt_union.simple_type.ident = ident;
        $$ = p;
    }

RecordType:
    RECORD_TOK END_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_RECORD_TYPE;
        p->pt_union.record_type.rtl_head = NULL;
        p->pt_union.record_type.rtl_tail = NULL;
        $$ = p;
    }
    | RECORD_TOK RecordTypeList END_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_RECORD_TYPE;
        p->pt_union.record_type.rtl_head = $2.list_head;
        p->pt_union.record_type.rtl_tail = $2.list_tail;
        $$ = p;
    }

RecordTypeList:
    IdentList COLON_TOK Type SEMICOLON_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_RECORD_TYPE_L;
        p->pt_union.record_type_l.il_head = $1.list_head;
        p->pt_union.record_type_l.il_tail = $1.list_tail;
        p->pt_union.record_type_l.type = $3;
        p->pt_union.record_type_l.next = NULL;
        p->pt_union.record_type_l.prev = NULL;
        $$.list_head = p;
        $$.list_tail = p;
    }
    | RecordTypeList IdentList COLON_TOK Type SEMICOLON_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_RECORD_TYPE_L;
        p->pt_union.record_type_l.il_head = $2.list_head;
        p->pt_union.record_type_l.il_tail = $2.list_tail;
        p->pt_union.record_type_l.type = $4;
        p->pt_union.record_type_l.next = NULL;
        p->pt_union.record_type_l.prev = $1.list_tail;
        $1.list_tail->pt_union.record_type_l.next = p;
        $$.list_head = $1.list_head;
        $$.list_tail = p;
    }

ArrayType:
    ARRAY_TOK LBRACKET_TOK Expression COLON_TOK Expression RBRACKET_TOK OF_TOK Type
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_ARRAY_TYPE;
        p->pt_union.array_type.begin_expr = $3;
        p->pt_union.array_type.end_expr = $5;
        p->pt_union.array_type.type = $8;
        $$ = p;
    }

IdentList:
    IDENTIFIER_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        ParseTree *ident = malloc(sizeof(ParseTree));
        ident->pt_tag = PT_IDENT;
        ident->pt_union.identifier.name = $1;
        p->pt_tag = PT_IDENT_L;
        p->pt_union.ident_l.ident = ident;
        p->pt_union.ident_l.next = NULL;
        p->pt_union.ident_l.prev = NULL;
        $$.list_head = p;
        $$.list_tail = p;
    }
    | IdentList COMMA_TOK IDENTIFIER_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        ParseTree *ident = malloc(sizeof(ParseTree));
        ident->pt_tag = PT_IDENT;
        ident->pt_union.identifier.name = $3;
        p->pt_tag = PT_IDENT_L;
        p->pt_union.ident_l.ident = ident;
        p->pt_union.ident_l.next = NULL;
        p->pt_union.ident_l.prev = $1.list_tail;
        $$.list_tail->pt_union.ident_l.next = p;
        $$.list_head = $1.list_head;
        $$.list_tail = p;
    }

VarDecl:
    VAR_TOK VarDeclList
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_V_DECL;
        p->pt_union.v_decl.vdl_head = $2.list_head;
        p->pt_union.v_decl.vdl_tail = $2.list_tail;
        $$ = p;
    }

VarDeclList:
    IdentList COLON_TOK Type SEMICOLON_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_V_DECL_L;
        p->pt_union.v_decl_l.il_head = $1.list_head;
        p->pt_union.v_decl_l.il_tail = $1.list_tail;
        p->pt_union.v_decl_l.type = $3;
        p->pt_union.v_decl_l.next = NULL;
        p->pt_union.v_decl_l.prev = NULL;
        $$.list_head = p;
        $$.list_tail = p;
    }
    | VarDeclList IdentList COLON_TOK Type SEMICOLON_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_V_DECL_L;
        p->pt_union.v_decl_l.il_head = $2.list_head;
        p->pt_union.v_decl_l.il_tail = $2.list_tail;
        p->pt_union.v_decl_l.type = $4;
        p->pt_union.v_decl_l.next = NULL;
        p->pt_union.v_decl_l.prev = $1.list_tail;
        $1.list_tail->pt_union.v_decl_l.next = p;
        $$.list_head = $1.list_head;
        $$.list_tail = p;
    }

StatementList:
    Statement
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_STATEMENT_L;
        p->pt_union.statement_l.stmt = $1;
        p->pt_union.statement_l.prev = NULL;
        p->pt_union.statement_l.next = NULL;
        $$.list_head = p;
        $$.list_tail = p;
    }
    | StatementList SEMICOLON_TOK Statement
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_STATEMENT_L;
        p->pt_union.statement_l.stmt = $3;
        p->pt_union.statement_l.prev = $1.list_tail;
        $1.list_tail->pt_union.statement_l.next = p;
        $$.list_head = $1.list_head;
        $$.list_tail = p;
    }

Statement:
    Assignment
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_STATEMENT;
        p->pt_union.statement.tag = STMT_ASSIGN;
        p->pt_union.statement.stmt_union.assign_stmt = $1;
        $$ = p;
    }
    | IfStatement
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_STATEMENT;
        p->pt_union.statement.tag = STMT_IF;
        p->pt_union.statement.stmt_union.if_stmt = $1;
        $$ = p;
    }
    | WhileStatement
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_STATEMENT;
        p->pt_union.statement.tag = STMT_WHILE;
        p->pt_union.statement.stmt_union.while_stmt = $1;
        $$ = p;
    }
    | RepeatStatement
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_STATEMENT;
        p->pt_union.statement.tag = STMT_REPEAT;
        p->pt_union.statement.stmt_union.repeat_stmt = $1;
        $$ = p;
    }
    | ForStatement
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_STATEMENT;
        p->pt_union.statement.tag = STMT_FOR;
        p->pt_union.statement.stmt_union.for_stmt = $1;
        $$ = p;
    }
    | StopStatement
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_STATEMENT;
        p->pt_union.statement.tag = STMT_STOP;
        p->pt_union.statement.stmt_union.stop_stmt = $1;
        $$ = p;
    }
    | ReturnStatement
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_STATEMENT;
        p->pt_union.statement.tag = STMT_RETURN;
        p->pt_union.statement.stmt_union.return_stmt = $1;
        $$ = p;
    }
    | ReadStatement
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_STATEMENT;
        p->pt_union.statement.tag = STMT_READ;
        p->pt_union.statement.stmt_union.read_stmt = $1;
        $$ = p;
    }
    | WriteStatement
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_STATEMENT;
        p->pt_union.statement.tag = STMT_WRITE;
        p->pt_union.statement.stmt_union.write_stmt = $1;
        $$ = p;
    }
    | ProcedureCall
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_STATEMENT;
        p->pt_union.statement.tag = STMT_PCALL;
        p->pt_union.statement.stmt_union.pcall_stmt = $1;
        $$ = p;
    }
    | NullStatement
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_STATEMENT;
        p->pt_union.statement.tag = STMT_NULL;
        p->pt_union.statement.stmt_union.null_stmt = $1;
        $$ = p;
    }

Assignment:
    LValue ASSIGN_TOK Expression
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_ASSIGN_STMT;
        p->pt_union.assign_stmt.lvalue = $1;
        p->pt_union.assign_stmt.expr = $3;
        $$ = p;
    }

IfStatement:
    IF_TOK Expression THEN_TOK StatementList END_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_IF_STMT;
        p->pt_union.if_stmt.if_cond = $2;
        p->pt_union.if_stmt.if_sl_head = $4.list_head;
        p->pt_union.if_stmt.if_sl_tail = $4.list_tail;
        p->pt_union.if_stmt.eil_head = NULL;
        p->pt_union.if_stmt.eil_tail = NULL;
        p->pt_union.if_stmt.else_sl_head = NULL;
        p->pt_union.if_stmt.else_sl_tail = NULL;
        $$ = p;
    }
    | IF_TOK Expression THEN_TOK StatementList ELSE_TOK StatementList END_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_IF_STMT;
        p->pt_union.if_stmt.if_cond = $2;
        p->pt_union.if_stmt.if_sl_head = $4.list_head;
        p->pt_union.if_stmt.if_sl_tail = $4.list_tail;
        p->pt_union.if_stmt.eil_head = NULL;
        p->pt_union.if_stmt.eil_tail = NULL;
        p->pt_union.if_stmt.else_sl_head = $6.list_head;
        p->pt_union.if_stmt.else_sl_tail = $6.list_tail;
        $$ = p;
    }
    | IF_TOK Expression THEN_TOK StatementList ElseIfList END_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_IF_STMT;
        p->pt_union.if_stmt.if_cond = $2;
        p->pt_union.if_stmt.if_sl_head = $4.list_head;
        p->pt_union.if_stmt.if_sl_tail = $4.list_tail;
        p->pt_union.if_stmt.eil_head = $5.list_head;
        p->pt_union.if_stmt.eil_tail = $5.list_tail;
        p->pt_union.if_stmt.else_sl_head = NULL;
        p->pt_union.if_stmt.else_sl_tail = NULL;
        $$ = p;
    }
    | IF_TOK Expression THEN_TOK StatementList ElseIfList ELSE_TOK StatementList END_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_IF_STMT;
        p->pt_union.if_stmt.if_cond = $2;
        p->pt_union.if_stmt.if_sl_head = $4.list_head;
        p->pt_union.if_stmt.if_sl_tail = $4.list_tail;
        p->pt_union.if_stmt.eil_head = $5.list_head;
        p->pt_union.if_stmt.eil_tail = $5.list_tail;
        p->pt_union.if_stmt.else_sl_head = $7.list_head;
        p->pt_union.if_stmt.else_sl_tail = $7.list_tail;
        $$ = p;
    }

ElseIfList:
    ELSEIF_TOK Expression THEN_TOK StatementList
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_ELSEIF_L;
        p->pt_union.elseif_l.ei_cond = $2;
        p->pt_union.elseif_l.ei_sl_head = $4.list_head;
        p->pt_union.elseif_l.ei_sl_tail = $4.list_tail;
        p->pt_union.elseif_l.prev = NULL;
        p->pt_union.elseif_l.next = NULL;
        $$.list_head = p;
        $$.list_tail = p;
    }
    | ElseIfList ELSEIF_TOK Expression THEN_TOK StatementList
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_ELSEIF_L;
        p->pt_union.elseif_l.ei_cond = $3;
        p->pt_union.elseif_l.ei_sl_head = $5.list_head;
        p->pt_union.elseif_l.ei_sl_tail = $5.list_tail;
        p->pt_union.elseif_l.prev = $1.list_tail;
        p->pt_union.elseif_l.next = NULL;
        $1.list_tail->pt_union.elseif_l.next = p;
        $$.list_head = $1.list_head;
        $$.list_tail = p;
    }

WhileStatement:
    WHILE_TOK Expression DO_TOK StatementList END_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_WHILE_STMT;
        p->pt_union.while_stmt.while_cond = $2;
        p->pt_union.while_stmt.while_sl_head = $4.list_head;
        p->pt_union.while_stmt.while_sl_tail = $4.list_tail;
        $$ = p;
    }

RepeatStatement:
    REPEAT_TOK StatementList UNTIL_TOK Expression
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_REPEAT_STMT;
        p->pt_union.repeat_stmt.repeat_cond = $4;
        p->pt_union.repeat_stmt.repeat_sl_head = $2.list_head;
        p->pt_union.repeat_stmt.repeat_sl_tail = $2.list_tail;
        $$ = p;
    }

ForStatement:
    FOR_TOK IDENTIFIER_TOK ASSIGN_TOK Expression TO_TOK Expression DO_TOK StatementList END_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        ParseTree *ident = malloc(sizeof(ParseTree));
        ident->pt_tag = PT_IDENT;
        ident->pt_union.identifier.name = $2;
        p->pt_tag = PT_FOR_STMT;
        p->pt_union.for_stmt.tag = FOR_UP;
        p->pt_union.for_stmt.for_ident = ident;
        p->pt_union.for_stmt.start_expr = $4;
        p->pt_union.for_stmt.end_expr = $6;
        p->pt_union.for_stmt.for_sl_head = $8.list_head;
        p->pt_union.for_stmt.for_sl_tail = $8.list_tail;
        $$ = p;
    }
    | FOR_TOK IDENTIFIER_TOK ASSIGN_TOK Expression DOWNTO_TOK Expression DO_TOK StatementList END_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        ParseTree *ident = malloc(sizeof(ParseTree));
        ident->pt_tag = PT_IDENT;
        ident->pt_union.identifier.name = $2;
        p->pt_tag = PT_FOR_STMT;
        p->pt_union.for_stmt.tag = FOR_DOWN;
        p->pt_union.for_stmt.for_ident = ident;
        p->pt_union.for_stmt.start_expr = $4;
        p->pt_union.for_stmt.end_expr = $6;
        p->pt_union.for_stmt.for_sl_head = $8.list_head;
        p->pt_union.for_stmt.for_sl_tail = $8.list_tail;
        $$ = p;
    }

StopStatement:
    STOP_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_STOP_STMT;
        $$ = p;
    }

ReturnStatement:
    RETURN_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_RETURN_STMT;
        p->pt_union.return_stmt.expr = NULL;
        $$ = p;
    }
    | RETURN_TOK Expression
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_RETURN_STMT;
        p->pt_union.return_stmt.expr = $2;
        $$ = p;
    }

ReadStatement:
    READ_TOK LPAREN_TOK ReadList RPAREN_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_READ_STMT;
        p->pt_union.read_stmt.rl_head = $3.list_head;
        p->pt_union.read_stmt.rl_tail = $3.list_tail;
        $$ = p;
    }

ReadList:
    LValue
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_READ_L;
        p->pt_union.read_l.lvalue = $1;
        p->pt_union.read_l.next = NULL;
        p->pt_union.read_l.prev = NULL;
        $$.list_head = p;
        $$.list_tail = p;
    }
    | ReadList COMMA_TOK LValue
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_READ_L;
        p->pt_union.read_l.lvalue = $3;
        p->pt_union.read_l.next = NULL;
        p->pt_union.read_l.prev = $1.list_tail;
        $1.list_tail->pt_union.read_l.next = p;
        $$.list_head = $1.list_head;
        $$.list_tail = p;
    }

WriteStatement:
    WRITE_TOK LPAREN_TOK WriteList RPAREN_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_WRITE_STMT;
        p->pt_union.write_stmt.wl_head = $3.list_head;
        p->pt_union.write_stmt.wl_tail = $3.list_tail;
        $$ = p;
    }

WriteList:
    Expression
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_WRITE_L;
        p->pt_union.write_l.expr = $1;
        p->pt_union.write_l.next = NULL;
        p->pt_union.write_l.prev = NULL;
        $$.list_head = p;
        $$.list_tail = p;
    }
    | WriteList COMMA_TOK Expression
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_WRITE_L;
        p->pt_union.write_l.expr = $3;
        p->pt_union.write_l.next = NULL;
        p->pt_union.write_l.prev = $1.list_tail;
        $1.list_tail->pt_union.write_l.next = p;
        $$.list_head = $1.list_head;
        $$.list_tail = p;
    }

ProcedureCall:
    IDENTIFIER_TOK LPAREN_TOK ArgumentList RPAREN_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        ParseTree *ident = malloc(sizeof(ParseTree));
        ident->pt_tag = PT_IDENT;
        ident->pt_union.identifier.name = $1;
        p->pt_tag = PT_PCALL_STMT;
        p->pt_union.pcall_stmt.ident = ident;
        p->pt_union.pcall_stmt.al_head = $3.list_head;
        p->pt_union.pcall_stmt.al_tail = $3.list_tail;
        $$ = p;
    }

ArgumentList:
    %empty
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_ARG_L;
        p->pt_union.arg_l.expr = NULL;
        p->pt_union.arg_l.next = NULL;
        p->pt_union.arg_l.prev = NULL;
        $$.list_head = p;
        $$.list_tail = p;
    }
    | Expression
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_ARG_L;
        p->pt_union.arg_l.expr = $1;
        p->pt_union.arg_l.next = NULL;
        p->pt_union.arg_l.prev = NULL;
        $$.list_head = p;
        $$.list_tail = p;
    }
    | ArgumentList COMMA_TOK Expression
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_ARG_L;
        p->pt_union.arg_l.expr = $3;
        p->pt_union.arg_l.next = NULL;
        p->pt_union.arg_l.prev = $1.list_tail;
        $1.list_head->pt_union.arg_l.next = p;
        $$.list_head = $1.list_head;
        $$.list_tail = p;
    }

NullStatement:
    %empty
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_NULL_STMT;
        $$ = p;
    }

Expression:
    Expression OR_TOK Expression
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_EXPR;
        p->pt_union.expr.tag = EXPR_OR;
        p->pt_union.expr.expr_union.bin_op.left = $1;
        p->pt_union.expr.expr_union.bin_op.right = $3;
        $$ = p;
    }
    | Expression AND_TOK Expression
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_EXPR;
        p->pt_union.expr.tag = EXPR_AND;
        p->pt_union.expr.expr_union.bin_op.left = $1;
        p->pt_union.expr.expr_union.bin_op.right = $3;
        $$ = p;
    }
    | Expression EQUALS_TOK Expression
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_EXPR;
        p->pt_union.expr.tag = EXPR_EQ;
        p->pt_union.expr.expr_union.bin_op.left = $1;
        p->pt_union.expr.expr_union.bin_op.right = $3;
        $$ = p;
    }
    | Expression NEQ_TOK Expression
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_EXPR;
        p->pt_union.expr.tag = EXPR_NEQ;
        p->pt_union.expr.expr_union.bin_op.left = $1;
        p->pt_union.expr.expr_union.bin_op.right = $3;
        $$ = p;
    }
    | Expression LE_TOK Expression
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_EXPR;
        p->pt_union.expr.tag = EXPR_LE;
        p->pt_union.expr.expr_union.bin_op.left = $1;
        p->pt_union.expr.expr_union.bin_op.right = $3;
        $$ = p;
    }
    | Expression GE_TOK Expression
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_EXPR;
        p->pt_union.expr.tag = EXPR_GE;
        p->pt_union.expr.expr_union.bin_op.left = $1;
        p->pt_union.expr.expr_union.bin_op.right = $3;
        $$ = p;
    }
    | Expression LT_TOK Expression
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_EXPR;
        p->pt_union.expr.tag = EXPR_LT;
        p->pt_union.expr.expr_union.bin_op.left = $1;
        p->pt_union.expr.expr_union.bin_op.right = $3;
        $$ = p;
    }
    | Expression GT_TOK Expression
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_EXPR;
        p->pt_union.expr.tag = EXPR_GT;
        p->pt_union.expr.expr_union.bin_op.left = $1;
        p->pt_union.expr.expr_union.bin_op.right = $3;
        $$ = p;
    }
    | Expression ADD_TOK Expression
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_EXPR;
        p->pt_union.expr.tag = EXPR_ADD;
        p->pt_union.expr.expr_union.bin_op.left = $1;
        p->pt_union.expr.expr_union.bin_op.right = $3;
        $$ = p;
    }
    | Expression SUB_TOK Expression
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_EXPR;
        p->pt_union.expr.tag = EXPR_SUB;
        p->pt_union.expr.expr_union.bin_op.left = $1;
        p->pt_union.expr.expr_union.bin_op.right = $3;
        $$ = p;
    }
    | Expression MUL_TOK Expression
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_EXPR;
        p->pt_union.expr.tag = EXPR_MUL;
        p->pt_union.expr.expr_union.bin_op.left = $1;
        p->pt_union.expr.expr_union.bin_op.right = $3;
        $$ = p;
    }
    | Expression DIV_TOK Expression
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_EXPR;
        p->pt_union.expr.tag = EXPR_DIV;
        p->pt_union.expr.expr_union.bin_op.left = $1;
        p->pt_union.expr.expr_union.bin_op.right = $3;
        $$ = p;
    }
    | Expression MOD_TOK Expression
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_EXPR;
        p->pt_union.expr.tag = EXPR_MOD;
        p->pt_union.expr.expr_union.bin_op.left = $1;
        p->pt_union.expr.expr_union.bin_op.right = $3;
        $$ = p;
    }
    | NOT_TOK Expression
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_EXPR;
        p->pt_union.expr.tag = EXPR_NOT;
        p->pt_union.expr.expr_union.un_op.sub_expr = $2;
        $$ = p;
    }
    | SUB_TOK Expression %prec UMINUS_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_EXPR;
        p->pt_union.expr.tag = EXPR_UMINUS;
        p->pt_union.expr.expr_union.un_op.sub_expr = $2;
        $$ = p;
    }
    | LPAREN_TOK Expression RPAREN_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_EXPR;
        p->pt_union.expr.tag = EXPR_PAREN;
        p->pt_union.expr.expr_union.un_op.sub_expr = $2;
        $$ = p;
    }
    | IDENTIFIER_TOK LPAREN_TOK ArgumentList RPAREN_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        ParseTree *ident = malloc(sizeof(ParseTree));
        ident->pt_tag = PT_IDENT;
        ident->pt_union.identifier.name = $1;
        p->pt_tag = PT_EXPR;
        p->pt_union.expr.tag = EXPR_FCALL;
        p->pt_union.expr.expr_union.fcall.ident = ident;
        p->pt_union.expr.expr_union.fcall.arg_l_head = $3.list_head;
        p->pt_union.expr.expr_union.fcall.arg_l_tail = $3.list_tail;
        $$ = p;
    }
    | CHR_TOK LPAREN_TOK Expression RPAREN_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_EXPR;
        p->pt_union.expr.tag = EXPR_CHR;
        p->pt_union.expr.expr_union.un_op.sub_expr = $3;
        $$ = p;
    }
    | ORD_TOK LPAREN_TOK Expression RPAREN_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_EXPR;
        p->pt_union.expr.tag = EXPR_ORD;
        p->pt_union.expr.expr_union.un_op.sub_expr = $3;
        $$ = p;
    }
    | PRED_TOK LPAREN_TOK Expression RPAREN_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_EXPR;
        p->pt_union.expr.tag = EXPR_PRED;
        p->pt_union.expr.expr_union.un_op.sub_expr = $3;
        $$ = p;
    }
    | SUCC_TOK LPAREN_TOK Expression RPAREN_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_EXPR;
        p->pt_union.expr.tag = EXPR_SUCC;
        p->pt_union.expr.expr_union.un_op.sub_expr = $3;
        $$ = p;
    }
    | LValue
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_EXPR;
        p->pt_union.expr.tag = EXPR_LVALUE;
        p->pt_union.expr.expr_union.lvalue = $1;
        $$ = p;
    }
    | INT_LITERAL_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        ParseTree *lit = malloc(sizeof(ParseTree));
        lit->pt_tag = PT_INT;
        lit->pt_union.int_literal.value = $1;
        p->pt_tag = PT_EXPR;
        p->pt_union.expr.expr_union.int_literal = lit;
        $$ = p;
    }
    | FLOAT_LITERAL_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        ParseTree *lit = malloc(sizeof(ParseTree));
        lit->pt_tag = PT_FLOAT;
        lit->pt_union.float_literal.value = $1;
        p->pt_tag = PT_EXPR;
        p->pt_union.expr.expr_union.float_literal = lit;
        $$ = p;
    }
    | CHAR_LITERAL_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        ParseTree *lit = malloc(sizeof(ParseTree));
        lit->pt_tag = PT_CHAR;
        lit->pt_union.char_literal.value = $1;
        p->pt_tag = PT_EXPR;
        p->pt_union.expr.expr_union.char_literal = lit;
        $$ = p;
    }
    | STRING_LITERAL_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        ParseTree *lit = malloc(sizeof(ParseTree));
        lit->pt_tag = PT_STR;
        lit->pt_union.str_literal.value = $1;
        p->pt_tag = PT_EXPR;
        p->pt_union.expr.expr_union.str_literal = lit;
        $$ = p;
    }
    | TRUE_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        ParseTree *lit = malloc(sizeof(ParseTree));
        lit->pt_tag = PT_BOOL;
        lit->pt_union.bool_literal.value = $1;
        p->pt_tag = PT_EXPR;
        p->pt_union.expr.expr_union.bool_literal = lit;
        $$ = p;
    }
    | FALSE_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        ParseTree *lit = malloc(sizeof(ParseTree));
        lit->pt_tag = PT_BOOL;
        lit->pt_union.bool_literal.value = $1;
        p->pt_tag = PT_EXPR;
        p->pt_union.expr.expr_union.bool_literal = lit;
        $$ = p;
    }

LValue:
    IDENTIFIER_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        ParseTree *ident = malloc(sizeof(ParseTree));
        ident->pt_tag = PT_IDENT;
        ident->pt_union.identifier.name = $1;
        p->pt_tag = PT_LVALUE;
        p->pt_union.lvalue.tag = LV_IDENT;
        p->pt_union.lvalue.lv_union.ident = ident;
        $$ = p;
    }
    | LValue MEMBER_TOK IDENTIFIER_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        ParseTree *ident = malloc(sizeof(ParseTree));
        ident->pt_tag = PT_IDENT;
        ident->pt_union.identifier.name = $3;
        p->pt_tag = PT_LVALUE;
        p->pt_union.lvalue.tag = LV_MEMBER;
        p->pt_union.lvalue.lv_union.member.ident = ident;
        p->pt_union.lvalue.lv_union.member.parent_lv = $1;
        $$ = p;
    }
    | LValue LBRACKET_TOK Expression RBRACKET_TOK
    {
        ParseTree *p = malloc(sizeof(ParseTree));
        p->pt_tag = PT_LVALUE;
        p->pt_union.lvalue.tag = LV_ARRAY;
        p->pt_union.lvalue.lv_union.array.index_expr = $3;
        p->pt_union.lvalue.lv_union.array.parent_lv = $1;
        $$ = p;
    }

%%

// C support functions

