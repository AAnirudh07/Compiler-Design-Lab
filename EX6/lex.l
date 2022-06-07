%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    #include "y.tab.h"
    void yyerror(char *);
    int i=0;
%}
%%
[ \t]+ ;
"\n" {i+=1;}
[0-9]+ {return INTEGER;}
"if" { return IF; }
"else" { return ELSE; }
"while" { return WHILE; }
("int"|"float"|"char"|"double") {return DTYPE;}
[a-zA-Z][a-zA-Z0-9]* {return ID;}
";" {return EOS;}
("+="|"-="|"*="|"/="|"=") {return ASSN_OP;}
(">"|"<"|">="|"<="|"!="|"==") {return COMP_OP;}
[+-^*/(){},.] {return *yytext;}
. { char msg[100],temp[5];
	int c=yytext[0];
	if(c!=13){
		strcpy(msg,"Invalid Syntax: ");
		strcat(msg,yytext);
		yyerror(msg);
	}
  }
%%