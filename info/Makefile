CC = clang
PREFIX = /usr/pkg/bin
CFLAGS = -I/usr/include
LDFLAGS = -L/usr/lib -lsqlite3
all:
	${CC} ${CFLAGS} info.c ${LDFLAGS} -o osxinfo
install:
	cp osxinfo ${PREFIX}
clean:
	rm osxinfo
