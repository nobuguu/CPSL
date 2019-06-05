
#include <stdlib.h>
#include <stdbool.h>
#include "parse_tree.h"

#ifndef __SYMBOL_TABLE_H
#define __SYMBOL_TABLE_H

typedef enum SymbolTableTag {
    ST_CONST, ST_TYPE, ST_VAR, ST_SUB
} SymbolTableTag;

typedef struct SymbolTable {
    struct ConstTable *c_table;
    struct TypeTable *t_table;
    struct VarTable *v_table;
    struct SubroutineTable *s_table;
} SymbolTable;

typedef struct ConstTable {
    Identifier *ident;
    Expression *c_decl;
    struct ConstTable *next;
} ConstTable;

typedef struct TypeTable {
    Identifier *ident;
    Type *type;
    struct TypeTable *next;
} TypeTable;

typedef struct VarTable {
    Identifier *ident;
    Type *v_decl;
    struct VarTable *next;
} VarTable;

typedef struct SubroutineTable {
    Identifier *ident;
    SubroutineDecl *s_decl;
    struct SubroutineTable *next;
} SubroutineTable;

typedef struct Context {
    SymbolTable *sym_t;
    struct Context *next;
} Context;

Context *global_symbol_context;

void init_table(void);
void add_to_table(SymbolTableTag, Identifier*, void*);
void add_const_to_table(Identifier*, Expression*);
void add_type_to_table(Identifier*, Type*);
void add_var_to_table(Identifier*, Type*);
void add_sub_to_table(Identifier*, SubroutineDecl*);
void push_table(void);
void pop_table(void);
void *lookup_by_ident(SymbolTableTag, void*);
void *lookup_ident_by_name(SymbolTableTag, char*);

#endif
