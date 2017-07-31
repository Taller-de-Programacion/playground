#define _POSIX_C_SOURCE 199399

#include <pthread.h>
#include <time.h>
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <sys/time.h>

#define SPINS    (1000*1000*1000)
#define MICROSEC (1000)

#define EXPERIMENTS (20)

void* func(void* data) {
    unsigned long spins = *(unsigned long*)data;

    unsigned long j = 0;
    for (unsigned long i = 0; i < spins; ++i)
        ++j;
        
    return 0;
}

void process(int n_threads, double* d_user) {
    struct timeval begin, end;
    
    // split the workload into n threads
    unsigned long spins = (unsigned long)round((double)SPINS / n_threads);
    
    pthread_t* threads = (pthread_t*)malloc(sizeof(pthread_t) * n_threads);
    gettimeofday(&begin, 0);
    for (int i = 0; i < n_threads; ++i)
        pthread_create(&threads[i], 0, func, &spins);

    
    for (int i = 0; i < n_threads; ++i)
        pthread_join(threads[i], 0);

    gettimeofday(&end, 0);
    free(threads);

    *d_user = (end.tv_sec - begin.tv_sec) * 1e6 + (end.tv_usec - begin.tv_usec);
}

void min_process(int n_threads, double* d_user) {
    *d_user = INFINITY;

    double d_user_exp;
    for (int i = 0; i < EXPERIMENTS; ++i) {
        process(n_threads, &d_user_exp);
        if (d_user_exp < *d_user)
            *d_user = d_user_exp;
    }
}

int main(int argc, char* argv[]) {
    if (argc != 2)
        return 1;
    
    int n_threads = atoi(argv[1]);

    if (n_threads <= 0)
        return 2;

    double baseline_user, 
           real_user;

    setbuf(stdout, NULL);
    printf("Calculating a baseline with only 1 thread...\n");
    min_process(1, &baseline_user);

    printf("Calculating speed up using %i threads...\n", n_threads);
    min_process(n_threads, &real_user);

    printf("Speedup: %u\n", (unsigned int) ceil(baseline_user/real_user));
    return 0;
}

