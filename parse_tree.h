
#include <stdbool.h>

#ifndef __PARSE_TREE_H
#define __PARSE_TREE_H

typedef struct Program {
    struct ConstDecl *c_decl;
    struct TypeDecl *t_decl;
    struct VarDecl *v_decl;
    struct SubroutineDecl *s_decl;
    struct Block *block;
} Program;

typedef struct ConstDecl {
    struct ConstDeclList *cdl_head;
    struct ConstDeclList *cdl_tail;
} ConstDecl;

typedef struct ConstDeclList {
    struct Identifier *ident;
    struct Expression *expr;
    struct ConstDeclList *next;
    struct ConstDeclList *prev;
} ConstDeclList;

typedef struct TypeDecl {
    struct TypeDeclList *tdl_head;
    struct TypeDeclList *tdl_tail;
} TypeDecl;

typedef struct TypeDeclList {
    struct Identifier *ident;
    struct Type *type;
    struct TypeDeclList *next;
    struct TypeDeclList *prev;
} TypeDeclList;

typedef enum TypeTag {
    TYPE_SIMPLE, TYPE_RECORD, TYPE_ARRAY
} TypeTag;

typedef struct Type {
    TypeTag tag;
    union {
        struct SimpleType *simple;
        struct RecordType *record;
        struct ArrayType *array;
    } type_union;
} Type;

typedef struct SimpleType {
    struct Identifier *ident;
} SimpleType;

typedef struct RecordType {
    struct RecordTypeList *rtl_head;
    struct RecordTypeList *rtl_tail;
} RecordType;

typedef struct RecordTypeList {
    struct IdentList *il_head;
    struct IdentList *il_tail;
    struct Type *type;
    struct RecordTypeList *next;
    struct RecordTypeList *prev;
} RecordTypeList;

typedef struct IdentList {
    struct Identifier *ident;
    struct IdentList *prev;
    struct IdentList *next;
} IdentList;

typedef struct ArrayType {
    struct Expression *begin_expr;
    struct Expression *end_expr;
    struct Type *type;
} ArrayType;

typedef struct VarDecl {
    struct VarDeclList *vdl_head;
    struct VarDeclList *vdl_tail;
} VarDecl;

typedef struct VarDeclList {
    struct IdentList *il_head;
    struct IdentList *il_tail;
    struct Type *type;
    struct VarDeclList *prev;
    struct VarDeclList *next;
} VarDeclList;

typedef enum SubroutineDeclListTag {
    SDL_PROC, SDL_FUNC
} SubroutineDeclListTag;

typedef struct SubroutineDecl {
    struct SubroutineDeclList *sdl_head;
    struct SubroutineDeclList *sdl_tail;
} SubroutineDecl;

typedef struct SubroutineDeclList {
    SubroutineDeclListTag tag;
    union {
        struct ProcedureDecl *p_decl;
        struct FunctionDecl *f_decl;
    } sdl_union;
    struct SubroutineDeclList *next;
    struct SubroutineDeclList *prev;
} SubroutineDeclList;

typedef struct ProcedureDecl {
    struct Identifier *ident;
    struct FormalParameterList *fpl_head;
    struct FormalParameterList *fpl_tail;
    struct Body *body;
} ProcedureDecl;

typedef struct FunctionDecl {
    struct Identifier *ident;
    struct FormalParameterList *fpl_head;
    struct FormalParameterList *fpl_tail;
    struct Type *return_type;
    struct Body *body;
} FunctionDecl;

typedef enum FormalParameterTag {
    FP_VAR, FP_REF
} FormalParameterTag;

typedef struct FormalParameterList {
    struct FormalParameter *param;
    struct FormalParameterList *next;
    struct FormalParameterList *prev;
} FormalParameterList;

typedef struct FormalParameter {
    FormalParameterTag tag;
    struct Type *type;
    struct IdentList *il_head;
    struct IdentList *il_tail;
} FormalParameter;

typedef struct Body {
    struct ConstDecl *c_decl;
    struct TypeDecl *t_decl;
    struct VarDecl *v_decl;
    struct Block *block;
} Body;

typedef struct Block {
    struct StatementList *sl_head;
    struct StatementList *sl_tail;
} Block;

typedef struct StatementList {
    struct Statement *stmt;
    struct StatementList *next;
    struct StatementList *prev;
} StatementList;

typedef enum StatementTag {
    STMT_ASSIGN, STMT_IF, STMT_WHILE, STMT_REPEAT, STMT_FOR, STMT_STOP, STMT_RETURN,
    STMT_READ, STMT_WRITE, STMT_PCALL, STMT_NULL
} StatementTag;

typedef struct Statement {
    StatementTag tag;
    union {
        struct AssignStatement *assign_stmt;
        struct IfStatement *if_stmt;
        struct WhileStatement *while_stmt;
        struct RepeatStatement *repeat_stmt;
        struct ForStatement *for_stmt;
        struct StopStatement *stop_stmt;
        struct ReturnStatement *return_stmt;
        struct ReadStatement *read_stmt;
        struct WriteStatement *write_stmt;
        struct PCallStatement *pcall_stmt;
        struct NullStatement *null_stmt;
    } stmt_union;
} Statement;

typedef struct AssignStatement {
    struct LValue *lvalue;
    struct Expression *expr;
} AssignStatement;

typedef struct IfStatement {
    struct Expression *if_cond;
    struct StatementList *if_sl_head;
    struct StatementList *if_sl_tail;
    struct ElseIfList *eil_head;
    struct ElseIfList *eil_tail;
    struct StatementList *else_sl_head;
    struct StatementList *else_sl_tail;
} IfStatement;

typedef struct ElseIfList {
    struct Expression *ei_cond;
    struct StatementList *ei_sl_head;
    struct StatementList *ei_sl_tail;
    struct ElseIfList *next;
    struct ElseIfList *prev;
} ElseIfList;

typedef struct WhileStatement {
    struct Expression *while_cond;
    struct StatementList *while_sl_head;
    struct StatementList *while_sl_tail;
} WhileStatement;

typedef struct RepeatStatement {
    struct Expression *repeat_cond;
    struct StatementList *repeat_sl_head;
    struct StatementList *repeat_sl_tail;
} RepeatStatement;

typedef enum ForStatementTag {
    FOR_UP, FOR_DOWN
} ForStatementTag;

typedef struct ForStatement {
    ForStatementTag tag;
    struct Identifier *loop_var;
    struct Expression *begin_expr;
    struct Expression *end_expr;
    struct StatementList *for_sl_head;
    struct StatementList *for_sl_tail;
} ForStatement;

typedef struct StopStatement {
    /* empty */
} StopStatement;

typedef struct ReturnStatement {
    struct Expression *return_val;
} ReturnStatement;

typedef struct ReadStatement {
    struct ReadList *rl_head;
    struct ReadList *rl_tail;
} ReadStatement;

typedef struct ReadList {
    struct LValue *lvalue;
    struct ReadList *next;
    struct ReadList *prev;
} ReadList;

typedef struct WriteStatement {
    struct WriteList *wl_head;
    struct WriteList *wl_tail;
} WriteStatement;

typedef struct WriteList {
    struct Expression *expr;
    struct WriteList *next;
    struct WriteList *prev;
} WriteList;

typedef struct PCallStatement {
    struct Identifier *ident;
    struct ArgumentList *al_head;
    struct ArgumentList *al_tail;
} PCallStatement;

typedef struct ArgumentList {
    struct Expression *expr;
    struct ArgumentList *next;
    struct ArgumentList *prev;
} ArgumentList;

typedef struct NullStatement {
    /* empty */
} NullStatement;

typedef enum ExpressionTag {
    EXPR_OR, EXPR_AND, EXPR_EQ, EXPR_NEQ, EXPR_LE, EXPR_GE, EXPR_LT, EXPR_GT,
    EXPR_ADD, EXPR_SUB, EXPR_MUL, EXPR_DIV, EXPR_MOD, EXPR_NOT, EXPR_UMINUS,
    EXPR_PAREN, EXPR_FCALL, EXPR_CHR, EXPR_ORD, EXPR_PRED, EXPR_SUCC,
    EXPR_LVALUE, EXPR_INT, EXPR_FLOAT, EXPR_CHAR, EXPR_STR, EXPR_BOOL
} ExpressionTag;

typedef struct Expression {
    ExpressionTag tag;
    union {
        struct {
            struct Expression *left;
            struct Expression *right;
        } bin_op;
        struct Expression *un_op;
        struct {
            Identifier *ident;
            ArgumentList *al_head;
            ArgumentList *al_tail;
        } fcall;
        struct LValue *lvalue;
        int int_literal;
        float float_literal;
        char char_literal;
        char *str_literal;
        bool bool_literal;
    } expr_union;
} Expression;

typedef enum LValueTag {
    LV_IDENT, LV_MEMBER, LV_ARRAY
} LValueTag;

typedef struct LValue {
    LValueTag tag;
    union {
        struct Identifier *ident;
        struct {
            struct Identifier *ident;
            struct LValue *parent_lv;
        } lv_member;
        struct {
            struct Expression *index_expr;
            struct LValue *parent_lv;
        } lv_array;
    } lv_union;
} LValue;

typedef struct Identifier {
    char *name;
} Identifier;

#endif
