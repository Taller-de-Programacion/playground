#include <thread>
#include <mutex>
#include <iostream>

#define N_ELEMS 10

void adder(unsigned long *sum, std::mutex *sum_lock, unsigned int *elements, int i) {
    sum_lock->lock();
    *sum += elements[i];
    sum_lock->unlock();
}

int main() {
    unsigned int elements[N_ELEMS] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    std::thread threads[N_ELEMS];

    std::mutex sum_lock;
    unsigned long sum = 0;
    
    for (int i = 0; i < N_ELEMS; ++i) {
        threads[i] = std::thread {adder, &sum, &sum_lock, elements, i};
    }

    for (auto& thread : threads) {
        thread.join();
    }

    std::cout << "Sum = " << sum 
              << ((sum == (elements[0] + elements[N_ELEMS-1]) * N_ELEMS/2) ? 
                      " (ok)" : " (fail)")
              << std::endl;

    return 0;
}
