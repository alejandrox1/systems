#include <stdio.h>


void function(int a, int b, int c){
    char buffer1[8];
    char buffer2[10];
    
    int *ret;

    // 0xc gets us to %ebp, another 0x4 will get us to ret pointer under ebp.
    ret = buffer1 + 0x10;
    (*ret) += 8;
}


void main() {
    int x;

    x = 0;
    function(1, 2, 3);
    x = 1;

    printf("%d\n", x);
}
