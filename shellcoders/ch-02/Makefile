CC=cc

.PHONY: function clean

function: function.c
	$(CC) -m32 -mpreferred-stack-boundary=2 -ggdb -fno-stack-protector -O0 $^ -o $@

clean:
	rm function
