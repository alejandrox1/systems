.PHONY: example-1 clean

example-1:
	gcc -S -o example1.s example1.c


example-2:
	gcc -S -o example2.s example2.c
	gcc example2.c -o example2


NO_PRO := -ggdb -m32 -fno-stack-protector -mpreferred-stack-boundary=4 -Wincompatible-pointer-types
example-3:
	gcc -S -o example3.s example3.c
	gcc $(NO_PRO) -S -o example3-nop.s example3.c
	gcc $(NO_PRO) example3.c -o example3


clean:
	rm -f example1.s
	rm -f example2 example2.s
	rm -f example3 example3.s
