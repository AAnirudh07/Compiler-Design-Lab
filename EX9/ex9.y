%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    #include "y.tab.h"
    #include "registers.h"
    void yyerror(char *);
    int yylex(void);
    char* hasRegister(char *);
    char* checkAOP1(char*,char*,char*);
    char* checkAOP2(char*,char*,char*);
    registers reg[20];
    int registerCount = 0;
%}

%token IF GOTO ARITHOP RELOP LABEL TEMP ID INTEGER

%union {
    char* str;
};

%type<str> IF GOTO ARITHOP RELOP LABEL TEMP ID INTEGER
%type<str> VAR ARITHEXP

%%
S:
S Line
| Line
;

Line:
LABEL ':' ' ' VAR '=' INTEGER '\n' {
    char* newReg = hasRegister($4);
    if (newReg == NULL) {
        char* newReg = (char *)malloc(sizeof(char)*128);
        sprintf(newReg,"R%d",registerCount);
        reg[registerCount].var = strdup($4);
        reg[registerCount].registerName = strdup(newReg);
        registerCount++;
    }
    printf("MOV %s,#%s",newReg,$6);
}
| VAR '=' INTEGER '\n' {
    char* newReg = hasRegister($1);
    if (newReg == NULL) {
        char* newReg = (char *)malloc(sizeof(char)*128);
        sprintf(newReg,"R%d",registerCount);
        reg[registerCount].var = strdup($1);
        reg[registerCount].registerName = strdup(newReg);
        registerCount++;
    }
    printf("%s,#%s\n",newReg,$3);
}
| LABEL ':' ' ' VAR '=' ARITHEXP '\n' {
    printf("%s: %s\n",$1,$6);
}
| VAR '='ARITHEXP {
    printf("%s\n",$3);
}
;

ARITHEXP:
VAR ARITHOP VAR {
    $$ = strdup(checkAOP1($2,$1,$3));
}
| VAR ARITHOP INTEGER {
    $$ = strdup(checkAOP2($2,$1,$3));
}
;

VAR:
ID {$$=strdup($1);}
| TEMP {$$=strdup($1);}
;
%%

char* hasRegister(char* var) {
    for(int i=0;i<registerCount;i++) {
        if(strcmp(var,reg[i].var)==0) {
            return (char *)reg[i].registerName;
        }
    }
    return NULL;
}

char* checkAOP1(char* op,char* var1, char* var2) {
    char* code = (char *)malloc(sizeof(char)*128);
    if(strcmp(op,"+")==0) {
        sprintf(code,"ADD %s, %s",hasRegister(var1),hasRegister(var2));
    }
    if(strcmp(op,"-")==0) {
        sprintf(code,"SUB %s, %s",hasRegister(var1),hasRegister(var2));
    }
    if(strcmp(op,"*")==0) {
        sprintf(code,"MUL %s, %s",hasRegister(var1),hasRegister(var2));
    }
    if(strcmp(op,"/")==0) {
        sprintf(code,"DIV %s, %s",hasRegister(var1),hasRegister(var2));
    }
    return code;
}

char* checkAOP2(char* op,char* var1, char* num) {
    char* newReg = (char *)malloc(sizeof(char)*128);
    sprintf(newReg,"R%d",registerCount);
    registerCount++;
    printf("MOV %s, #%s\n",newReg,num);

    char* code = (char *)malloc(sizeof(char)*128);
    if(strcmp(op,"+")==0) {
        sprintf(code,"ADD %s, %s",newReg,hasRegister(var1));
    }
    if(strcmp(op,"-")==0) {
        sprintf(code,"SUB %s, %s",newReg,hasRegister(var1));
    }
    if(strcmp(op,"*")==0) {
        sprintf(code,"MUL %s, %s",newReg,hasRegister(var1));
    }
    if(strcmp(op,"/")==0) {
        sprintf(code,"DIV %s, %s",newReg,hasRegister(var1));
    }
    return code;
    
}

void yyerror(char * s) {
    fprintf(stderr,"%s\n",s);
}

int yywrap() {
    return 1;
}

int main() {
    yyparse();
    return 0;
}