#include "memory_api.h"


int main() {
    int x;

    setup_brk();

    dismiss_brk();

    memory_alloc(1);

    memory_free(&x);

    return 0;
}
