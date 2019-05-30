
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
} ConstTable;
typedef struct TypeTable {
} TypeTable;
typedef struct VarTable {
} VarTable;
typedef struct SubroutineTable {
} SubroutineTable;

typedef struct Context {
    SymbolTable *sym_t;
    struct Context *next;
} Context;

Context *global_symbol_context;

void init_table(void);
void add_to_table(SymbolTableTag, void*, void*);
void push_table(void);
void pop_table(void);
void *lookup_by_ident(SymbolTableTag, void*);
void *lookup_ident_by_name(SymbolTableTag, char*);

#endif
