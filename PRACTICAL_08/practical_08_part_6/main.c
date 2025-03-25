#include <stdio.h> 

int main()
{
    int a = 10;
    int b = 20;

    int total = a + b;
    printf("Addition Example total: %d\n", total);

    total = b - a;
    printf("Subtraction Example total: %d\n", total);

    total = b * a;
    printf("Multiplication Example total: %d\n", total);

    total = b / a;
    printf("Integer Division Example total: %d\n", total);

    float div_result = (float)b / a;
    printf("Floating-point Division Example total: %.2f\n", div_result);

    total = b % a;
    printf("Modulus Example total: %d\n", total);

    return 0;
}
