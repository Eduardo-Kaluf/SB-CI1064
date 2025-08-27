# Relatório 2

Para este trabalho comecei analisando a main a qual era possivel ver a leitura da senha e a chamada de uma função de validação, a qual levava para a resposta correta ou para o erro.

A função de validação era composta de 3 outras funções as quais transcrevi para a linguagem C após analisa-las passo a passo.

A primeira era a função dec(), a qual aparentemente atualizava o vetor da senha, porém, ela alterava uma outra label inutil, ou seja, modificava um vetor não inicializado com uma variavel nao inicializada tambem.

void dec () {
    for (int i = 0; i <= 10; i++) {
        input0[i] = input0[i] + randomSalt;
    }
}

A segunda função era a função sub(), esta função de fato alterava o vetor com a senha, adicionando um valor em hex para cada uma das posições. Havia uma pequena "brincadeira" nesta função, ela alterava o vetor sequencialmente até um certo momento, e então, pulava um byte e o alterava somente após isso voltava e alterava o outro.

Por ultimo a função check(int salt), que de fato validava se o vetor input1, o que foi de fato alterado por dec() era igual a um parametro passado, neste caso, o valor 0x77

check(int salt) {
    for (int i = 0; i <= 10; i++ {
        if (input1[i] != salt)
            return false   
    }
    return true;
}

Por fim então, caso você não tenha prestado atenção na alteração de sequencia em dec(), voce chegaria em "caiunoabit?" ao fazer a transcrição para o código ASCII correto, mas de fato a senha que correta é "caiunobait?".
