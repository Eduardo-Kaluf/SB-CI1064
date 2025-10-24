#include "memory_api.h"
#include <stdio.h>

extern void* base_heap;
extern void* current_brk;
extern void* debug;
extern long *my_sbrk(long bytes);

int main() {
    int x;

    setup_brk();
    printf("The base of the heap is at: %p\n", base_heap);

    printf("The current heap is: %p\n", current_brk);


    int *pinteiro = memory_alloc(4);
    printf("The debug is: %p\n", debug);

    *pinteiro = 9;
    printf("The number is: %d\n", *pinteiro);

    printf("The current heap is: %p\n", current_brk);
    printf("The base is: %p\n", base_heap);
    printf("The pinteiro is: %p\n", pinteiro);
    printf("erro: %d\n", memory_free(pinteiro));


    dismiss_brk();
    return 0;
}
