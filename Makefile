CFLAGS ?= -O3
LDFLAGS ?= -s

LUA = lua5.3
CFLAGS += $(shell pkg-config --cflags $(LUA))

.PHONY: all test clean

all: yieldhook.so

test: all
	$(LUA) test.lua

clean:
	rm -f *.so

%.so: %.c
	$(CC) $(CFLAGS) -fPIC -shared -o $@ $< $(LDFLAGS)

