#include "libasm.h"
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <fcntl.h>
#include <stdlib.h>

#define RED   "\x1B[31m"
#define GRN   "\x1B[32m"
#define RESET "\x1B[0m"

static inline void print_result(int result, int *ret_value)
{
    if (result)
        printf(GRN " OK\n" RESET);
    else
    {
        printf(RED " KO\n" RESET);
        *ret_value = 1;
    }
}

void    test_ft_strlen(int *ret_value)
{
    printf("\ntest ft_strlen:\n");
    const char *str[] = {"", "hello", "t", "aaaaaa", "        ", "qwertyuiop", NULL};
    for (int i = 0; str[i] != NULL; i++)
    {
        size_t ret_1 = strlen(str[i]);
        size_t ret_2 = ft_strlen(str[i]);

        printf("strlen(\"%s\"): ", str[i]);
        printf("%zu == %zu.", ret_1, ret_2);
        print_result(ret_1 == ret_2, ret_value);
    }
}

void    test_ft_strcpy(int *ret_value)
{
    printf("\ntest ft_strcpy:\n");
    const char *str[] = {"", "hello", "t", "aaaaaa", "        ", "qwertyuiop", NULL};
    for (int i = 0; str[i] != NULL; i++)
    {
        char str_cpy_1[11] = "aaaaaaaaaa";
        char str_cpy_2[11] = "aaaaaaaaaa";
        printf("strcpy(\"%s\", \"%s\"): ", str_cpy_1, str[i]);
        char *str_cpy_ptr_1 = strcpy(str_cpy_1, str[i]);
        char *str_cpy_ptr_2 = ft_strcpy(str_cpy_2, str[i]);
        ssize_t ret_write;

        printf("diff_ret = %d, dest = \'", str_cpy_ptr_1 == str_cpy_1);
        fflush(NULL);
        ret_write = write(1, str_cpy_1, 10);
        printf("\', len_dest: %zu", strlen(str_cpy_1));
        printf(" == ");
        printf("diff_ret = %d, dest = \'", str_cpy_ptr_2 == str_cpy_2);
        fflush(NULL);
        ret_write = write(1, str_cpy_2, 10);
        printf("\', len_dest: %zu.", strlen(str_cpy_2));
        print_result(str_cpy_ptr_2 == str_cpy_2 && memcmp(str_cpy_1, str_cpy_2, 11 * sizeof(char)) == 0, ret_value);
        (void)ret_write;
    }
}

void    test_ft_strcmp(int *ret_value)
{
    printf("\ntest ft_strcmp:\n");
    const char *str_1[] = {"", "hello", "t", "y", "", "a", NULL};
    const char *str_2[] = {"", "hello", "y", "t", "a", "", NULL};
    for (int i = 0; str_1[i] != NULL && str_2[i] != NULL; i++)
    {
        int ret_1 = strcmp(str_1[i], str_2[i]);
        int ret_2 = ft_strcmp(str_1[i], str_2[i]);

        // to respect the man, we normalize the result of 'strcmp'
        if (ret_1 > 0)
            ret_1 = 1;
        else if (ret_1 < 0)
            ret_1 = -1;
        if (ret_2 > 0)
            ret_2 = 1;
        else if (ret_2 < 0)
            ret_2 = -1;
        printf("strcmp(\"%s\", \"%s\"): ", str_1[i], str_2[i]);
        printf("%d == %d.", ret_1, ret_2);
        print_result(ret_1 == ret_2, ret_value);
    }
}

void    test_ft_write(int *ret_value)
{
    printf("\ntest ft_write:\n");
    const char *str[] = {"", "", "hello", "hello", "hello", "hello", "\0a\0b", NULL};
    const int len[] = {0, 1, 0, 5, 1, -1, 5};
    for (int i = 0; str[i] != NULL; i++)
    {
        const int fds[] = {1, 42, -1};

        for (int j = 0; j < 3; j++)
        {
            int ret_1 = 0;
            int ret_2 = 0;
            int errno_1 = 0;
            int errno_2 = 0;

            printf("write(%d, \"%s\", %d): ", fds[j], str[i], len[i]);
            printf("\'");
            fflush(NULL);
            ret_1 = write(fds[j], str[i], len[i]);
            if (ret_1 == -1)
                errno_1 = errno;
            printf("\' == \'");
            fflush(NULL);
            ret_2 = ft_write(fds[j], str[i], len[i]);
            if (ret_2 == -1)
                errno_2 = errno;
            printf("\', ");
            fflush(NULL);

            printf("%d == %d, errno: %d == %d.", ret_1, ret_2, errno_1, errno_2);
            print_result(ret_1 == ret_2 && errno_1 == errno_2, ret_value);
        }
    }
}

void    test_ft_read(int *ret_value)
{
    printf("\ntest ft_read:\n");
    const char *content[] = {"", "a", "hello", NULL};
    for (int i = 0; content[i] != NULL; i++)
    {
        const int lens[] = {0, 1, 42};

        for (int j = 0; j < 3; j++)
        {
            int fd = open("test_read.txt", O_WRONLY | O_CREAT, 00662);
            int ret_write = write(fd, content[i], strlen(content[i]));
            (void)ret_write;
            close(fd);
            int fd_1 = open("test_read.txt", O_RDONLY);
            int fd_2 = open("test_read.txt", O_RDONLY);
            const int fds_1[] = {fd_1, -1, 42};
            const int fds_2[] = {fd_2, -1, 42};
            for (int k = 0; k < 3; k++)
            {
                int ret_1 = 0;
                int ret_2 = 0;
                int errno_1 = 0;
                int errno_2 = 0;

                char buf_1[50] = {0};
                char buf_2[50] = {0};

                printf("read(%d, \"%s\", %d): ", fds_1[k], buf_1, lens[j]);
                ret_1 = read(fds_1[k], buf_1, lens[j]);
                if (ret_1 == -1)
                    errno_1 = errno;
                ret_2 = ft_read(fds_2[k], buf_2, lens[j]);
                if (ret_2 == -1)
                    errno_2 = errno;
                printf("ret: %d == %d, buf: \"%s\" == \"%s\", errno: %d == %d", ret_1, ret_2, buf_1, buf_2, errno_1, errno_2);
                print_result(ret_1 == ret_2 && strcmp(buf_1, buf_2) == 0 && errno_1 == errno_2, ret_value);
            }
            close(fd_1);
            close(fd_2);
            remove("test_read.txt");
        }
    }
}

void    test_ft_strdup(int *ret_value)
{
    printf("\ntest ft_strdup:\n");
    const char *str[] = {"", "a", "hello", NULL};
    for (int i = 0; str[i] != NULL; i++)
    {
        char *ret_1 = strdup(str[i]);
        char *ret_2 = ft_strdup(str[i]);

        printf("strdup(\"%s\"): ", str[i]);
        printf("\"%s\" == \"%s\"", ret_1, ret_2);
        if (strlen(str[i]) > 1)
        {
            ret_1[0] = 'H';
            ret_2[0] = 'H';
        }
        printf(" \"%s\" == \"%s\".", ret_1, ret_2);
        print_result(strcmp(ret_1, ret_2) == 0, ret_value);
        free(ret_1);
        free(ret_2);
    }
}

int main(void)
{
    int ret_value = 0;

    test_ft_strlen(&ret_value);
    test_ft_strcpy(&ret_value);
    test_ft_strcmp(&ret_value);
    test_ft_write(&ret_value);
    test_ft_read(&ret_value);
    test_ft_strdup(&ret_value);
    return (ret_value);
}
