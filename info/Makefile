CC = clang
PREFIX = /usr/pkg/bin
CFLAGS = -I/usr/include
LDFLAGS = -L/usr/lib -lsqlite3 -framework IOKit -framework Foundation
all:
	${CC} ${CFLAGS} info.c ${LDFLAGS} -o osxinfo
install:
	cp osxinfo ${PREFIX}
clean:
	rm osxinfo
