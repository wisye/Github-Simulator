all:
	gcc -o server server.s -lsqlite3 -lssl -lcrypto
	./server