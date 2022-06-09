
%{
    #include<stdio.h>
    #include<string.h>
    #include<stdlib.h>
    #include "y.tab.h"
    #include "deadCode.h"
    int yylex(void);
    void yyerror(char *);
    char code[50][100];
    deadCode varTab[50];
    int varTabCnt = 0;
    int unUsed[50];
    int unUsedCnt = 0;
    int lineCnt = 0;
    extern FILE *yyin;
    int notUsed(int);
    void addVar(char *);
    void addUse(char *);
    char* constantFolding(char*,int,int);
    char* arIdandstrRed(char*,char*,int);
%}


%union {
    char* str;
    int num;
};

%token IF GOTO LABEL TEMP ID INTEGER RELOP ARITHOP
%type<str> IF GOTO LABEL TEMP ID RELOP ARITHOP
%type<str> VAR ARITHEXP
%type<num> INTEGER

%%
S:
Line S
| Line
;

Line:
LABEL ':' ' ' VAR '=' INTEGER '\n' {
    printf("%s: %s = %s\n",$1,$4,$6);
    addVar($4);
    sprintf(code[lineCnt],"%s: %s %s \n",$1,$4,$6);
    lineCnt++;
}
| VAR '=' INTEGER '\n' {
    printf("%s = %d\n",$1,$3);
    addVar($1);
    sprintf(code[lineCnt],"%s = %d",$1,$3);
    lineCnt++;
}
| LABEL ':' ' ' VAR '=' TEMP '\n' {
    printf("%s: %s = %s\n",$1,$4,$6);
    addVar($4);
    addUse($6);
    sprintf(code[lineCnt],"%s: %s = %s",$1,$4,$6);
    lineCnt++;
}
| VAR '=' TEMP '\n' {
    printf("%s = %s\n",$1,$3);
    addVar($1);
    addUse($3);
    sprintf(code[lineCnt],"%s = %s",$1,$3);
    lineCnt++;
}
| LABEL ':' ' ' VAR '=' ARITHEXP '\n' {
    printf("%s: %s = %s\n",$1,$4,$6);
    addVar($4);
    sprintf(code[lineCnt],"%s: %s = %s\n",$1,$4,$6);
    lineCnt++;
}
| VAR '=' ARITHEXP '\n' {
    printf("%s = %s\n",$1,$3);
    addVar($1);
    sprintf(code[lineCnt],"%s: %s = %s\n",$1,$3);
    lineCnt++;
} 
| IF ' ' VAR RELOP INTEGER ' ' GOTO ' ' LABEL '\n' {
    printf("%s %s %s %s %s %s\n",$1,$3,$4,$5,$7,$9);
    addUse($3);
    sprintf(code[lineCnt],"%s %s %s %s %s %s\n",$1,$3,$4,$5,$7,$9);
    lineCnt++;
}
| IF ' ' VAR RELOP VAR ' ' GOTO ' ' LABEL '\n' {
    printf("%s %s %s %s %s %s\n",$1,$3,$4,$5,$7,$9);
    addUse($3);
    addUse($5);
    sprintf(code[lineCnt],"$s $s $s $s %s $s\n",$1,$3,$4,$5,$7,$9);
    lineCnt++;
}
| GOTO ' ' LABEL '\n' {
    printf("%s %s\n",$1,$3);
    sprintf(code[lineCnt],"%s %s",$1,$3);
    lineCnt++;
}
;

ARITHEXP:
VAR ARITHOP VAR {
    printf("%s %s %s\n",$1,$2,$3);
    addUse($1);
    addUse($3);
    char* code = (char *)malloc(sizeof(char)*128);
    sprintf(code,"%s %s %s\n",$1,$2,$3);
    $$ = strdup(code);
}
| INTEGER ARITHOP INTEGER {
    constantFolding($2,$1,$3);
}
| VAR ARITHOP INTEGER {
    addUse($1);
    $$ = strdup(arIdandstrRed($2,$1,$3));
}
;

VAR:
ID {$$=strdup($1);}
| TEMP {$$=strdup($1);}
;
%%

void addVar(char* var) {
    for(int i=0;i<varTabCnt;i++) {
        if(strcmp(varTab[i].var,var)==0) {
            varTab[i].defLine[varTab[i].defCnt] = lineCnt;
            varTab[i].defCnt++;
            return;
        }
    }
    varTab[varTabCnt].var = strdup(var);
    varTab[varTabCnt].use = 0;
    varTab[varTabCnt].defLine[0] = lineCnt;
    varTab[varTabCnt].defCnt = 1;
    varTabCnt++;
}

void addUse(char* var) {
    for(int i=0;i<varTabCnt;i++) {
        if(strcmp(varTab[i].var,var)==0) {
            varTab[i].use++;
            return;
        }
    }
}

char* constantFolding(char* op,int n1,int n2) {
    char* code = (char *)malloc(sizeof(char)*128);
    if(strcmp(op,"+")==0) {
        sprintf(code,"%d",n1+n2);
    }

    if(strcmp(op,"-")==0) {
        sprintf(code,"%d",n1-n2);
    }

    if(strcmp(op,"*")==0) {
        sprintf(code,"%d",n1*n2);
    }

    if(strcmp(op,"/")==0) {
        sprintf(code,"%d",n1/n2);
    }
}

char* arIdandstrRed(char* op,char* var,int num) {
    char* code = (char*)malloc(sizeof(char)*128);
    if(strcmp(op,"+")==0 && num==0) {
        sprintf(code,"%s",var);
    }
    else if(strcmp(op,"*")==0 && num==1) {
        sprintf(code,"%s",var);
    }
    if(strcmp(op,"**")==0 && num==2) {
        sprintf(code,"%s * %s",var,var);
    }
    if(strcmp(op,"*")==0 && num==2) {
        sprintf(code,"%s << 1",var);
    }
    else {
        sprintf(code,"%s %s %s",var,op,num);
    }

    return code;
}

int notUsed(int index) {
    for(int i=0;i<unUsedCnt;i++) {
        if(unUsed[i]==index) return 1;
    }
    return 0;
}

void yyerror(char* s) {
    fprintf(stderr,"Error: %s\n",s);
}

int yywrap() {
    return 1;
}

int main(int argc,char* argv[]) {
    yyin = fopen(argv[1],"r");
    yyparse();
    printf("After Parse:\n");
    for(int i=0;i<varTabCnt;i++) {
        if(varTab[i].use==0) {
            for(int j=0;j<varTab[i].defCnt;i++) {
                unUsed[unUsedCnt] = varTab[i].defLine[j];
                unUsedCnt++;
            }
        }
    }

    for(int i=0;i<lineCnt;i++) {
        printf("%s\n",code[i]);
    }
    return 0;
}