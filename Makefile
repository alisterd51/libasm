all:
BUILD	:= debug

build_dir := ${BUILD}
srcs_dir := srcs

LIB	:= libasm.a
LIB_BONUS	:= libasm_bonus.a
BIN_CHECK	:= test_libasm
BIN_CHECK_BONUS	:= test_libasm_bonus

libs	:= ${LIB}
exes	:= ${BIN_CHECK}

SRCS	:= ft_strlen.s	\
		   ft_strcpy.s	\
		   ft_strcmp.s	\
		   ft_write.s	\
		   ft_read.s	\
		   ft_strdup.s
SRCS_BONUS	:= ${SRCS}	\
			   
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
AS	:= clang
AR	:= ar rcs

CFLAGS.debug	:= -O0 -g3 -fsanitize=address -fsanitize=undefined -fsanitize=leak
CFLAGS.release	:= -O3
CFLAGS	:= -Wall -Wextra -Werror ${CFLAGS.${BUILD}}

LDLIBS	:= -lc -L${build_dir} -l:${LIB}

LDFLAGS.debug	:= -g3 -fsanitize=address -fsanitize=undefined -fsanitize=leak
LDFLAGS.release	:= -O3
LDFLAGS	:= ${LDFLAGS.${BUILD}}

ASFLAGS.clang	:= -masm=intel
ASFLAGS := ${ASFLAGS.${AS}}

COMPILE.C	= ${CC} -MMD -MP ${CFLAGS} -c $< -o $@
COMPILE.ASM	= ${AS} ${ASFLAGS} -c $< -o $@
LINK	= ${CC} ${LDFLAGS} ${filter-out Makefile, $^} ${LDLIBS} -o $@
ARCHIVE	= ${AR} $@ ${filter-out Makefile, $^}

all: ${libs:%=${build_dir}/%}

${build_dir}:
	mkdir $@

${build_dir}/%.o: ${srcs_dir}/%.c Makefile | ${build_dir}
	${strip ${COMPILE.C}}

${build_dir}/%.o: ${srcs_dir}/%.s Makefile | ${build_dir}
	${strip ${COMPILE.ASM}}

${build_dir}/${LIB}: ${addprefix ${build_dir}/, ${OBJS}} Makefile | ${build_dir}
	${strip ${ARCHIVE}}

${build_dir}/${BIN_CHECK}: ${addprefix ${build_dir}/, ${LIB} ${OBJS_CHECK}} Makefile | ${build_dir}
	${strip ${LINK}}

${LIB}: ${build_dir}/${LIB}

clean:
	rm -f ${addprefix ${build_dir}/, ${OBJS} ${DEPS}}

fclean:
	rm -rf ${build_dir}

re: fclean all

check: all ${exes:%=${build_dir}/%}
	./${build_dir}/${BIN_CHECK}

.PHONY: all clean fclean re ${LIB}
