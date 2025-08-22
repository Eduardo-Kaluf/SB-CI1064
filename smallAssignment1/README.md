# Relatório1

Para este trabalho (e possivelmente para os próximos) eu utilizei a ferramenta Ghidra em conjunto ao debugger gdb acoplado a um terminal externo. A primeira coisa que fiz foi procurar por strings dentro do binário a fim de descobrir onde a checagem da senha era feita. Assim consegui estabelecer este local com breakpoints e marcações, confirmando que um loop de checagem da senha era feito com base em um "buf".

Após isso, olhei o programa de cima a baixo, mexendo nele com o debugger, and fui alterando os nomes dos registradores conforme as funções que eles realizavam para me organizar melhor. Depois de algum tempo, cheguei novamente na função de checagem e percebi que ela utilizava dos caracteres inseridos no nome do usuário. Fiz algumas contas e percebi que ela pulava a parte "Hello" da string, lia um caractere e acrescentava 5. Logo após, a comparação era feita e tinham dois jumps. Deduzi que um deles era para o próprio loop da função de checagem e o outro caso o usuário tivesse errado a senha.

Dessa forma, ficou claro que o que estava sendo comparado era o próprio input do nome do usuário e a senha, com o input tendo um acréscimo de 5 após o byte ter sido selecionado, ou seja, uma cifra de césar para a senha.

Após isso, testei com 11111 66666 e obtive sucesso.

Além disso, também modifiquei o binário pelo Ghidra a fim de que o programa aceite qualquer combinação de usuário e senha. Para fazer isso, bastou eu trocar os jumps por alguns números 90 (NOPs) e estava feito o patch do programa.
