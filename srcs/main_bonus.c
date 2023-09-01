#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include <ctype.h>
#include <limits.h>
#include "libasm.h"

int is_duplicate(const char *base)
{
    bool present[256] = {0};

    for (int i = 0; base[i] != '\0'; i++)
    {
        if (present[(unsigned char)(base[i])] == true)
            return (1);
        present[(unsigned char)(base[i])] = true;
    }
    return (0);
}

int invalid_char_base(const char *base)
{
    for (int i = 0; base[i]; i++)
        if (isspace(base[i]) || base[i] == '-' || base[i] == '+')
            return (1);
    return (0);
}

int ft_atoi_base_ref(const char *str, const char *base)
{
    int sign = 1;
    int i = 0;
    unsigned long int ret_value = 0;

    if (strlen(base) <= 1 || is_duplicate(base) || invalid_char_base(base))
        return (0);
    while (isspace(str[i]))
    {
        i++;
    }
    while (str[i] == '-' || str[i] == '+')
    {
        if (str[i] == '-')
            sign *= -1;
        i++;
    }
    while (str[i] != '\0' && strchr(base, str[i]) != NULL && strchr(base, str[i]) != base + strlen(base))
    {
        if (LONG_MAX / strlen(base) + (int)(strchr(base, str[i]) - base) < ret_value)
            return (0);
        ret_value = ret_value * strlen(base) + (int)(strchr(base, str[i]) - base);
        i++;
    }
    return ((int)ret_value * sign);
}

t_list *ft_list_new_ref(void *data)
{
    t_list *list;

    list = (t_list *)malloc(sizeof(t_list));
    if (list == NULL)
        return (NULL);
    *list = (t_list){.data = data, .next = NULL};
    return (list);
}

void ft_list_push_front_ref(t_list **begin_list, void *data)
{
    t_list *list = ft_list_new_ref(data);

    if (list != NULL)
    {
        list->next = *begin_list;
        *begin_list = list;
    }
}

int ft_list_size_ref(t_list *begin_list)
{
    int ret_value = 0;

    while (begin_list != NULL)
    {
        ret_value++;
        begin_list = begin_list->next;
    }
    return (ret_value);
}

void ft_list_print_ref(t_list *list)
{
    while (list != NULL)
    {
        printf("%s", (char *)list->data);
        if (list->next != NULL)
        {
            printf(" -> ");
        }
        list = list->next;
    }
}

int ft_list_sorted_ref(t_list *begin_list, int(cmp)(void *, void *))
{
    while (begin_list != NULL && begin_list->next != NULL)
    {
        if ((*cmp)(begin_list->data, begin_list->next->data) > 0)
            return (0);
        begin_list = begin_list->next;
    }
    return (1);
}

void ft_list_sort_ref(t_list **begin_list, int(cmp)(void *, void *))
{
    t_list list = (t_list){.data = NULL, .next = *begin_list};

    while (!ft_list_sorted_ref(list.next, cmp))
    {
        for (t_list *l = &list; l->next != NULL && l->next->next != NULL; l = l->next)
        {
            if ((*cmp)(l->next->data, l->next->next->data) > 0)
            {
                t_list *node_1 = l->next;
                t_list *node_2 = l->next->next;

                node_1->next = node_2->next;
                node_2->next = node_1;
                l->next = node_2;
            }
        }
    }
    *begin_list = list.next;
}

void ft_list_remove_if_ref(t_list **begin_list, void *data_ref, int (*cmp)(void *, void *), void (*free_fct)(void *))
{
    t_list list = (t_list){.data = NULL, .next = *begin_list};

    for (t_list *l = &list; l != NULL && l->next != NULL; l = l->next)
    {
        if ((*cmp)(l->next->data, data_ref) == 0)
        {
            t_list *tmp = l->next->next;

            (*free_fct)(l->next->data);
            free(l->next);
            l->next = tmp;
        }
    }
    *begin_list = list.next;
}

int ft_list_diff_ref(t_list *list_1, t_list *list_2)
{
    while (list_1 != NULL || list_2 != NULL)
    {
        if (list_1 == NULL || list_2 == NULL || strcmp(list_1->data, list_2->data))
        {
            return (1);
        }
        list_1 = list_1->next;
        list_2 = list_2->next;
    }
    return (0);
}

void ft_list_clear_ref(t_list *begin_list, void (*free_fct)(void *))
{
    t_list *tmp = NULL;

    while (begin_list != NULL)
    {
        tmp = begin_list->next;
        (*free_fct)(begin_list->data);
        free(begin_list);
        begin_list = tmp;
    }
}

int ft_cmp(void *s1, void *s2)
{
    return (strcmp((void *)s1, (void *)s2));
}

int main()
{
    int ret_value = 0;

    // test ft_atoi_base
    {
        printf("\ntest ft_atoi_base:\n");
        char *str[] = {"", "\?", "01", "2", "afffffffa", "-", "-0", "-1", "   ---+--+1234ab567", "   ---+-+1234ab567", "1234ab567", "-2147483649", "4294967295", "-9223372036854775808", "-18446744073709551615", "43", "+43", "-43", "--43", "---43", " -43", " --43", " ---43", NULL};
        for (int i = 0; str[i] != NULL; i++)
        {
            char *base[] = {"", "0", "010", "001", "0\t1", "01 ", "+01", "01", "01234567", "0123456789", "0123456789abcdef", NULL};

            for (int j = 0; base[j] != NULL; j++)
            {
                int ret_1 = ft_atoi_base_ref(str[i], base[j]);
                int ret_2 = ft_atoi_base(str[i], base[j]);

                printf("ft_atoi_base(\"%s\", \"%s\"): ", str[i], base[j]);
                printf("%d == %d.", ret_1, ret_2);
                if (ret_1 == ret_2)
                {
                    printf(" OK\n");
                }
                else
                {
                    printf(" KO\n");
                    ret_value = 1;
                }
            }
        }
    }
    // test ft_list_push_front
    {
        printf("\ntest ft_list_push_front:\n");
        const char *str[] = {"a", "b", "c", NULL};

        printf("ft_list_push_front(): ");
        t_list *list_1 = NULL;
        t_list *list_2 = NULL;
        for (int i = 0; str[i] != NULL; i++)
        {
            ft_list_push_front_ref(&list_1, (void *)strdup(str[i]));
            ft_list_push_front(&list_2, (void *)strdup(str[i]));
        }
        ft_list_print_ref(list_1);
        printf(" == ");
        ft_list_print_ref(list_2);
        if (ft_list_diff_ref(list_1, list_2) == 0)
        {
            printf(" OK\n");
        }
        else
        {
            printf(" KO\n");
            ret_value = 1;
        }
        ft_list_clear_ref(list_1, free);
        ft_list_clear_ref(list_2, free);
    }
    // test ft_list_size
    {
        printf("\ntest ft_list_size:\n");
        const char *str[] = {"a", "b", "c", NULL};
        const int lens[] = {0, 1, 2, 3};

        for (int j = 0; j < 4; j++)
        {
            printf("ft_list_size(): ");
            t_list *list_1 = NULL;
            t_list *list_2 = NULL;
            int ret_1;
            int ret_2;

            for (int i = 0; str[i] != NULL && i < lens[j]; i++)
            {
                ft_list_push_front_ref(&list_1, (void *)strdup(str[i]));
                ft_list_push_front_ref(&list_2, (void *)strdup(str[i]));
            }
            ret_1 = ft_list_size_ref(list_1);
            ret_2 = ft_list_size_ref(list_2);
            printf("%d == %d", ret_1, ret_2);
            if (ret_1 == ret_2)
            {
                printf(" OK\n");
            }
            else
            {
                printf(" KO\n");
                ret_value = 1;
            }
            ft_list_clear_ref(list_1, free);
            ft_list_clear_ref(list_2, free);
        }
    }
    // test ft_list_sort
    {
        printf("\ntest ft_list_sort:\n");
        const char *str[] = {"a", "b", "c", NULL};
        const int lens[] = {0, 1, 2, 3};

        for (int j = 0; j < 4; j++)
        {
            printf("ft_list_sort(): ");
            t_list *list_1 = NULL;
            t_list *list_2 = NULL;

            for (int i = 0; str[i] != NULL && i < lens[j]; i++)
            {
                ft_list_push_front_ref(&list_1, (void *)strdup(str[i]));
                ft_list_push_front_ref(&list_2, (void *)strdup(str[i]));
            }
            ft_list_sort_ref(&list_1, ft_cmp);
            ft_list_sort_ref(&list_2, ft_cmp);
            ft_list_print_ref(list_1);
            printf(" == ");
            ft_list_print_ref(list_2);
            if (ft_list_diff_ref(list_1, list_2) == 0)
            {
                printf(" OK\n");
            }
            else
            {
                printf(" KO\n");
                ret_value = 1;
            }
            ft_list_clear_ref(list_1, free);
            ft_list_clear_ref(list_2, free);
        }
    }
    // ft_list_remove_if
    {
        printf("\ntest ft_list_remove_if:\n");
        const char *str[] = {"a", "b", "c", NULL};
        const char *str_ref[] = {"a", "b", "c", NULL};
        const int lens[] = {0, 1, 2, 3};

        for (int k = 0; str_ref[k] != NULL; k++)
        {
            for (int j = 0; j < 4; j++)
            {
                printf("ft_list_sort(): ");
                t_list *list_1 = NULL;
                t_list *list_2 = NULL;

                for (int i = 0; str[i] != NULL && i < lens[j]; i++)
                {
                    ft_list_push_front_ref(&list_1, (void *)strdup(str[i]));
                    ft_list_push_front_ref(&list_2, (void *)strdup(str[i]));
                }
                ft_list_remove_if_ref(&list_1, (void *)str_ref[k], ft_cmp, free);
                ft_list_remove_if_ref(&list_2, (void *)str_ref[k], ft_cmp, free);
                ft_list_print_ref(list_1);
                printf(" == ");
                ft_list_print_ref(list_2);
                if (ft_list_diff_ref(list_1, list_2) == 0)
                {
                    printf(" OK\n");
                }
                else
                {
                    printf(" KO\n");
                    ret_value = 1;
                }
                ft_list_clear_ref(list_1, free);
                ft_list_clear_ref(list_2, free);
            }
        }
    }
    return (ret_value);
}
