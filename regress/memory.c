#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#define MB (1024*1024)

int main(int argc, char* argv[]) {
    if (argc != 2)
        return 1;

    int n_pages = atoi(argv[1]);

    if (n_pages <= 0)
        return 2;

    setbuf(stdout, NULL);
    printf("Allocating %i pages (%u megabytes)...\n", n_pages, n_pages * MB);

    void** pages = malloc(sizeof(void*) * n_pages);
    for (int i = 0; i < n_pages; ++i) {
        pages[i] = malloc(MB);
        memset(pages[i], i, MB);
    }

    printf("Allocation successful\n");
    
    for (int i = 0; i < n_pages; ++i)
        free(pages[i]);

    free(pages);
    return 0;
}
