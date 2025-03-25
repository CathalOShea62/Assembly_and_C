#include <stdio.h>

int add(int, int);

int main()
{
    int result;

    result = add(3, 4);

    printf("Result : %d\n", result);

    return 0;
}

int add(int a, int b)
{
    return a + b;
}
