
#include <stdbool.h>

#ifndef __PARSE_TREE_H
#define __PARSE_TREE_H

typedef struct ParseTree ParseTree;

typedef enum ParseTreeTag {
    PT_PROGRAM,
    PT_C_DECL,
    PT_C_DECL_L,
    PT_S_DECL,
    PT_S_DECL_L,
    PT_F_DECL,
    PT_P_DECL,
    PT_FORMAL_PARAM_L,
    PT_FORMAL_PARAM,
    PT_BODY,
    PT_BLOCK,
    PT_T_DECL,
    PT_T_DECL_L,
    PT_TYPE,
    PT_SIMPLE_TYPE,
    PT_RECORD_TYPE,
    PT_ARRAY_TYPE,
    PT_RECORD_TYPE_L,
    PT_IDENT_L,
    PT_V_DECL,
    PT_V_DECL_L,
    PT_STATEMENT_L,
    PT_STATEMENT,
    PT_ASSIGN_STMT,
    PT_IF_STMT,
    PT_ELSEIF_L,
    PT_WHILE_STMT,
    PT_REPEAT_STMT,
    PT_FOR_STMT,
    PT_STOP_STMT,
    PT_RETURN_STMT,
    PT_READ_STMT,
    PT_READ_L,
    PT_WRITE_STMT,
    PT_WRITE_L,
    PT_PCALL_STMT,
    PT_ARG_L,
    PT_NULL_STMT,
    PT_EXPR,
    PT_LVALUE,
    PT_BOOL,
    PT_INT,
    PT_CHAR,
    PT_FLOAT,
    PT_STR,
    PT_IDENT
} ParseTreeTag;

typedef enum SubroutineDeclTag {
    SD_FUNCTION,
    SD_PROCEDURE
} SubroutineDeclTag;

typedef enum FormalParameterTag {
    FP_VAR,
    FP_REF
} FormalParameterTag;

typedef enum TypeTag {
    T_SIMPLE,
    T_RECORD,
    T_ARRAY
} TypeTag;

typedef enum SimpleTypeTag {
    SIMPLE_INT,
    SIMPLE_CHAR,
    SIMPLE_FLOAT,
    SIMPLE_BOOLEAN,
    SIMPLE_IDENT
} SimpleTypeTag;

typedef enum StatementTag {
    STMT_ASSIGN,
    STMT_IF,
    STMT_WHILE,
    STMT_REPEAT,
    STMT_FOR,
    STMT_STOP,
    STMT_RETURN,
    STMT_READ,
    STMT_WRITE,
    STMT_PCALL,
    STMT_NULL
} StatementTag;

typedef enum ForStatementTag {
    FOR_UP,
    FOR_DOWN
} ForStatementTag;

typedef enum ExpressionTag {
    EXPR_OR,
    EXPR_AND,
    EXPR_EQ,
    EXPR_NEQ,
    EXPR_LE,
    EXPR_GE,
    EXPR_LT,
    EXPR_GT,
    EXPR_ADD,
    EXPR_SUB,
    EXPR_MUL,
    EXPR_DIV,
    EXPR_MOD,
    EXPR_NOT,
    EXPR_UMINUS,
    EXPR_FUNC,
    EXPR_CHR,
    EXPR_ORD,
    EXPR_PRED,
    EXPR_SUCC,
    EXPR_LVALUE,
    EXPR_BOOL,
    EXPR_INT,
    EXPR_CHAR,
    EXPR_FLOAT,
    EXPR_STR
} ExpressionTag;

typedef enum LValueTag {
    LV_IDENT,
    LV_MEMBER,
    LV_ARRAY
} LValueTag;

struct ParseTree {
    ParseTreeTag pt_tag;
    union {
        struct {
            ParseTree *c_decl;
            ParseTree *t_decl;
            ParseTree *v_decl;
            ParseTree *s_decl;
            ParseTree *block;
        } program;
        struct {
            ParseTree *cdl_head;
            ParseTree *cdl_tail;
        } c_decl;
        struct {
            ParseTree *ident;
            ParseTree *expr;
            ParseTree *prev;
            ParseTree *next;
        } c_decl_l;
        struct {
            ParseTree *sdl_head;
            ParseTree *sdl_tail;
        } s_decl;
        struct {
            SubroutineDeclTag sd_tag;
            union {
                ParseTree *p_decl;
                ParseTree *f_decl;
            } sdl_union;
            ParseTree *prev;
            ParseTree *next;
        } s_decl_l;
        struct {
            ParseTree *ident;
            ParseTree *fpl_head;
            ParseTree *fpl_tail;
            ParseTree *return_t;
            ParseTree *body;
        } f_decl;
        struct {
            ParseTree *ident;
            ParseTree *fpl_head;
            ParseTree *fpl_tail;
            ParseTree *body;
        } p_decl;
        struct {
            ParseTree *param;
            ParseTree *next;
            ParseTree *prev;
        } formal_param_l;
        struct {
            FormalParameterTag fp_tag;
            ParseTree *il_head;
            ParseTree *il_tail;
            ParseTree *type;
        } formal_param;
        struct {
            ParseTree *c_decl;
            ParseTree *t_decl;
            ParseTree *v_decl;
            ParseTree *block;
        } body;
        struct {
            ParseTree *sl_head;
            ParseTree *sl_tail;
        } block;
        struct {
            ParseTree *tdl_head;
            ParseTree *tdl_tail;
        } t_decl;
        struct {
            ParseTree *ident;
            ParseTree *type;
            ParseTree *next;
            ParseTree *prev;
        } t_decl_l;
        struct {
            TypeTag tag;
            union {
                ParseTree *simple;
                ParseTree *record;
                ParseTree *array;
            } type_union;
        } type;
        struct {
            SimpleTypeTag tag;
            ParseTree *ident;
        } simple_type;
        struct {
            ParseTree *rtl_head;
            ParseTree *rtl_tail;
        } record_type;
        struct {
            ParseTree *begin_expr;
            ParseTree *end_expr;
            ParseTree *type;
        } array_type;
        struct {
            ParseTree *il_head;
            ParseTree *il_tail;
            ParseTree *type;
            ParseTree *next;
            ParseTree *prev;
        } record_type_l;
        struct {
            ParseTree *ident;
            ParseTree *next;
            ParseTree *prev;
        } ident_l;
        struct {
            ParseTree *vdl_head;
            ParseTree *vdl_tail;
        } v_decl;
        struct {
            ParseTree *il_head;
            ParseTree *il_tail;
            ParseTree *type;
            ParseTree *prev;
            ParseTree *next;
        } v_decl_l;
        struct {
            ParseTree *stmt;
            ParseTree *prev;
            ParseTree *next;
        } statement_l;
        struct {
            StatementTag tag;
            union {
                ParseTree *assign_stmt;
                ParseTree *if_stmt;
                ParseTree *while_stmt;
                ParseTree *repeat_stmt;
                ParseTree *for_stmt;
                ParseTree *stop_stmt;
                ParseTree *return_stmt;
                ParseTree *read_stmt;
                ParseTree *write_stmt;
                ParseTree *pcall_stmt;
                ParseTree *null_stmt;
            } stmt_union;
        } statement;
        struct {
            ParseTree *lvalue;
            ParseTree *expr;
        } assign_stmt;
        struct {
            ParseTree *if_cond;
            ParseTree *if_sl;
            ParseTree *eil_head;
            ParseTree *eil_tail;
            ParseTree *else_sl;
        } if_stmt;
        struct {
            ParseTree *ei_cond;
            ParseTree *ei_sl;
            ParseTree *prev;
            ParseTree *next;
        } elseif_l;
        struct {
            ParseTree *while_cond;
            ParseTree *while_sl_head;
            ParseTree *while_sl_tail;
        } while_stmt;
        struct {
            ParseTree *repeat_cond;
            ParseTree *repeat_sl_head;
            ParseTree *repeat_sl_tail;
        } repeat_stmt;
        struct {
            ForStatementTag tag;
            ParseTree *for_ident;
            ParseTree *start_expr;
            ParseTree *end_expr;
            ParseTree *for_sl_head;
            ParseTree *for_sl_tail;
        } for_stmt;
        struct {
            /* empty */
        } stop_stmt;
        struct {
            ParseTree *expr;
        } return_stmt;
        struct {
            ParseTree *rl_head;
            ParseTree *rl_tail;
        } read_stmt;
        struct {
            ParseTree *ident;
            ParseTree *next;
            ParseTree *prev;
        } read_l;
        struct {
            ParseTree *wl_head;
            ParseTree *wl_tail;
        } write_stmt;
        struct {
            ParseTree *expr;
            ParseTree *next;
            ParseTree *prev;
        } write_l;
        struct {
            ParseTree *ident;
            ParseTree *al_head;
            ParseTree *al_tail;
        } pcall_stmt;
        struct {
            ParseTree *expr;
            ParseTree *next;
            ParseTree *prev;
        } arg_l;
        struct {
            /* empty */
        } null_stmt;
        struct {
            ExpressionTag tag;
            union {
                struct {
                    ParseTree *left;
                    ParseTree *right;
                } bin_op;
                struct {
                    ParseTree *sub_expr;
                } un_op;
                ParseTree *lvalue;
                ParseTree *int_literal;
                ParseTree *float_literal;
                ParseTree *char_literal;
                ParseTree *str_literal;
            } expr_union;
        } expr;
        struct {
            LValueTag tag;
            union {
                ParseTree *ident;
                struct {
                    ParseTree *ident;
                    ParseTree *parent_lv;
                } member;
                struct {
                    ParseTree *index_expr;
                    ParseTree *parent_lv;
                } array;
            } lv_union;
        } lvalue;
        struct {
            bool value;
        } bool_literal;
        struct {
            int value;
        } int_literal;
        struct {
            float value;
        } float_literal;
        struct {
            char value;
        } char_literal;
        struct {
            char *value;
        } str_literal;
        struct {
            char *name;
        } identifier;
    } pt_union;
};

#endif
