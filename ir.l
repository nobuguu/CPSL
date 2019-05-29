
%{
#include <stdlib.h>
#include <stdio.h>

int LINE_NUMBER = 0;
%}

%option never-interactive

%%

\$.*\n { /* consume comments */ }

add                     { return ADD_TOK;       }
sub                     { return SUB_TOK;       }
mult                    { return MULT_TOK;      }
div                     { return DIV_TOK;       }
mod                     { return MOD_TOK;       }
and                     { return AND_TOK;       }
or                      { return OR_TOK;        }
not                     { return NOT_TOK;       }
lt                      { return LT_TOK;        }
gt                      { return GT_TOK;        }
le                      { return LE_TOK;        }
ge                      { return GE_TOK;        }
move                    { return MOVE_TOK;      }
load                    { return LOAD_TOK;      }
store                   { return STORE_TOK;     }
call                    { return CALL_TOK;      }
branch                  { return BRANCH_TOK;    }
jump                    { return JUMP_TOK;      }

\,                      { return '\'';          }

[a-zA-Z_][a-zA-Z0-9_]   { return IDENT_TOK;     }

[ \t]*                  { /* consume whitespace */ }
\n                      { ++LINE_NUMBER;        }

%%

void hello(void) {
    printf("hello\n");
}
