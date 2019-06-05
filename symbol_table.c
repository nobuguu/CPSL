
#include <stdlib.h>
#include <string.h>
#include "error.h"
#include "parse_tree.h"
#include "symbol_table.h"

#define N_PREDEF_SYMS 5

void init_table(void) {
    /* create predefined context */
    global_symbol_context = malloc(sizeof(Context));
    global_symbol_context->sym_t = malloc(sizeof(SymbolTable));
    global_symbol_context->next = NULL;
    global_symbol_context->sym_t->c_table = NULL;
    global_symbol_context->sym_t->t_table = NULL;
    global_symbol_context->sym_t->v_table = NULL;
    global_symbol_context->sym_t->s_table = NULL;
    /* stuff crap in it */
    char *names[N_PREDEF_SYMS] = {
        "integer", "char", "float", "boolean", "string"
    };
    for (int i=0; i<N_PREDEF_SYMS; ++i) {
        Identifier *ident = malloc(sizeof(Identifier));
        ident->name = strdup(names[i]);
        SimpleType *simple = malloc(sizeof(SimpleType));
        simple->ident = ident;
        Type *t = malloc(sizeof(Type));
        t->tag = TYPE_SIMPLE;
        t->type_union.simple = simple;
        add_to_table(ST_TYPE, ident, t);
    }
}

void add_to_table(SymbolTableTag tag, Identifier *ident, void *symbol) {
    switch (tag) {
        case ST_CONST:
            add_const_to_table( ident, (ConstDecl*) symbol);
            break;
        case ST_TYPE:
            add_type_to_table( ident, (Type*) symbol);
            break;
        case ST_VAR:
            add_var_to_table( ident, (VarDecl*) symbol);
            break;
        case ST_SUB:
            add_sub_to_table( ident, (SubroutineDecl*) symbol);
            break;
        default:
            panic("add_to_table(): invalid enum");
    }
}

void add_const_to_table(Identifier *ident, ConstDecl *c_decl) {
    ConstTable *c_table = malloc(sizeof(ConstTable));
    c_table->ident = ident;
    c_table->c_decl = c_decl;
    c_table->next = global_symbol_context->sym_t->c_table;
    global_symbol_context->sym_t->c_table = c_table;
}

void add_type_to_table(Identifier *ident, Type *type) {
    TypeTable *t_table = malloc(sizeof(TypeTable));
    t_table->ident = ident;
    t_table->type = type;
    t_table->next = global_symbol_context->sym_t->t_table;
    global_symbol_context->sym_t->t_table = t_table;
}

void add_var_to_table(Identifier *ident, VarDecl *v_decl) {
    VarTable *v_table = malloc(sizeof(VarTable));
    v_table->ident = ident;
    v_table->v_decl = v_decl;
    v_table->next = global_symbol_context->sym_t->v_table;
    global_symbol_context->sym_t->v_table = v_table;
}

void add_sub_to_table(Identifier *ident, SubroutineDecl *s_decl) {
    SubroutineTable *s_table = malloc(sizeof(SubroutineTable));
    s_table->ident = ident;
    s_table->s_decl = s_decl;
    s_table->next = global_symbol_context->sym_t->s_table;
    global_symbol_context->sym_t->s_table = s_table;
}

void push_table(void) {
    Context *c = malloc(sizeof(Context));
    c->sym_t = malloc(sizeof(SymbolTable));
    c->sym_t->c_table = NULL;
    c->sym_t->t_table = NULL;
    c->sym_t->v_table = NULL;
    c->sym_t->s_table = NULL;
    c->next = global_symbol_context;
    global_symbol_context = c;
}

void pop_table(void) {
    Context *c = global_symbol_context->next;
    free(global_symbol_context);
    global_symbol_context = c;
}

void *lookup_by_ident(SymbolTableTag tag, void *ident) {
}

void *lookup_ident_by_name(SymbolTableTag tag, char *name) {
}
