# Relatório 2

Para este trabalho, comecei analisando a função main, na qual era possível ver a leitura da senha e a chamada de uma função de validação, que levava para a resposta correta ou para o erro.

A função de validação era composta por três outras funções, as quais transcrevi para a linguagem C após analisá-las passo a passo.

A primeira era a função dec(), que aparentemente atualizava o vetor da senha, porém, ela alterava outra label inútil (input0), ou seja, modificava um vetor não inicializado com uma variável também não inicializada.

void dec () {
    for (int i = 0; i <= 10; i++) {
        input0[i] = input0[i] + randomSalt;
    }
}

A segunda função era a sub(). Esta função de fato alterava o vetor com a senha, adicionando um valor em hexadecimal específico a cada uma das posições. Havia uma pequena "brincadeira" nesta função: ela alterava o vetor sequencialmente até um certo momento e, então, pulava um byte, alterava ele e depois voltava para alterar o anterior.

Por último, a função check(int salt), que de fato validava se o vetor input1 (o que foi alterado por dec()) era igual a um parâmetro passado, neste caso, o valor 0x77.

check(int salt) {
    for (int i = 0; i <= 10; i++ {
        if (input1[i] != salt)
            return false;
    }
    return true;
}

Por fim, caso você não tenha prestado atenção na alteração de sequência em dec(), chegaria em "caiunoabit?" ao fazer a transcrição para o código ASCII, fazendo de maneira correta chegamos na que a senha é "caiunobait?".
