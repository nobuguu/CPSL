
#include <stdlib.h>
#include <string.h>
#include "parse_tree.h"
#include "symbol_table.h"

#define N_PREDEF_SYMS 5

void init_table(void) {
    global_symbol_context = malloc(sizeof(Context));
    global_symbol_context->sym_t = NULL;
    global_symbol_context->next = NULL;
    ParseTree *predef_symbols[N_PREDEF_SYMS];
    ParseTree *predef_idents[N_PREDEF_SYMS];
    //integer, float, char, boolean, string, true, false
    for (int i=0; i<N_PREDEF_SYMS; ++i) {
        predef_symbols[i] = malloc(sizeof(ParseTree));
        predef_idents[i] = malloc(sizeof(ParseTree));
        predef_idents[i]->pt_tag = PT_IDENT;
    }

    predef_idents[0]->pt_union.identifier.name = strdup("integer");
    predef_idents[1]->pt_union.identifier.name = strdup("float");
    predef_idents[2]->pt_union.identifier.name = strdup("char");
    predef_idents[3]->pt_union.identifier.name = strdup("boolean");
    predef_idents[4]->pt_union.identifier.name = strdup("string");

    for (int i=0; i<N_PREDEF_SYMS; ++i) {
        predef_symbols[i]->pt_tag = PT_TYPE;
        predef_symbols[i]->pt_union.type.tag = T_SIMPLE;
        predef_symbols[i]->pt_union.type.type_union.simple
            = malloc(sizeof(ParseTree));
        predef_symbols[i]->pt_union.type.type_union.simple
            ->pt_union.simple_type.ident = predef_idents[i];
        add_to_table(ST_TYPE, predef_idents[i], predef_symbols[i]);
    }
}

void add_to_table(SymbolTableTag tag, ParseTree *ident, ParseTree *symbol) {
    SymbolTable *to_add = malloc(sizeof(SymbolTable));
    to_add->tag = tag;
    to_add->ident = ident;
    to_add->symbol = symbol;
    to_add->next = global_symbol_context->sym_t;
    global_symbol_context->sym_t = to_add;
}

void push_table(void) {
    Context *c = malloc(sizeof(Context));
    c->next = global_symbol_context;
    c->sym_t = NULL;
    global_symbol_context = c;
}

void pop_table(void) {
    Context *c = global_symbol_context;
    global_symbol_context = global_symbol_context->next;
    free(c);
}

ParseTree *lookup_by_ident(SymbolTableTag tag, ParseTree *ident) {
    Context *c = global_symbol_context;
    while (c != NULL) {
        SymbolTable *st = c->sym_t;
        while (st != NULL) {
            if (st->tag == tag && st->ident == ident) {
                return st->symbol;
            }
            st = st->next;
        }
        c = c->next;
    }
    return NULL;
}

ParseTree *lookup_ident_by_name(SymbolTableTag tag, char *name) {
    Context *c = global_symbol_context;
    while (c != NULL) {
        SymbolTable *st = c->sym_t;
        while (st != NULL) {
            if (st->tag == tag
                    && strcmp(st->ident->pt_union.identifier.name, name) == 0) {
                return st->ident;
            }
            st = st->next;
        }
        c = c->next;
    }
    return NULL;
}
