%{
    #include<stdio.h>
    #include<stdlib.h>
    #include "y.tab.h"
    void yyerror(char *);
    extern int yylval;
%}
digit [0-9]
num [0-9]+
arithmetic "+"|"-"|"/"|"*"
special "("|")"
%%
{num} {yylval=atoi(yytext);return INTEGER;}
{arithmetic} {return *yytext;}
{special} {return *yytext;}
"\n" {return *yytext;}
. {
    char message[25];
    sprintf(message,"<%s>%s","Unidentified char",yytext);
    yyerror(message);
}
%%