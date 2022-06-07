%{
    #include<stdio.h>
    #include<stdlib.h>
    int yylex(void);
    #include "y.tab.h"
%}


%token INTEGER

%%
program: 
line program
| line

line:
expr '\n' { printf("%d\n",$1); }

expr:
expr '+' term { $$ = $1 + $3; }
| expr '-' term { $$ = $1 - $3; }
| term { $$ = $1; }

term:
term '*' factor { $$ = $1 * $3; }
| term '/' factor { $$ = $1 / $3; }
| factor { $$ = $1; }

factor:
'(' expr ')' { $$ = $2; }
| INTEGER { $$ = $1; }

%%

void yyerror(char * s) {
    fprintf(stderr,"%s\n",s);
}

yywrap() {
    return 1;
}

int main(void) {
    yyparse();
    return 0;
}
