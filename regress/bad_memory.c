#include <stdlib.h>
#include <unistd.h>

void heap_overflow() {
    long page_size = sysconf(_SC_PAGESIZE);

    char* buf = (char*)malloc(page_size - 16);
    buf[page_size - 8] = 42;    // write overflow

    free(buf);
}

void double_free() {
    void* buf = malloc(4);
    
    free(buf);
    free(buf);  // ups mom, I did it again
}

void memory_leak() {
    void* buf = malloc(4);
}

int main(int argc, char* argv[]) {
    heap_overflow();
    double_free();
    memory_leak();

    return 0;
}
