#include <stdio.h>   
#include <stdbool.h> 

int main()
{
    int a = 10;
    int b = 20;

    // Relational Operator Examples
    bool result = a > b;
    printf("a > b Example: %s\n", result ? "true" : "false");

    result = a < b;
    printf("a < b Example: %s\n", result ? "true" : "false");

    result = a >= b;
    printf("a >= b Example: %s\n", result ? "true" : "false");

    result = a <= b;
    printf("a <= b Example: %s\n", result ? "true" : "false");

    result = a == b;
    printf("a == b Example: %s\n", result ? "true" : "false");

    result = a != b;
    printf("a != b Example: %s\n", result ? "true" : "false");

    // Logical Operator Examples
    result = (bool)(a && b); 
    printf("a && b Example: %s\n", result ? "true" : "false");

    result = (bool)(a || b); 
    printf("a || b Example: %s\n", result ? "true" : "false");

    result = !a; 
    printf("!a Example: %s\n", result ? "true" : "false");

    result = !!a; 
    printf("!!a Example: %s\n", result ? "true" : "false");

    return 0;
}
