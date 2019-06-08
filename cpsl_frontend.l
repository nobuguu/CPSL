
%{
#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>
#include "cpsl_parser.h"

extern FILE* outfile;

%}

%option never-interactive

%%

\$.*\n { /* consume comments */ }

array|ARRAY { return ARRAY_TOK; }
begin|BEGIN { return BEGIN_TOK; }
chr|CHR { return CHR_TOK; }
const|CONST { return CONST_TOK; }
do|DO { return DO_TOK; }
downto|DOWNTO { return DOWNTO_TOK; }
else|ELSE { return ELSE_TOK; }
elseif|ELSEIF { return ELSEIF_TOK; }
end|END { return END_TOK; }
for|FOR { return FOR_TOK; }
forward|FORWARD { return FORWARD_TOK; }
function|FUNCTION { return FUNCTION_TOK; }
if|IF { return IF_TOK; }
of|OF { return OF_TOK; }
ord|ORD { return ORD_TOK; }
pred|PRED { return PRED_TOK; }
procedure|PROCEDURE { return PROCEDURE_TOK; }
read|READ { return READ_TOK; }
record|RECORD { return RECORD_TOK; }
ref|REF { return REF_TOK; }
repeat|REPEAT { return REPEAT_TOK; }
return|RETURN { return RETURN_TOK; }
stop|STOP { return STOP_TOK; }
succ|SUCC { return SUCC_TOK; }
then|THEN { return THEN_TOK; }
to|TO { return TO_TOK; }
type|TYPE { return TYPE_TOK; }
until|UNTIL { return UNTIL_TOK; }
var|VAR { return VAR_TOK; }
while|WHILE { return WHILE_TOK; }
write|WRITE { return WRITE_TOK; }

integer|INTEGER { return INTEGER_TOK; }
char|CHAR { return CHAR_TOK; }
float|FLOAT { return FLOAT_TOK; }
boolean|BOOLEAN { return BOOLEAN_TOK; }
true|TRUE { yylval.bool_literal = true; return TRUE_TOK; }
false|FALSE { yylval.bool_literal = false; return FALSE_TOK; }

\. { return MEMBER_TOK; }
\( { return LPAREN_TOK; }
\) { return RPAREN_TOK; }
\+ { return ADD_TOK; }
\- { return SUB_TOK; }
\* { return MUL_TOK; }
\/ { return DIV_TOK; }
\% { return MOD_TOK; }
\& { return AND_TOK; }
\| { return OR_TOK; }
\~ { return NOT_TOK; }
\= { return EQUALS_TOK; }
\<\> { return NEQ_TOK; }
\< { return LT_TOK; }
\> { return GT_TOK; }
\<\= { return LE_TOK; }
\>\= { return GE_TOK; }
\:\= { return ASSIGN_TOK; }
\, { return COMMA_TOK; }
\: { return COLON_TOK; }
\; { return SEMICOLON_TOK; }
\[ { return LBRACKET_TOK; }
\] { return RBRACKET_TOK; }

[a-zA-Z][a-zA-Z0-9_]* { yylval.str_literal = strdup(yytext); return IDENTIFIER_TOK; }
0x[a-fA-F0-9]+ { yylval.int_literal = atoi(yytext); return INT_LITERAL_TOK; }
0[0-7]* { yylval.int_literal = atoi(yytext); return INT_LITERAL_TOK; }
[1-9][0-9]* { yylval.int_literal = atoi(yytext); return INT_LITERAL_TOK; }

[-+]?[0-9]*\.[0-9]+([eE][-+]?[0-9]+)? { yylval.float_literal = atof(yytext); return FLOAT_LITERAL_TOK; }

\'(\\.|[^"\\])\' { yylval.char_literal = yytext[1]; return CHAR_LITERAL_TOK; }
\"(\\.|[^"\\])*\" { yylval.str_literal = strdup(yytext); return STRING_LITERAL_TOK; }

[ \t]* { /* consume whitespace */ }
\n { /* consume newlines, until line counting mechanisms are implemented */ }

%%

// C support functions

int yyerror(const char *msg) {
    fprintf(stderr, "%s\n", msg);
}
