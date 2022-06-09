%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    #include "y.tab.h"
    void yyerror(char *);
    int yylex(void);
    int tempcount = 1;
%}

%union {
    int intval;
    float floatval;
    char* str;
}


%token ID INTEGER
%type<str> ID 
%type<str> E
%left '+' '-' 
%left '/' '*'
%%
A: 
ID '=' E '\n' {
    printf("%s = %s\n",$1,$3);
} 
;

E: 
E '+' E {
    printf("%s%d = %s + %s\n","temp",tempcount,$1,$3);
    char temp[100];
    sprintf(temp,"temp%d",tempcount);
    $$ = strdup(temp);
    tempcount++;
}
| E '-' E {
    printf("%s%d = %s - %s\n","temp",tempcount,$1,$3);
    char temp[100];
    sprintf(temp,"temp%d",tempcount);
    $$ = strdup(temp);
    tempcount++;
}
| E '*' E {
    printf("%s%d = %s * %s\n","temp",tempcount,$1,$3);
    char temp[100];
    sprintf(temp,"temp%d",tempcount);
    $$ = strdup(temp);
    tempcount++;
}
| E '/' E {
    printf("%s%d = %s / %s\n","temp",tempcount,$1,$3);
    char temp[100];
    sprintf(temp,"temp%d",tempcount);
    $$ = strdup(temp);
    tempcount++;
}
| '-' E {
    printf("%s%d = - %s\n","temp",tempcount,$2);
    char temp[100];
    sprintf(temp,"temp%d",tempcount);
    $$ = strdup(temp);
    tempcount++;
}
| ID {
    $$ = strdup($1);
}
;
%%

void yyerror(char * s){
    fprintf(stderr,"Error: %s\n",s);
}

int yywrap() {
    return 1;
}

int main(){
    yyparse();
    return 0;
}


