#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include "libasm.h"

int main() {
    int ret_value = 0;

    // test ft_strlen
    {
        printf("\ntest ft_strlen:\n");
        const char *str[] = {"", "hello", "t", "aaaaaa", "        ", "qwertyuiop", NULL};
        for (int i = 0; str[i] != NULL; i++) {
            size_t  ret_1 = strlen(str[i]);
            size_t  ret_2 = ft_strlen(str[i]);

            printf("%zu == %zu.", ret_1, ret_2);
            if (ret_1 == ret_2) {
                printf(" OK\n");
            }
            else {
                printf(" KO\n");
                ret_value = 1;
            }
        }
    }
    // test ft_strcpy
    {
        printf("\ntest ft_strcpy:\n");
        const char *str[] = {"", "hello", "t", "aaaaaa", "        ", "qwertyuiop", NULL};
        for (int i = 0; str[i] != NULL; i++) {
            char str_cpy_1[11] = "aaaaaaaaaa";
            char str_cpy_2[11] = "aaaaaaaaaa";
            char *str_cpy_ptr_1 = strcpy(str_cpy_1, str[i]);
            char *str_cpy_ptr_2 = strcpy(str_cpy_2, str[i]);

            printf("diff_ret = %d, dest = \'", str_cpy_ptr_1 == str_cpy_1); fflush(NULL);
            write(1, str_cpy_1, 10);
            printf("\', len_dest: %zu", strlen(str_cpy_1));
            printf(" == ");
            printf("diff_ret = %d, dest = \'", str_cpy_ptr_2 == str_cpy_2); fflush(NULL);
            write(1, str_cpy_2, 10);
            printf("\', len_dest: %zu.", strlen(str_cpy_2));
            if (str_cpy_ptr_2 == str_cpy_2 && memcmp(str_cpy_1, str_cpy_2, 11 * sizeof(char)) == 0) {
                printf(" OK\n");
            }
            else {
                printf(" KO\n");
                ret_value = 1;
            }
        }
    }
    return (ret_value);
}
