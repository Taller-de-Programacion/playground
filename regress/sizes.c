#include <stdio.h>

int main(int argc, char* argv[]) {
    printf("Sizes\n");
    printf("=====\n");
    printf("char:   %lu\n", sizeof(char));
    printf("short:  %lu\n", sizeof(short));
    printf("int:    %lu\n", sizeof(int));
    printf("long:   %lu\n", sizeof(long));
    printf("void*:  %lu\n", sizeof(void*));

    return 0;
}
