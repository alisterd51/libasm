#include <stdio.h>
#include <string.h>
#include "libasm.h"

int main() {
    // test ft_strlen
    {
        printf("test ft_strlen:\n");
        char *str[] = {"", "hello", "t", "aaaaaa", "        ", NULL};
        for (int i = 0; str[i] != NULL; i++) {
            printf("%zu == %zu\n", strlen(str[i]), ft_strlen(str[i]));
        }
    }
}
