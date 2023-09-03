all:
BUILD	:= debug

build_dir := ${BUILD}
srcs_dir := srcs

LIB	:= libasm.a
LIB_BONUS	:= libasm_bonus.a
BIN_CHECK	:= test_libasm
BIN_CHECK_BONUS	:= test_libasm_bonus

libs	:= ${LIB}
libs_bonus	:= ${LIB_BONUS}
exes	:= ${BIN_CHECK}
exes_bonus	:= ${BIN_CHECK_BONUS}

SRCS	:= ft_strlen.s	\
		   ft_strcpy.s	\
		   ft_strcmp.s	\
		   ft_write.s	\
		   ft_read.s	\
		   ft_strdup.s
SRCS_BONUS	:= ${SRCS}	\
			   ft_atoi_base_bonus.s	\
			   ft_list_push_front_bonus.s	\
			   ft_list_size_bonus.s	\
			   ft_list_sort_bonus.s	\
			   ft_list_remove_if_bonus.s
SRCS_CHECK	:= main.c
SRCS_CHECK_BONUS	:= main_bonus.c

OBJS	:= ${SRCS:.s=.o}
OBJS_BONUS	:= ${SRCS_BONUS:.s=.o}
OBJS_CHECK	:= ${SRCS_CHECK:.c=.o}
OBJS_CHECK_BONUS	:= ${SRCS_CHECK_BONUS:.c=.o}

DEPS	:= ${OBJS:.o=.d}
DEPS_BONUS	:= ${OBJS_BONUS:.o=.d}
DEPS_CHECK	:= ${OBJS_CHECK:.o=.d}
DEPS_CHECK_BONUS	:= ${OBJS_CHECK_BONUS:.o=.d}

-include ${addprefix ${build_dir}/, ${DEPS} ${DEPS_BONUS} ${DEPS_CHECK} ${DEPS_CHECK_BONUS}}

CC	:= clang
AS	:= nasm
AR	:= ar
RM	:= rm -rf

CFLAGS.debug	:= -O0 -g3 -fsanitize=address -fsanitize=undefined -fsanitize=leak
CFLAGS.release	:= -O3
CFLAGS	:= -Wall -Wextra -Werror ${CFLAGS.${BUILD}}

LDLIBS	:= -lc -L${build_dir} -l:${LIB}
LDLIBS_BONUS	:= -lc -L${build_dir} -l:${LIB_BONUS}

LDFLAGS.debug	:= -g3 -fsanitize=address -fsanitize=undefined -fsanitize=leak
LDFLAGS.release	:= -O3
LDFLAGS	:= ${LDFLAGS.${BUILD}}

ASFLAGS.nasm	:= -f elf64 -w+allerror
ASFLAGS := ${ASFLAGS.${AS}}

ARFLAGS	:= rcs

COMPILE.C	= ${CC} -MMD -MP ${CFLAGS} -c $< -o $@
COMPILE.ASM	= ${AS} ${ASFLAGS} $< -o $@
LINK	= ${CC} ${LDFLAGS} ${filter-out Makefile, $^} ${LDLIBS} -o $@
LINK_BONUS	= ${CC} ${LDFLAGS} ${filter-out Makefile, $^} ${LDLIBS_BONUS} -o $@
ARCHIVE	= ${AR} ${ARFLAGS} $@ ${filter-out Makefile, $^}

all: ${libs:%=${build_dir}/%}

bonus: ${libs_bonus:%=${build_dir}/%}

${build_dir}:
	mkdir $@

${build_dir}/%.o: ${srcs_dir}/%.c Makefile | ${build_dir}
	${strip ${COMPILE.C}}

${build_dir}/%.o: ${srcs_dir}/%.s Makefile | ${build_dir}
	${strip ${COMPILE.ASM}}

${build_dir}/${LIB}: ${addprefix ${build_dir}/, ${OBJS}} Makefile | ${build_dir}
	${strip ${ARCHIVE}}

${build_dir}/${LIB_BONUS}: ${addprefix ${build_dir}/, ${OBJS_BONUS}} Makefile | ${build_dir}
	${strip ${ARCHIVE}}

${build_dir}/${BIN_CHECK}: ${addprefix ${build_dir}/, ${OBJS_CHECK}} Makefile | ${LIB} ${build_dir}
	${strip ${LINK}}

${build_dir}/${BIN_CHECK_BONUS}: ${addprefix ${build_dir}/, ${OBJS_CHECK_BONUS}} Makefile | ${LIB_BONUS} ${build_dir}
	${strip ${LINK_BONUS}}

${LIB}: ${build_dir}/${LIB}

${LIB_BONUS}: ${build_dir}/${LIB_BONUS}

clean:
	${RM} ${addprefix ${build_dir}/, ${OBJS} ${DEPS}}

fclean:
	${RM} ${build_dir}

re: fclean all

check: all ${exes:%=${build_dir}/%}
	./${build_dir}/${BIN_CHECK}

check_bonus: bonus ${exes_bonus:%=${build_dir}/%}
	./${build_dir}/${BIN_CHECK_BONUS}

.PHONY: all bonus clean fclean re ${LIB} ${LIB_BONUS}
