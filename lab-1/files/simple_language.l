%{
#include "y.tab.h"
%}

%%

[a-zA-Z][a-zA-Z0-9]*   { yylval.strval = strdup(yytext); return ID; }
[0-9]+                 { yylval.intval = atoi(yytext); return NUMBER; }
"="                    { return '='; }
"+"                    { return '+'; }
"-"                    { return '-'; }
"*"                    { return '*'; }
"/"                    { return '/'; }
"("                    { return '('; }
")"                    { return ')'; }
[ \t]                  { /* ignorar espacios en blanco */ }
\n                     { return '\n'; }
.                      { printf("Caracter no reconocido: %s (Código ASCII: %d)\n", yytext, yytext[0]); }

%%

int yywrap() {
    return 1;
}
