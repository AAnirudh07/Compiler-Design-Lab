%option noyywrap
%{
    #include<stdio.h>
    #include<stdlib.h>
%}
digit [0-9]
letter [a-zA-Z]
num {digit}+(\.{digit}+)?
id {letter}([{letter}|{digit}])*
keyword "int"|"if"|"else"
function "scanf".*;|"printf".*;|"main".*
assignment "="
arithmetic "+"|"-"|"/"|"*"|"%"
arithassign "+="|"-="|"/="|"*="|"%="
relational ">"|"<"|"=="|">="|"<="|"!="
logical "&&"|"!"|"||" 
unary "++"|"--"
spl "("|")"|"{"|"}"|"["|"]"|"."|","|";"
%%
"#include<".*">" {printf("Pre-processor directive: %s\n",yytext);}
{num} {printf("Digit: %s\n",yytext);}
{id} {printf("Identifier: %s\n",yytext);}
{keyword} {printf("Keyword: %s\n",yytext);}
{function} {printf("Function: %s\n",yytext);}
{arithmetic} {printf("Arithmetic operator: %s\n",yytext);}
{arithassign} {printf("Arithmetic Assignment: %s\n",yytext);}
{relational} {printf("Relational operator: %s\n",yytext);}
{logical} {printf("Logical operator: %s\n",yytext);}
{unary} {printf("Unary Operator: %s\n",yytext);}
{assignment} {printf("Assignment Operator: %s\n",yytext);}
{spl} {printf("Special Char: %s\n",yytext);}
"//".* {printf("Single Line Comment: %s\n",yytext);}
"/*"(.|"\n")*"*/" {printf("Multi Line Comment: %s\n",yytext);}
[."\n"] {}
%%
main(int argc, char* argv[]){
    yyin = fopen(argv[1], "r");
    yylex();
    fclose(yyin);
}