#include<stdio.h>
#include<stdlib.h>
#include<string.h>

int E(int index);
int Eprime(int index);
int T(int index);
int Tprime(int index);
int F(int index);


char input[100];
int flag = 0;

int E(int index) {
    printf("E\n");
    if (index >= strlen(input)) {flag = 1; return index;}
    index = T(index);
    index = Eprime(index);
    return index;
}

int Eprime(int index) {
    printf("Eprime\n");
    if (index >= strlen(input)) {flag = 1; return index;}
    if (input[index]=='+') {
        index++;
        index = T(index);
        index = Eprime(index);
    }
    return index;
    
}

int T(int index) {
    printf("T\n");
    if (index >= strlen(input)) {flag = 1; return index;}
    index = F(index);
    index = Tprime(index);
    return index;
}

int Tprime(int index) {
    printf("Tprime\n");
    if (index >= strlen(input)) {flag = 1; return index;}
    if (input[index]=='*') {
        index++;
        index = F(index);
        index = Tprime(index);
    }    
    return index;
}

int F(int index) {
    printf("F\n");
    if (index >= strlen(input)) {flag = 1; return index;}
    if (input[index]=='i' && input[index+1]=='d') {
        index+=2;
        return index;
    }
    if (input[index]=='(') {
        index++;
        index = E(index);
        if (input[index]==')') index++;
    }
    return index;
}

int main() {
    printf("Enter the input string: ");
    scanf("%s",input);
    E(0);
    if(flag==1) {
        printf("Success");
    }
    else {
        printf("Error");
    }
    return 0;
}