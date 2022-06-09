%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    #include "y.tab.h"
    void yyerror(char *);
    extern YYSTYPE yylval;
%}

%%
"\n" {return *yytext;}
[ \t]+ {}
[0-9]+ {return INTEGER;}
("or"|"and"|"not") {return *yytext;}
(">"|"<"|">="|"<="|"!="|"==") {yylval.str = strdup(yytext); return RELOP;}
[a-zA-Z][a-zA-Z0-9]* {yylval.str = strdup(yytext); return ID;}
"=" {return *yytext;}
. {
    char message[50];
    sprintf(message,"There is an error: %s",yytext);
    yyerror(message);
}
%%