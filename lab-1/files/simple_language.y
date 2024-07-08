%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex();

typedef struct {
    char *name;
    int value;
} symbol;

symbol sym_table[100];
int sym_count = 0;

int get_symbol_value(char *name) {
    for (int i = 0; i < sym_count; i++) {
        if (strcmp(sym_table[i].name, name) == 0) {
            return sym_table[i].value;
        }
    }
    return 0; // Return 0 if variable is not found
}

void set_symbol_value(char *name, int value) {
    for (int i = 0; i < sym_count; i++) {
        if (strcmp(sym_table[i].name, name) == 0) {
            sym_table[i].value = value;
            return;
        }
    }
    sym_table[sym_count].name = strdup(name);
    sym_table[sym_count].value = value;
    sym_count++;
}

%}

%union {
    int intval;
    char *strval;
}

%token <strval> ID
%token <intval> NUMBER
%type <intval> expression

%%

program:
    statement_list
    ;

statement_list:
    statement
    | statement_list statement
    ;

statement:
    assignment
    | expression
    ;

assignment:
    ID '=' expression
    {
        set_symbol_value($1, $3);
        printf("Asignación: %s = %d\n", $1, $3);
    }
    ;

expression:
    NUMBER
    {
        $$ = $1;
    }
    | ID
    {
        $$ = get_symbol_value($1);
    }
    | expression '+' expression
    {
        $$ = $1 + $3;
    }
    | expression '-' expression
    {
        $$ = $1 - $3;
    }
    | expression '*' expression
    {
        $$ = $1 * $3;
    }
    | expression '/' expression
    {
        if ($3 == 0) {
            yyerror("Error: División por cero");
            $$ = 0;
        } else {
            $$ = $1 / $3;
        }
    }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    printf("Ingrese expresiones o asignaciones:\n");
    yyparse();
    return 0;
}
