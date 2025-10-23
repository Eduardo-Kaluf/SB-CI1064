#include "memory_api.h"

unsigned long int current_brk;
unsigned long int base_heap;

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
        //sbrk(current_brk + bytes + 9); TODOTODO tratar caso erro...
        current_brk += bytes + 9;
    }

    unsigned char *iterador = base_heap + 9; //isso ta na stack fuck
 
    unsigned long int tamanho = *((unsigned long int *)(iterador - 8));

    unsigned char ocupado = *((unsigned char*)(iterador - 9));

    //procura enquanto o não achar um bloco que tenha o tamanho necessario e não seja ocupado
    while ((tamanho < bytes || ocupado) && ((unsigned long int)iterador < current_brk)) {
        iterador += tamanho + 9;
        tamanho = *((unsigned long int *)(iterador - 8));
        ocupado = *((unsigned char *)(iterador - 9));
    }

    //achou um bloco valido => b) se não => c

    //    b) //2. Se encontrar, marca ocupação, utiliza os bytes
    //    necessários do bloco, retornando o endereço
    //    correspondente

    //salva como ocupado e retorna o novo bloco!!
    if((unsigned long)iterador < current_brk){    
        *((unsigned char*)(iterador - 9)) = 1;   

        // Cria um novo bloco se bloco livre exceder o tamanho do bloco 
        // requisitado e houver bytes extras suficientes para alocar um 
        // novo registro com, no mínimo, 1 byte no bloco de dados.
        if(tamanho >= bytes + 10){
            unsigned char *new_block = iterador + bytes + 9;
            *(new_block - 9) = (char)0;
            *(unsigned long int *)(new_block - 8) = tamanho - (bytes + 9);
            
            *((unsigned long int *)(iterador - 8)) = bytes;
        }

    } else {//    c) //3. Se não encontrar, abre espaço para um novo bloco
        //ITERADOR EXATAMENTE IGUAL A CURRENT_BRK + 9 ENTAO
        //sbrk(current_brk + bytes + 9); TODOTODO tratar caso erro...
        current_brk += bytes + 9;
        //*((unsigned char*)(iterador - 9)) = 1;
        //*((unsigned long*)(iterador - 8)) = bytes;
    }


    return (void *) (unsigned long)iterador;
}

int memory_free(void *pointer) {
    
    //erro: ponteiro não está contido na heap, logo invalido
    if((unsigned long)pointer < (base_heap + 9)  && current_brk <= (unsigned long)pointer){
        return -1;
    }
    
    //percorre toda a heap pra ver se o ponteiro eh valido
    unsigned char *iterator = base_heap + 9;
    while ((unsigned long)iterator < (unsigned long) pointer){
        iterator += *((unsigned long*)(iterator - 8)) + 9;
    }

    //pointer eh invalido pois não aponta para o inicio de um bloco de dados!
    if((unsigned long)iterator > (unsigned long)pointer){
        return -2;
    }
 
    char *valido = pointer - 9;

    *valido = (char)0; 

    return 0;
}

