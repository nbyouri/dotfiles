CC = clang
CFLAGS = -I/usr/pkg/include
LDFLAGS = -L/usr/pkg/lib -lsqlite3
all:
	${CC} ${CFLAGS} info.c ${LDFLAGS} -o info
clean:
	rm info
