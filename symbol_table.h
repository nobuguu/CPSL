
#include <stdlib.h>
#include <stdbool.h>
#include "parse_tree.h"

#ifndef __SYMBOL_TABLE_H
#define __SYMBOL_TABLE_H

typedef enum SymbolTableTag {
    ST_CONST,
    ST_TYPE,
    ST_VAR,
    ST_SUB,
    ST_STR
} SymbolTableTag;

typedef struct SymbolTable {
    SymbolTableTag tag;
    ParseTree *ident;
    ParseTree *symbol;
    struct SymbolTable *next;
} SymbolTable;

typedef struct Context {
    SymbolTable *sym_t;
    struct Context *next;
} Context;

Context *global_symbol_context;

void init_table(void);
void add_to_table(SymbolTableTag, ParseTree*, ParseTree*);
void push_table(void);
void pop_table(void);
ParseTree *lookup_by_ident(SymbolTableTag, ParseTree*);

#endif
