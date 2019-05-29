
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
    typedef struct ParseTreeList {
        ParseTree *list_head;
        ParseTree *list_tail;
    } ParseTreeList;
}

%verbose

%union {
    ParseTree *pt_node;
    ParseTreeList pt_list;
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
        $$.list_head = NULL;
        $$.list_tail = NULL;
    }

ArrayType:
    ARRAY_TOK LBRACKET_TOK Expression COLON_TOK Expression RBRACKET_TOK OF_TOK Type
    {
        $$ = NULL;
    }

IdentList:
    IDENTIFIER_TOK
    {
        $$.list_head = NULL;
        $$.list_tail = NULL;
    }
    | IdentList COMMA_TOK IDENTIFIER_TOK
    {
        $$.list_head = NULL;
        $$.list_tail = NULL;
    }

VarDecl:
    VAR_TOK VarDeclList
    {
        $$ = NULL;
    }

VarDeclList:
    IdentList COLON_TOK Type SEMICOLON_TOK
    {
        $$.list_head = NULL;
        $$.list_tail = NULL;
    }
    | VarDeclList IdentList COLON_TOK Type SEMICOLON_TOK
    {
        $$.list_head = NULL;
        $$.list_tail = NULL;
    }

StatementList:
    Statement
    {
        $$.list_head = NULL;
        $$.list_tail = NULL;
    }
    | StatementList SEMICOLON_TOK Statement
    {
        $$.list_head = NULL;
        $$.list_tail = NULL;
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
    | IF_TOK Expression THEN_TOK StatementList ElseIfList ELSE_TOK StatementList END_TOK
    {
        $$ = NULL;
    }

ElseIfList:
    ELSEIF_TOK Expression THEN_TOK StatementList
    {
        $$.list_head = NULL;
        $$.list_tail = NULL;
    }
    | ElseIfList ELSEIF_TOK Expression THEN_TOK StatementList
    {
        $$.list_head = NULL;
        $$.list_tail = NULL;
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
        $$.list_head = NULL;
        $$.list_tail = NULL;
    }
    | ReadList COMMA_TOK LValue
    {
        $$.list_head = NULL;
        $$.list_tail = NULL;
    }

WriteStatement:
    WRITE_TOK LPAREN_TOK WriteList RPAREN_TOK
    {
        $$ = NULL;
    }

WriteList:
    Expression
    {
        $$.list_head = NULL;
        $$.list_tail = NULL;
    }
    | WriteList COMMA_TOK Expression
    {
        $$.list_head = NULL;
        $$.list_tail = NULL;
    }

ProcedureCall:
    IDENTIFIER_TOK LPAREN_TOK ArgumentList RPAREN_TOK
    {
        $$ = NULL;
    }

ArgumentList:
    %empty
    {
        $$.list_head = NULL;
        $$.list_tail = NULL;
    }
    | Expression
    {
        $$.list_head = NULL;
        $$.list_tail = NULL;
    }
    | ArgumentList COMMA_TOK Expression
    {
        $$.list_head = NULL;
        $$.list_tail = NULL;
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

