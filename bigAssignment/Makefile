# CFLAGS = -Wall -Wextra -Werror -g -std=c99
CFLAGS = -g -std=c99

CC = gcc

OBJS = main.o memory_api.o

all: paehAllocator

paehAllocator: $(OBJS)
	$(CC) -o paehAllocator $(OBJS)

main.o: main.c
	$(CC) -c $(CFLAGS) main.c -o main.o

memory_api.o: memory_api.c
	$(CC) -c $(CFLAGS) memory_api.c -o memory_api.o

clean:
	rm -f *.o paehAllocator