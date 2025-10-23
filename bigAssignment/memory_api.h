#ifndef MEMORY_API_H_H
#define MEMORY_API_H_H

//Obtém o endereço de brk
void setup_brk();

//Restaura o endereço de brk
void dismiss_brk();

//Aloca memória
void* memory_alloc(unsigned long int bytes);

//Marca um bloco ocupado como livre
int memory_free(void *pointer);

#endif //MEMORY_API_H_H
