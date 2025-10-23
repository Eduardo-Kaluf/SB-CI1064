CC = gcc

CFLAGS = -g -std=c99

TARGET = paehAllocator

OBJS = main.o memory_api.o

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o $(TARGET)

main.o: main.c memory_api.h
	$(CC) $(CFLAGS) -c main.c -o main.o

memory_api.o: memory_api.s
	nasm -f elf64 -o memory_api.o memory_api.s

clean:
	rm -f $(TARGET) $(OBJS)
