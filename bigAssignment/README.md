# AUTORIA

- EDUARDO KALUF GRR20241770

- SERGIO SIVONEI DE SANT'ANA FILHO GRR20242337

# MÓDULOS

# OTIMIZAÇÕES E ERROS

Como as funções setup_brk e dismiss_brk são do tipo void, não é possível retornar algum erro para o usuário,
ou seja, não é possível tratar caso a syscall de errado. Dessa forma, assumimos que a syscall vai funcionar corretamente 
nessas duas funções.

# I/O

# Observações


[Brk Info](https://man7.org/linux/man-pages/man2/brk.2.html)
" [...] However, the actual Linux system call returns the new program
break on success.  On failure, the system call returns the current
break"