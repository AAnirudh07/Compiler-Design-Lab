%{ 
    #include<stdio.h>
    #include<string.h>
    #include<stdio.h>
    #include "y.tab.h"
    void yyerror(char *);
    extern YYSTYPE yylval;
%}

%%
if {yylval.str = strdup(yytext);return IF;}
goto {yylval.str = strdup(yytext);return GOTO;}
"+"|"-"|"/"|"*"|"**" {yylval.str = strdup(yytext);return ARITHOP;}
">"|"<"|">="|"<="|"=="|"!=" {yylval.str = strdup(yytext);return RELOP;}
L[0-9] {yylval.str = strdup(yytext);return LABEL;}
t[0-9] {yylval.str = strdup(yytext);return TEMP;}
[a-zA-Z][a-zA-Z]* {yylval.str = strdup(yytext);return ID;}
[0-9]+ {yylval.num = atoi(yytext); return INTEGER;}
":" {return *yytext;}
"\n" {return *yytext;}
"=" {return *yytext;}
(\ ) {return *yytext;}
%%