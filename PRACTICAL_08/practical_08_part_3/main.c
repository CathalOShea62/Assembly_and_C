#include <stdio.h> 

int main() 
{
    int a = 10;
    int b = 20;
    float c = 20.0122;
    char my_char = 'a';
    char *my_char_ptr = "Hello"; 

    printf("Value of a is %d\n", a);

    printf("Value of b is %d\n", b);

    printf("Value of c is %.4f\n", c);

    printf("Value of my_char is %c\n", my_char);

    printf("Value in memory for my_char_ptr is %s\n", my_char_ptr);

    printf("Value in memory for first char of my_char_ptr is %c\n", *my_char_ptr);

    return 0; 
}
