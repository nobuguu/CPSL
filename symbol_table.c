
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
        add_type_to_table(ident, t);
    }
    push_table();
}

void add_const_to_table(Identifier *ident, Expression *c_decl) {
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

void add_var_to_table(Identifier *ident, Type *v_decl) {
    VarTable *v_table = malloc(sizeof(VarTable));
    v_table->ident = ident;
    v_table->v_decl = v_decl;
    v_table->next = global_symbol_context->sym_t->v_table;
    global_symbol_context->sym_t->v_table = v_table;
}

void add_sub_to_table(Identifier *ident, FormalParameterList *fpl_head,
        FormalParameterList *fpl_tail, Type *return_type, Body *body) {
    SubroutineTable *s_table = malloc(sizeof(SubroutineTable));
    s_table->ident = ident;
    s_table->fpl_head = fpl_head;
    s_table->fpl_tail = fpl_tail;
    s_table->return_type = return_type;
    s_table->body = body;
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

Identifier *lookup_ident_by_name(SymbolTableTag tag, char *name) {
    for (Context *c = global_symbol_context; c != NULL; c = c->next) {
        SymbolTable *s = c->sym_t;
        switch (tag) {
            case ST_CONST:
                for (ConstTable *c = s->c_table; c != NULL; c = c->next) {
                    if (strcmp(c->ident->name, name) == 0) {
                        return c->ident;
                    }
                }
                panic("get_ident_by_name() could not find constant in table");
            case ST_TYPE:
                for (TypeTable *t = s->t_table; t != NULL; t = t->next) {
                    if (strcmp(t->ident->name, name) == 0) {
                        return t->ident;
                    }
                }
                panic("get_ident_by_name() could not find type in table");
            case ST_VAR:
                for (VarTable *v = s->v_table; v != NULL; v = v->next) {
                    if (strcmp(v->ident->name, name) == 0) {
                        return v->ident;
                    }
                }
                panic("get_ident_by_name() could not find var in table");
            case ST_SUB:
                for (SubroutineTable *st = s->s_table; st != NULL; st = st->next) {
                    if (strcmp(st->ident->name, name) == 0) {
                        return st->ident;
                    }
                }
                panic("get_ident_by_name() could not find subroutine in table");
            default:
                panic("get_ident_by_name() invalid symbol table tag");
        }
    }
    panic("get_ident_by_name() ran out of contexts to search for a name");
}
