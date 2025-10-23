#include "memory_api.h"


void setup_brk() {

}

void dismiss_brk() {

}

void* memory_alloc(unsigned long int bytes) {
    //    a) //1. Procura bloco livre com tamanho igual ou maior que a
    //    requisição
    //    b) //2. Se encontrar, marca ocupação, utiliza os bytes
    //    necessários do bloco, retornando o endereço
    //    correspondente
    //    c) //3. Se não encontrar, abre espaço para um novo bloco
    return (void*)0;
}

int memory_free(void *pointer) {
    return 0;
}
