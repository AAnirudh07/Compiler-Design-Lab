#include<stdio.h>
#include<stdlib.h>
#include<string.h>

int main(){
    int n;
    printf("Enter the number of productions: ");
    scanf("%d",&n);
    char p[n][100];
    printf("Enter the productions: ");
    for(int i=0;i<n;i++){
        scanf("%s",p[i]);
    }

    for(int i=0;i<n;i++){
        if (p[i][0]!=p[i][3]){
            printf("Left recursion doesn't exist for this production\n");
            printf("%s\n",p[i]);
        }
        else{
            printf("Left recursion exists!\n");
            char w[10][100],wo[10][100];
            bzero(&w,sizeof(w));
            bzero(&wo,sizeof(wo));
            int knt1=0,knt2=0,j=3;
            while(j<strlen(p[i])){
                if(p[i][0]==p[i][j]){
                    j++;
                    int k=0;
                    while(j<strlen(p[i]) && p[i][j]!='|'){
                        w[knt1][k] = p[i][j];
                        k++;
                        j++;
                    }
                    knt1++;
                }
                else{
                    int k=0;
                    while(j<strlen(p[i]) && p[i][j]!='|'){
                        wo[knt2][k] = p[i][j];
                        k++;
                        j++;
                    }
                    knt2++;          
                }
                j++;
            }
            printf("Left recursion eliminated grammar:\n");
            for(int l=0;l<knt2;l++){
                printf("%c->%s%c'\n",p[i][0],wo[l],p[i][0]);
            }
            for(int l=0;l<knt1;l++){
                printf("%c'->%s%c'\n",p[i][0],w[l],p[i][0]);
            }
            printf("%c'->e\n",p[i][0]);
        }
    }
    return 0;
}