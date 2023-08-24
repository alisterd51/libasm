#include <stdio.h>
#include "libasm.h"

int main() {
    char    *str = "hello";

    printf("%s: %zu\n", str, ft_strlen(str));
}
