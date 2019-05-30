
#include <stdlib.h>
#include <string.h>
#include "parse_tree.h"
#include "symbol_table.h"

#define N_PREDEF_SYMS 5

void init_table(void) {
}

void add_to_table(SymbolTableTag tag, void *ident, void *symbol) {
}

void push_table(void) {
}

void pop_table(void) {
}

void *lookup_by_ident(SymbolTableTag tag, void *ident) {
}

void *lookup_ident_by_name(SymbolTableTag tag, char *name) {
}
