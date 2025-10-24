#include "memory_api.h"

unsigned long int current_brk = 0;
unsigned long int base_heap = 0;

#define SIZE_OFFSET 8
#define BUSY_OFFSET 9


void setup_brk() {

    //syscall para obter o brk
    //base_brk = brk(0);
    //current_brk = brk(0);
}

void dismiss_brk() {

    // current_brk = base_brk;
    // sbrk(base_brk);
}

void* memory_alloc(unsigned long int bytes) {
    //    a) //1. Procura bloco livre com tamanho igual ou maior que a
    //    requisição
    

    if(base_heap == current_brk) {
        //sbrk(current_brk + bytes + BUSY_OFFSET); TODOTODO tratar caso erro...
        current_brk += bytes + BUSY_OFFSET;
    }

    unsigned char *iterador = ((unsigned char *)base_heap) + BUSY_OFFSET; //isso ta na stack fuck
 
    unsigned long int tamanho_atual = 0;
    unsigned long int tamanho_maior = 0;
    unsigned char * maior = 0;

    unsigned char ocupado = 0;
    //percorre toda a heap, quando acaba ele achou o maior bloco livre
    while (((unsigned long int)iterador < current_brk)) {
        tamanho_atual = *((unsigned long int *)(iterador - SIZE_OFFSET));
        ocupado = *((unsigned char *)(iterador - BUSY_OFFSET));

        if(tamanho_maior < tamanho_atual && !ocupado)
            maior = iterador;
            tamanho_maior = tamanho_atual;
        iterador += tamanho_atual + BUSY_OFFSET;
    }

    //achou o maior bloco valido => b) se não => c

    //    b) //2. Se encontrar, marca ocupação, utiliza os bytes
    //    necessários do bloco, retornando o endereço
    //    correspondente

    // verifica se há um bloco valido ja existente (maior só eh alterado se existe um bloco, 
    // caso contrario valerá 0)
    if((unsigned long)maior != 0){    

        *((unsigned char*)(maior - BUSY_OFFSET)) = (char)1;

        // Cria um novo bloco se bloco livre exceder o tamanho do bloco 
        // requisitado e houver bytes extras suficientes para alocar um 
        // novo registro com, no mínimo, 1 byte no bloco de dados.
        if(tamanho_maior >= bytes + 10){
            unsigned char *new_block = maior + bytes + BUSY_OFFSET;
            *(new_block - BUSY_OFFSET) = (char)0;
            *(unsigned long int *)(new_block - SIZE_OFFSET) = tamanho_maior - (bytes + BUSY_OFFSET);
            
            *((unsigned long int *)(maior - SIZE_OFFSET)) = bytes;
        }

    } else {//    c) //3. Se não encontrar, abre espaço para um novo bloco
        //sbrk(current_brk + bytes + BUSY_OFFSET); TODOTODO tratar caso erro...
        maior = current_brk + BUSY_OFFSET;
        current_brk += bytes + BUSY_OFFSET;
        //*((unsigned char*)(maior - BUSY_OFFSET)) = 1;
        //*((unsigned long*)(maior - SIZE_OFFSET)) = bytes;
    }


    return (void *) (unsigned long)maior;
}

int memory_free(void *pointer) {
    
    //erro: ponteiro não está contido na heap, logo invalido
    if((unsigned long)pointer < (base_heap + BUSY_OFFSET)  && current_brk <= (unsigned long)pointer){
        return -1;
    }
    
    //percorre toda a heap pra ver se o ponteiro eh valido
    unsigned char *iterator = base_heap + BUSY_OFFSET;
    while ((unsigned long)iterator < (unsigned long) pointer){
        iterator += *((unsigned long*)(iterator - SIZE_OFFSET)) + BUSY_OFFSET;
    }

    //pointer eh invalido pois não aponta para o inicio de um bloco de dados!
    if((unsigned long)iterator > (unsigned long)pointer){
        return -2;
    }
 
    char *valido = pointer - BUSY_OFFSET;

    *valido = (char)0; 

    return 0;
}
