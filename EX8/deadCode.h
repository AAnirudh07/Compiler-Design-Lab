typedef struct deadCodeElim {
    char* var;
    int defLine[10];
    int defCnt;
    int use;
}deadCode;