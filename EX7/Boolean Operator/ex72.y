%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    #include "y.tab.h"
    void yyerror(char *);
    int yylex(void);
    int tempcount = 1;
    int startline = 100;
%}

%union {
    char* str;
}

%token INTEGER ID RELOP
%type<str> ID RELOP
%type<str> C
%nonassoc RELOP

%%
B:
ID '=' C '\n'{
    printf("%d: %s = %s\n",startline,$1,$3);
}
;

C:
C 'or' C {
    printf("%d: %s%d = %s or %s \n",startline,"temp",tempcount,$1,$3);
    startline = startline+1;
    char temp[100];
    sprintf(temp,"temp%d",tempcount);
    $$ = strdup(temp);
    tempcount++;
}
| C 'and' C {
    printf("%d: %s%d = %s and %s \n",startline,"temp",tempcount,$1,$3);
    startline = startline + 1;
    char temp[100];
    sprintf(temp,"temp%d",tempcount);
    $$ = strdup(temp);
    tempcount++;
}
| 'not' C {
    printf("%d: %s%d = not %s \n",startline,"temp",tempcount,$2);
    char temp[100];
    sprintf(temp,"temp%d",tempcount);
    $$ = strdup(temp);
    tempcount++;
}
| ID RELOP ID {
    printf("%d: IF %s %s %s, GOTO %d\n",startline,$1,$2,$3,startline+3);
    startline = startline + 1;
    printf("%d: %s%d = 0\n",startline,"temp",tempcount);
    startline = startline + 1;
    printf("%d: GOTO %d\n",startline,startline+2);
    startline = startline + 1;
    printf("%d: %s%d = 1\n",startline,"temp",tempcount);
    startline = startline + 1;
    char temp[100];
    sprintf(temp,"temp%d",tempcount);
    $$ = strdup(temp);
    tempcount++;
}
;
%%
void yyerror(char* s){
    fprintf(stderr,"Error: %s\n",s);
}

int yywrap(){
    return 1;
}

int main(){
    yyparse();
    return 0;
}

