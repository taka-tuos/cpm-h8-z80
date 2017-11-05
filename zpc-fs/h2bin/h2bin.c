#include <stdio.h>
#include <stdlib.h>
int main(int argc, char* argv[]){

    FILE *fp = NULL;
    char buffer[2];
    int rpoint = 0;

    if(argc != 3){
        fprintf(stderr, "usage: %s filename headname\n", argv[0]);
        return(-1);
    }

    fp = fopen(argv[1], "rb");

    if(fp == NULL){
        fprintf(stderr, "error: file open error(%s)\n",argv[1]);
        return(-1);
    }

    rpoint = 0;
    printf("static const char %s[] = {", argv[2]);
    while(fgets(buffer, 2, fp)){
        if((rpoint % 16) == 0){
            if(rpoint != 0){
                printf(",\n    ");
            }else{
                printf("\n    ");
            }
        }else{
            printf(", ");
        }
        printf("0x%02x", (int)((unsigned char)buffer[0]));
        rpoint++;
    }
    printf("\n    };\n");
    fclose(fp);

}
