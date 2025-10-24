#include "memory_api.h"
#include <stdio.h>

extern void* base_heap;

int main() {
    int x;

    setup_brk();
    printf("The base of the heap is at: %p\n", base_heap);
    dismiss_brk();

    memory_alloc(1);

    memory_free(&x);

    return 0;
}
