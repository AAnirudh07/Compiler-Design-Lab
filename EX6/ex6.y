%{
    #include<stdio.h>
    #include<string.h>
    #include<stdlib.h>
    #include "y.tab.h"
    int yyerror(char *);
    int yylex(void);
    extern FILE* yyin;
    int i;
    int error = 0;
%}

%token INTEGER ID IF ELSE WHILE EOS ASSN_OP COMP_OP DTYPE

%%
S: 
B S
| AS S
| AS
| WHILE '(' E ')' '{' S '}'
| IF '(' E ')' S ELSE S
;

B: 
DTYPE B EOS
| B ',' B
| ID
;

AS: 
AS ASSN_OP E EOS
| ID
;

E:
E '+' E
| E '-' E
| E '*' E
| E '/' E
| E '^' E
| E ASSN_OP E
| E COMP_OP E
| INTEGER
| ID
;
%%

int yyerror(char *s) {
    fprintf(stderr,"Error: %s at line: %d\n",s,i);
    error = 1;
    return 0;
}

yywrap() {
    return 1;
}

int main(int argc, char* argv[]) {
    if(argc!=2) {
        fprintf(stderr,"File name not given");
        return 1;
    }
    yyin = fopen(argv[1],"rt");
    if(!yyin) {
        fprintf(stderr,"File doesn't exist");
        return 2;
    }
    yyparse();
    if(error) {
        printf("There is a syntactical error\n");
    }
    else {
        printf("There is no syntactical error\n");
    }
    return 0;
}