#include "memory_api.h"
#include <stdio.h>

extern void* base_heap;
extern void* current_brk;

extern long *my_sbrk(long bytes);

int main() {
    int x;

    setup_brk();
    printf("The base of the heap is at: %p\n", base_heap);

    printf("The current heap is: %p\n", current_brk);

    my_sbrk(10);

    printf("The current heap is: %p\n", current_brk);


    dismiss_brk();

    memory_alloc(1);

    memory_free(&x);

    return 0;
}
