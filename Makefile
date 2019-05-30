.PHONY: all clean install

CFLAGS += -O3 -Wall -Werror -Winline -pedantic-errors -std=c99
PREFIX := /usr/local
BINDIR := $(PREFIX)/bin

all: prompt_pwd

prompt_pwd: prompt_pwd.o
	$(CC) $(LDFLAGS) $^ -o $@

clean:
	rm -f prompt_pwd *.o

install: prompt_pwd
	mkdir -p $(BINDIR)
	cp prompt_pwd $(BINDIR)
