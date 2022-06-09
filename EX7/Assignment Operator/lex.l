%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    #include "y.tab.h"
    void yyerror(char *);
    extern YYSTYPE yylval;
%}

%%
[ \t]+ ;
[a-zA-Z][a-zA-Z]* {yylval.str=strdup(yytext);return ID;}
"+"|"-"|"*"|"/"|"=" {return *yytext;}
"\n" {return *yytext;}
. {
    char message[25];
    sprintf(message,"There is an error %s",yytext);
    yyerror(message);
}
%%