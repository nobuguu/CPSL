
#include <stdio.h>
#include <stdlib.h>
#include "parse_tree.h"
#include "symbol_table.h"
#include "build/cpsl_parser.h"
#include "register_pool.h"

extern int yyparse(void);
extern int yylex(void);
extern Program *pt_root;
extern RegisterPool global_register_pool;
FILE* outfile;

#ifdef YYDEBUG
    int yydebug = 1;
#endif

int main(void) {
    init_table();
    init_register_pool();
    yyparse();
    return 0;
}
