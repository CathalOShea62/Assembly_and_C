#include <stdio.h>

void byValue(int a);
void byReference(int *a);

int main()
{
    int a = 10;
    int b = a;

    printf("Value of a: %d\n", a);

    byValue(a);
    printf("Pass by value a : %d\n", a);

    if (b == a)
    {
        printf("No side effects here\n");
    }
    else
    {
        printf("Something happened a!\n");
    }

    byReference(&a);
    printf("Pass by reference a : %d\n", a);

    if (b == a)
    {
        printf("No side effects here\n");
    }
    else
    {
        printf("Something happened a!\n");
    }

    return 0;
}

void byValue(int a)
{
    a = a * 3;
}

void byReference(int *a)
{
    *a = *a * 3;
}
